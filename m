From: Matt <jackdachef@gmail.com>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 14:44:14 +0100
Message-ID: <AANLkTi=OdYh0j4siMV1zzRQaRBEmi1nkjTcqHhM5tZH0@mail.gmail.com>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
	<AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
	<4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
	<AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
	<20101205100954.GA6564@fritha.org>
	<4CFB679D.5030900@redhat.com>
	<1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 5, 2010 at 2:24 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Dec 5, 2010, at 5:21 AM, Milan Broz wrote:
>>
>> Which kernel? 2.6.37-rc?
>>
>> Anyone seen this with 2.6.36 and the same dmcrypt patch?
>> (All info I had is that is is stable with here.)
>>
>> It still seems to like dmcrypt with its parallel processing is just
>> trigger to another bug in 37-rc.
>
> I've been using a kernel which is between 2.6.37-rc2 and -rc3 with a =
LUKS / dm-crypt / LVM / ext4 setup for my primary file systems, and I h=
aven't observed any corruption for the last two weeks or so. =A0 It's o=
n my todo list to upgrade to top of Linus's tree, but perhaps this is a=
 useful data point.
>
> As another thought, what version of GCC are people using who are havi=
ng difficulty? =A0 Could this perhaps be a compiler-related issue?
>
> -- Ted
>
>

Hi Ted,

to quote its output:


gcc -v
Using built-in specs.
COLLECT_GCC=3D/usr/x86_64-pc-linux-gnu/gcc-bin/4.5.1/gcc
COLLECT_LTO_WRAPPER=3D/usr/libexec/gcc/x86_64-pc-linux-gnu/4.5.1/lto-wr=
apper
Target: x86_64-pc-linux-gnu
Configured with:
/var/tmp/portage/sys-devel/gcc-4.5.1-r1/work/gcc-4.5.1/configure
--prefix=3D/usr --bindir=3D/usr/x86_64-pc-linux-gnu/gcc-bin/4.5.1
--includedir=3D/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.1/include
--datadir=3D/usr/share/gcc-data/x86_64-pc-linux-gnu/4.5.1
--mandir=3D/usr/share/gcc-data/x86_64-pc-linux-gnu/4.5.1/man
--infodir=3D/usr/share/gcc-data/x86_64-pc-linux-gnu/4.5.1/info
--with-gxx-include-dir=3D/usr/lib/gcc/x86_64-pc-linux-gnu/4.5.1/include=
/g++-v4
--host=3Dx86_64-pc-linux-gnu --build=3Dx86_64-pc-linux-gnu
--disable-altivec --disable-fixed-point --with-ppl --with-cloog
--enable-lto --enable-nls --without-included-gettext
--with-system-zlib --disable-werror --enable-secureplt
--enable-multilib --enable-libmudflap --disable-libssp --enable-esp
--enable-libgomp --enable-cld
--with-python-dir=3D/share/gcc-data/x86_64-pc-linux-gnu/4.5.1/python
--enable-checking=3Drelease --enable-java-awt=3Dgtk --enable-objc-gc
--enable-languages=3Dc,c++,java,objc,obj-c++,fortran --enable-shared
--enable-threads=3Dposix --enable-__cxa_atexit --enable-clocale=3Dgnu
--with-bugurl=3Dhttp://bugs.gentoo.org/ --with-pkgversion=3D'Gentoo
Hardened 4.5.1-r1 p1.4, pie-0.4.5'
Thread model: posix
gcc version 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5)


output of emerge -p gcc:

These are the packages that would be merged, in order:

Calculating dependencies                                  ... done!
[ebuild   R   ] sys-devel/gcc-4.5.1-r1  USE=3D"fortran gcj graphite gtk
hardened lto mudflap (multilib) multislot nls nptl objc objc++ objc-gc
openmp (-altivec) -bootstrap -build -doc (-fixed-point) (-libffi)
(-n32) (-n64) -nocxx -nopie -nossp -test -vanilla" 0 kB



and to be precise it's gcc 4.5.1 with some gentoo-specific fixes and
fixes from upstream (4.5.2) [take a look at patchset 1.4],
in my case it also has the --enable-esp functionality [hardened]
which should include something like -D_FORTIFY_SOURCE=3D2, -fstack-prot=
ector-all
and for linking/ldd: -Wl,-z,now -Wl,-z,relro

(I don't know if the part with the linker and the fstack-protector is a=
ccurate)

I'm adding below the output of mount of the system-partition of the
system I was running the kernel on - where the [more observable]
corruption was observed (checkout
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc)
-> this output got generated while I mounted it from my working (no
corruption observed) system with 2.6.36 kernel - I don't know if it's
useful - just in case you might need it
[forgot to post this in my last email]

Thanks & Regards

Matt



[  607.849644] EXT4-fs (dm-7): INFO: recovery required on readonly file=
system
[  607.849651] EXT4-fs (dm-7): write access will be enabled during reco=
very
[  609.559363] EXT4-fs (dm-7): orphan cleanup on readonly fs
[  609.559375] EXT4-fs (dm-7): ext4_orphan_cleanup: truncating inode
2238873 to 0 bytes
[  609.559493] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231865
[  609.559531] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231870
[  609.559553] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396001
[  609.559588] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396036
[  609.559610] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2395699
[  609.559675] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231859
[  609.559695] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231868
[  609.559715] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396696
[  609.559736] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396697
[  609.559755] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396699
[  609.559775] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2395948
[  609.559809] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231856
[  609.559830] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231866
[  609.559850] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239446
[  609.559872] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239447
[  609.559892] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239454
[  609.559912] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239458
[  609.559933] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239033
[  609.559992] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231858
[  609.560012] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231862
[  609.560033] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393696
[  609.560054] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393697
[  609.560074] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393698
[  609.560094] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2395268
[  609.582087] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231130
[  609.582147] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231860
[  609.582179] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2371247
[  609.595564] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2371250
[  609.605893] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2373715
[  609.605928] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393813
[  609.605958] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231417
[  609.605980] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231854
[  609.605999] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231864
[  609.606019] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239111
[  609.606039] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239113
[  609.606069] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239114
[  609.606099] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239120
[  609.608409] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231602
[  609.608452] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231861
[  609.608483] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239420
[  609.608512] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239421
[  609.608542] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239426
[  609.608572] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239637
[  609.608604] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231603
[  609.608634] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231855
[  609.608664] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255714
[  609.608694] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255715
[  609.608723] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255739
[  609.608753] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255645
[  609.608797] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2141218
[  609.608844] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2140971
[  609.630666] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2141266
[  609.630700] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2141267
[  609.630722] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2394877
[  609.630743] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396476
[  609.630765] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396489
[  609.630794] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396512
[  609.642390] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2229825
[  609.642433] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231604
[  609.657435] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393858
[  609.657476] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393859
[  609.657505] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393860
[  609.657535] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2394679
[  609.658623] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393493
[  609.659363] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2393462
[  609.659404] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135731
[  609.684858] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135728
[  609.684904] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239357
[  609.685239] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239362
[  609.697558] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239396
[  609.697604] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239335
[  609.697703] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310848
[  609.710785] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310828
[  609.713278] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231128
[  609.713311] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231418
[  609.713342] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256648
[  609.713371] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256649
[  609.713400] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256650
[  609.713429] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255701
[  609.713481] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231129
[  609.713511] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239633
[  609.713540] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256006
[  609.713570] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239354
[  609.734696] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118116
[  609.734739] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118050
[  609.734771] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256652
[  609.734797] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256654
[  609.734817] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256655
[  609.734847] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239608
[  609.734893] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118049
[  609.734922] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118048
[  609.734951] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135750
[  609.734981] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2257151
[  609.738316] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2374676
[  609.738352] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256865
[  609.738379] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118047
[  609.738399] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118046
[  609.738419] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256098
[  609.738439] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256099
[  609.738458] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256100
[  609.738477] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239408
[  609.738502] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2115691
[  609.742723] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111912
[  609.742771] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2141299
[  609.753070] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239521
[  609.753105] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239016
[  609.753130] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111888
[  609.753151] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111865
[  609.753172] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256464
[  609.753192] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256500
[  609.753212] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239402
[  609.753235] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111910
[  609.753255] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111900
[  609.762311] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144754
[  609.762353] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144757
[  609.762400] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144771
[  609.762428] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144772
[  609.762447] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144773
[  609.762466] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144774
[  609.762486] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310823
[  609.762507] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310900
[  609.763591] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2145297
[  609.763700] EXT4-fs (dm-7): 122 orphan inodes deleted
[  609.763708] EXT4-fs (dm-7): 1 truncate cleaned up
[  609.763714] EXT4-fs (dm-7): recovery complete
[  610.593272] EXT4-fs (dm-7): mounted filesystem with ordered data
mode. Opts: commit=3D600,barrier=3D1
