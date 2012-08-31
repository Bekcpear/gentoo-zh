# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit toolchain-funcs

MY_P="FreeFileSync"

DESCRIPTION="Visual folder comparison and synchronization"
HOMEPAGE=""
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_${PV}_source.zip"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+realtime"

DEPEND="x11-libs/wxGTK[X]
	dev-libs/boost
	x11-libs/gtk+:2"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

tweak_makefile(){
	CXX=$(tc-getBUILD_CXX)

	sed "s/COMMON_COMPILE_FLAGS = -Wall -pipe -O3/COMMON_COMPILE_FLAGS = $CXXFLAGS /g" -i "$1"
	sed "s/COMMON_LINK_FLAGS    =/COMMON_LINK_FLAGS    = $LDFLAGS /g" -i "$1"

	sed "s/g++/$CXX/g" -i "$1"

	echo  >> "$1"
	echo  >> "$1"

	echo CXX=\""$CXX"\" >> "$1"
}


src_prepare(){
	tweak_makefile Makefile
	tweak_makefile RealtimeSync/Makefile
}

src_compile(){
	emake

	use realtime && emake -C RealtimeSync
}

src_install(){
	einstall
	use realtime && einstall -C RealtimeSync
}
