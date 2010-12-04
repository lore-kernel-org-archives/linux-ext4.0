From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 5 Dec 2010 00:47:11 +0100
Message-ID: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
References: <4CE05A9E.9090204@redhat.com>
	<AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
	<AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
	<20101201165229.GC13415@redhat.com>
	<AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
	<4CF692D1.1010906@redhat.com>
	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
	<4CF6B3E8.2000406@redhat.com>
	<20101201212310.GA15648@redhat.com>
	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
	<20101204193828.GB13871@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101204193828.GB13871@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 4, 2010 at 8:38 PM, Mike Snitzer <snitzer@redhat.com> wrote=
:
> On Sat, Dec 04 2010 at =A02:18pm -0500,
> Matt <jackdachef@gmail.com> wrote:
>
>> On Wed, Dec 1, 2010 at 10:23 PM, Mike Snitzer <snitzer@redhat.com> w=
rote:
>> > Matt and Jon,
>> >
>> > If you'd be up to it: could you try testing your dm-crypt+ext4
>> > corruption reproducers against the following two 2.6.37-rc commits=
:
>> >
>> > 1) 1de3e3df917459422cb2aecac440febc8879d410
>> > then
>> > 2) bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
>> >
>> > Then, depending on results of no corruption for those commits, bon=
us
>> > points for testing the same commits but with Andi and Milan's late=
st
>> > dm-crypt cpu scalability patch applied too:
>> > https://patchwork.kernel.org/patch/365542/
>> >
>> > Thanks!
>> > Mike
>> >
>>
>> Hi Mike,
>>
>> it seems like there isn't even much testing to do:
>>
>> I tested all 3 commits / checkouts by re-compiling gcc which was/is
>> the 2nd easy way to trigger this "corruption", compiling google's
>> chromium (v9) and looking at the output/existance of gcc, g++ and
>> eselect opengl list
>
> Can you be a bit more precise about what you're doing to reproduce?
> What sequence? =A0What (if any) builds are going in parallel? =A0Etc.
>

sure:

running on a core i7 860,
~amd64, with MAKEOPTS=3D"-j9", -march=3Dnative -pipe

parallel-build or other features are not enabled so it's always only
one program serial running/compiling

emerge -1 sys-devel/gcc -v
in the past after that the output of
eselect opengl list

with a very high probability would be corrupted (the descriptions at
the top NOT but the (dynamic) paths to the opengl files) - I'm running
fglrx/catalyst from AMD so (unfortunately) it's a tainted kernel with
a Radeon HD 5850 (I'm currently having problems to get the evergreen
xf86-video-ati driver to run so I use fglrx)
so it would display

eselect opengl list
Available OpenGL implementations:
  [1]   ati
  [2]   xorg-x11

instead of

eselect opengl list
Available OpenGL implementations:
  [1]   ati *
  [2]   xorg-x11

(mark the *)

and

instead of

cat /etc/env.d/03opengl
# Configuration file for eselect
# This file has been automatically generated.
LDPATH=3D"//usr/lib32/opengl/ati/lib://usr/lib64/opengl/ati/lib"
OPENGL_PROFILE=3D"ati"

it would be

cat /etc/env.d/03opengl
# Configuration file for eselect
# This file has been automatically generated.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@

or something similar nonsensical


other things I did/tested for after every 10-50 packages got emerged:

gcc-config -l
<-- check whether output is correct and (still) properly set

eselect opengl list
<-- check whether output is correct and (still) properly set

gcc -v

ldd

g++

(those files or files having to do with them got corrupted with a
higher probability in the past)

also programs such as firefox and chromium, gedit, etc. would have
missing libraries and/or didn't run anymore or would hang (having a Dl
or D in htop - I don't know what Dl means)

the environment I was in was vtwm, twm or sometimes even gnome running
from the root-account (to test stuff)

>> so far everything went fine
>>
>> After that I used the new patch (v6 or pre-v6), before that I had to
>>
>> replace WQ_MEM_RECLAIM with WQ_RESCUER
>>
>> and, re-compiled the kernels
>>
>> shortly after I had booted up the system with the first kernel
>> (http://git.eu.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.g=
it;a=3Dcommit;h=3D5a87b7a5da250c9be6d757758425dfeaf8ed3179)
>> the output of 'eselect opengl list' did show no opengl backend
>> selected
>>
>> so it seems to manifest itself even earlier (ext4: call
>> mpage_da_submit_io() from mpage_da_map_blocks()) even if only subtly
>> and over time -
>> I'm still currently running that kernel and posting from it & having=
 tests run
>
> OK.

meanwhile I think I got some interesting news:

after some time of running (around 1 to 1.5 hours) I noticed the
following BUG with ext4:

[ 4421.503477] ------------[ cut here ]------------
[ 4421.503482] kernel BUG at fs/ext4/inode.c:2714!
[ 4421.503484] invalid opcode: 0000 [#1] PREEMPT SMP
[ 4421.503487] last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:07:06.0/local_cpus
[ 4421.503489] CPU 5
[ 4421.503490] Modules linked in: iptable_filter ipt_addrtype
xt_iprange xt_conntrack xt_hashlimit xt_string xt_DSCP xt_NFQUEUE
xt_connmark nf_conntrack xt_mark xt_multiport xt_dscp xt_owner
ip_tables x_tables it87 hwmon_vid coretemp hwmon fglrx(P) i2c_i801 wmi
shpchp e1000e libphy e1000 scsi_wait_scan sl811_hcd ohci_hcd ssb
usb_storage ehci_hcd [last unloaded: tg3]
[ 4421.503513]
[ 4421.503516] Pid: 4541, comm: jbd2/dm-2-8 Tainted: P
2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879d410+ #2 FMP55/ipower
G3710
[ 4421.503519] RIP: 0010:[<ffffffff8119cef3>]  [<ffffffff8119cef3>]
ext4_writepage+0x243/0x250
[ 4421.503526] RSP: 0018:ffff8801bc3dfb50  EFLAGS: 00010246
[ 4421.503528] RAX: 800000000002002d RBX: ffffea00047e9190 RCX: 0000000=
000000030
[ 4421.503530] RDX: 0000000000000040 RSI: ffff8801bc3dfcc0 RDI: ffffea0=
0047e9190
[ 4421.503531] RBP: ffff88015d52c120 R08: ffff88012bffede8 R09: 0000000=
000000000
[ 4421.503533] R10: 0000000000000001 R11: 0000000000000008 R12: 0000000=
000001000
[ 4421.503535] R13: ffffea00047e9190 R14: ffff8801bc3dfcc0 R15: ffff880=
1bc3dfc30
[ 4421.503538] FS:  0000000000000000(0000) GS:ffff880002140000(0000)
knlGS:0000000000000000
[ 4421.503540] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4421.503542] CR2: 00007f824cff07e0 CR3: 0000000001c04000 CR4: 0000000=
0000006e0
[ 4421.503544] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 4421.503546] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 4421.503548] Process jbd2/dm-2-8 (pid: 4541, threadinfo
ffff8801bc3de000, task ffff8801bfe3d040)
[ 4421.503549] Stack:
[ 4421.503551]  ffff88015d52c288 ffff88015d52c288 ffff88015d52c288
0000000000000040
[ 4421.503554] <0> ffffea00047e9190 0000000000000007 ffff8801bc3dfc30
ffffffff810a261d
[ 4421.503558] <0> 000000000000000a ffffffff810a2ab1 0000000000000019
ffff8801bc3dfcc0
[ 4421.503562] Call Trace:
[ 4421.503568]  [<ffffffff810a261d>] ? __writepage+0xd/0x40
[ 4421.503571]  [<ffffffff810a2ab1>] ? write_cache_pages+0x1b1/0x3d0
[ 4421.503574]  [<ffffffff810a2610>] ? __writepage+0x0/0x40
[ 4421.503579]  [<ffffffff811d1129>] ? journal_submit_data_buffers+0x99=
/0x100
[ 4421.503583]  [<ffffffff811d1671>] ?
jbd2_journal_commit_transaction+0x331/0x1330
[ 4421.503588]  [<ffffffff8172064b>] ? schedule+0x37b/0x8d0
[ 4421.503591]  [<ffffffff817234c8>] ? _raw_spin_lock_irqsave+0x18/0x20
[ 4421.503596]  [<ffffffff810538c3>] ? lock_timer_base.clone.23+0x33/0x=
70
[ 4421.503599]  [<ffffffff8105396e>] ? try_to_del_timer_sync+0x6e/0x90
[ 4421.503602]  [<ffffffff811d5651>] ? kjournald2+0xb1/0x210
[ 4421.503606]  [<ffffffff81062b80>] ? autoremove_wake_function+0x0/0x3=
0
[ 4421.503609]  [<ffffffff811d55a0>] ? kjournald2+0x0/0x210
[ 4421.503611]  [<ffffffff811d55a0>] ? kjournald2+0x0/0x210
[ 4421.503614]  [<ffffffff81062706>] ? kthread+0x96/0xa0
[ 4421.503619]  [<ffffffff81003394>] ? kernel_thread_helper+0x4/0x10
[ 4421.503622]  [<ffffffff81062670>] ? kthread+0x0/0xa0
[ 4421.503625]  [<ffffffff81003390>] ? kernel_thread_helper+0x0/0x10
[ 4421.503626] Code: ff eb 85 0f 1f 44 00 00 8b 42 70 25 00 0c 00 00
3d 00 04 00 00 74 a4 48 8b 85 78 ff ff ff f6 c4 40 0f 84 6e fe ff ff
eb 92 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 ba 01
00 00
[ 4421.503654] RIP  [<ffffffff8119cef3>] ext4_writepage+0x243/0x250
[ 4421.503658]  RSP <ffff8801bc3dfb50>
[ 4421.503660] ---[ end trace e4015dccdd3e00bb ]---

kernel compiled was from sources checked out at
1de3e3df917459422cb2aecac440febc8879d410

after that I counter-checked logs and couldn't find anything similar
for 5a87b7a5da250c9be6d757758425dfeaf8ed3179 (that checkout/commit
seemingly worked fine besides the
little "anomaly" of the empty/not set /etc/env.d/03opengl - I didn't
observe anything else broken on that one)

seems 1de3e3df917459422cb2aecac440febc8879d410 might be a possible
candidate ... (strangely I didn't observe any corruption with that -
everything seemed to still be there except the BUG entry in dmesg and
the not anymore working system [apps not wanting to close or open,
hardlocks -> pointing to a filesystem issue which I already had
experienced in a similar way with other filesystems in the past] -
maybe bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc leads to corruption, I
don't know ?)

I ASAP saved the output to my /boot partition (reiserfs) and wanted to
send you a mail but firefox didn't work anymore correctly at that time
- so I wanted to close and restart it (at that time I was running
vtwm),
firefox (via gksu) like above mentioned it showed D or Dl from htop
and couldn't be closed - also not via killall -9

chromium and other apps also stopped to work (I couldn't launch them
anymore, also not via root-account/xterm),

as a last resort I wanted to close the (launched via gksu) running
terminal and open up another one via gksu -> terminal (selecting a
user-account)

shortly after that the box hardlocked (even magic SYSRQ key didn't
work anymore, numlock and caps lock also didn't work - I'm using a
usb-keyboard, perhaps a PS/2 keyboard would have helped but the PS/2
port of my system doesn't work that well/at all under linux and
windows [a bios problem]

summary/reference:
activities: regular stuff - such as browsing the web, hearing to mp3
files, streaming webradio, etc.

system activies: emerge sys-devel/gcc -1 && emerge -e system

testing/checking: gcc -v; ldd; g++; gcc-config -l; eselect opengl
list; cat /etc/env.d/03opengl

mount-options: noatime,commit=3D600 [now]; during previous tests/usage:
noatime,nodiratime,barrier=3D1,commit=3D600

i/o scheduler: CFQ (I have deadline set at boot because that one works
more reliable in case something's broken with CFS; after boot has
completed I manually switch to CFQ)

kernel: using the mentioned kernels compiled with genkernel (for
support with lvm and luks/cryptsetup)

compile via: genkernel --makeopts=3D"-j16" --luks --dmraid --lvm all
--kernname=3D37_rc-checkout-name --no-clean

(sys-kernel/genkernel version is: genkernel-3.4.10.907-r3.ebuild [from
sabayon-overlay]; there shouldn't be much difference to the one in the
portage-tree: 3.4.10.907-r1)

partitioning: cryptsetup (around 30 GiB partition) [e.g. MAIN] ->
pvcreate /dev/mapper/MAIN
vgcreate GENTOO /dev/mapper/MAIN
lvcreate -L9200M -nSWAP GENTOO
lvcreate -l100%FREE -nROOT GENTOO

so cryptsetup -> LVM -> ROOT (20 GiB) and SWAP (around 9200 MiB) -> on
ROOT (ext4)

filesystem: mkfs.ext4 (default settings; other settings didn't make a
change if the corruption/problems occured or not)

system characteristics:

eselect profile list
Available profile symlink targets:
  [1]   default/linux/amd64/10.0
  [2]   default/linux/amd64/10.0/desktop *
  [3]   default/linux/amd64/10.0/desktop/gnome
  [4]   default/linux/amd64/10.0/desktop/kde

gcc version 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5)

Portage 2.2.0_alpha6 (default/linux/amd64/10.0/desktop, gcc-4.5.1,
glibc-2.12.1-r3, 2.6.36.1_plus_v4_TOI x86_64)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
System uname: Linux-2.6.36.1_plus_v4_TOI-x86_64-Intel-R-_Core-TM-_i7_CP=
U_860_@_2.80GHz-with-gentoo-2.0.1
Timestamp of tree: Thu, 02 Dec 2010 07:15:02 +0000
app-shells/bash:     4.1_p7
dev-java/java-config: 2.1.11-r1
dev-lang/python:     2.6.6-r1, 3.1.2-r4
dev-util/cmake:      2.8.1-r2
sys-apps/baselayout: 2.0.1
sys-apps/openrc:     0.6.3
sys-apps/sandbox:    2.3-r1
sys-devel/autoconf:  2.13, 2.68
sys-devel/automake:  1.4_p6-r1, 1.5-r1, 1.6.3-r1, 1.7.9-r2, 1.8.5-r4,
1.9.6-r3, 1.10.3, 1.11.1
sys-devel/binutils:  2.20.1, 2.20.51.0.10, 2.20.51.0.11, 2.20.51.0.12,
2.21.51.0.1
sys-devel/gcc:       4.3.5, 4.4.4-r1, 4.5.1-r1
sys-devel/gcc-config: 1.4.1
sys-devel/libtool:   2.2.10
sys-devel/make:      3.82
virtual/os-headers:  2.6.35 (sys-kernel/linux-headers)
Repositories: gentoo kist piczu jasiu portage kde kde-sunset
qting-edge desktop-effects java-overlay java-experimental sunrise voip
jokey-overlay virtualbox-overlay vmware suka-overlay hardened-dev
tallica-overlay mozilla geki-overlay
ACCEPT_KEYWORDS=3D"amd64 ~amd64"
ACCEPT_LICENSE=3D"* @EULA skype-eula PUEL dlj-1.1 sun-bcla-java-vm
googleearth AdobeFlash-10"
CBUILD=3D"x86_64-pc-linux-gnu"
CFLAGS=3D"-O2 -march=3Dnative -pipe -fno-ident -mno-push-args
-maccumulate-outgoing-args -mno-align-stringops
-minline-stringops-dynamically"
CHOST=3D"x86_64-pc-linux-gnu"
CONFIG_PROTECT=3D"/etc /usr/kde/3.5/env /usr/kde/3.5/share/config
/usr/kde/3.5/shutdown /usr/share/config /var/lib/hsqldb"
CONFIG_PROTECT_MASK=3D"/etc/X11/xorg.conf /etc/ca-certificates.conf
/etc/env.d /etc/env.d/java/ /etc/eselect/postgresql
/etc/fonts/fonts.conf /etc/gconf /etc/gentoo-release
/etc/php/apache2-php5.3/ext-active/ /etc/php/cgi-php5.3/ext-active/
/etc/php/cli-php5.3/ext-active/ /etc/revdep-rebuild /etc/sandbox.d
/etc/terminfo /etc/texmf/language.dat.d /etc/texmf/language.def.d
/etc/texmf/updmap.d /etc/texmf/web2c /usr/X11R6/bin/startx"
CXXFLAGS=3D"-O2 -march=3Dnative -pipe -fno-ident -mno-push-args
-maccumulate-outgoing-args -mno-align-stringops
-minline-stringops-dynamically"
DISTDIR=3D"/usr/portage/distfiles"
EMERGE_DEFAULT_OPTS=3D"--keep-going"
=46EATURES=3D"assume-digests binpkg-logs candy distlocks fixlafiles
fixpackages metadata-transfer news parallel-fetch preserve-libs
protect-owned sandbox sfperms strict unknown-features-warn
unmerge-logs unmerge-orphans userfetch usersandbox"
GENTOO_MIRRORS=3D"ftp://ftp-stud.fht-esslingen.de/pub/Mirrors/gentoo/
ftp://de-mirror.org/distro/gentoo/
ftp://ftp.spline.inf.fu-berlin.de/mirrors/gentoo/
http://mirror.jamit.de/gentoo/ ftp://mirror.netcologne.de/gentoo/
ftp://mirror.ovh.net/gentoo-distfiles/"
LANG=3D"en_US.utf8"
LDFLAGS=3D"-Wl,-O1 -Wl,-z,combreloc -Wl,-z,now -Wl,-z,relro
-Wl,--as-needed -Wl,--hash-style=3Dboth -Wl,--sort-common
-Wl,--enable-new-dtags -Wl,--relax"
# most of those are covered via the hardened toolchain and gentoo
defaults, setting them explicitly anyway
LINGUAS=3D"de en"
MAKEOPTS=3D"-j9"
PKGDIR=3D"/usr/portage/packages"
PORTAGE_CONFIGROOT=3D"/"
PORTAGE_RSYNC_OPTS=3D"--recursive --links --safe-links --perms --times
--compress --force --whole-file --delete --stats --timeout=3D180
--exclude=3D/distfiles --exclude=3D/local --exclude=3D/packages"
PORTAGE_TMPDIR=3D"/var/tmp"
PORTDIR=3D"/usr/gentoo/portage"
PORTDIR_OVERLAY=3D"/usr/local/portage/layman/kist-overlay
/usr/local/portage/layman/piczu /usr/local/portage/layman/jasiu
/usr/gentoo/overlays /usr/gentoo/overlays/kde-testing
/usr/gentoo/overlays/kde-sunset /usr/gentoo/overlays/qting-edge
/usr/gentoo/overlays/desktop-effects /usr/gentoo/overlays/java
/usr/gentoo/overlays/java-experimental /usr/gentoo/overlays/sunrise
/usr/gentoo/overlays/voip /usr/gentoo/overlays/jokey
/usr/gentoo/overlays/virtualbox /usr/gentoo/overlays/vmware
/usr/gentoo/overlays/suka /usr/gentoo/overlays/hardened-dev
/usr/gentoo/overlays/tallica /usr/gentoo/overlays/mozilla
/usr/gentoo/overlays/gekis-playground"
SYNC=3D"rsync://rsync.europe.gentoo.org/gentoo-portage"
USE=3D"X a52 aac aalib acl acpi akonadi alsa amd64 aspell audio avahi
berkdb bluetooth branding bsf bzip2 cairo cdda cddb cdr cjk cleartype
cli consolekit contrast cracklib crypt cups curl cxx dbus
device-mapper djvu dmraid dri dts dvd dvdr dvi ebook eds emboss encode
exif extensions extras faac faad fam fat fax fbcon ffmpeg fftw firefox
flac fontconfig fortran fuse gd gdbm gdu gif gimp glade gmp gnome
gnome-vfs gnutls gpm gsf gstreamer gtk guile hal handbook hardened
hashstyle hfs html iconv id3tag idn imagemagick imlib inotify ipv6
ithreads java javascript jfs jpeg jpeg2k kde kdehiddenvisibility kipi
lame latex lcms ldap libnotify lm_sensors logrotate lzma lzo mad mdadm
mikmod mjpeg mmap mmx mng mode-paranoid modplug modules mp3 mp4 mpeg
mudflap multilib multislot musepack musicbrainz mysql mysqli ncurses
network networking networkmanager nis nls nptl nptlonly nss ntfs ogg
openexr opengl openmp pam pango pcre pdf perl pg-intdatetime phonon
pic pie pkcs11 plasma pmu png policykit postproc postscript ppds pppd
pulseaudio python qimageblitz qscintilla qt3support qt4 quicktime qwt
raster readline reiser4 reiserfs resolvconf samba sasl scanner sdl
semantic-desktop session shout slang smp sndfile sound soup spell
sqlite sse sse2 sse3 sse4 ssl ssse3 startup-notification svg sysfs
t1lib tcl tcpd theora threads thumbnail tiff tk toolbar truetype
twolame unicode urandom usb utils v4l v4l2 vcd video vorbis wav
wavpack webkit wmf x264 xcb xcomposite xfs xft xinerama xml xmp xorg
xulrunner xv xvid xvmc zip zlib" ALSA_CARDS=3D"hda-intel"
ALSA_PCM_PLUGINS=3D"adpcm alaw asym copy dmix dshare dsnoop empty
extplug file hooks iec958 ioplug ladspa lfloat linear meter mmap_emul
mulaw multi null plug rate route share shm softvol"
APACHE2_MODULES=3D"alias autoindex auth_basic authn_alias authn_anon
authn_dbm authn_default authn_file authz_default authz_groupfile
authz_host authz_owner authz_user authz_dbm cache dav dav_fs dav_lock
deflate dir disk_cache env expires ext_filter file_cache filter
headers include info mime mime_magic negotiation setenvif speling
status unique_id vhost_alias" APACHE2_MPMS=3D"worker" CAMERAS=3D"canon
casio kodak konica minolta mustek panasonic polaroid ricoh samsung
sonix sonydscf1 sonydscf55 soundvision toshiba" COLLECTD_PLUGINS=3D"df
interface irq load memory rrdtool swap syslog" ELIBC=3D"glibc"
GPSD_PROTOCOLS=3D"ashtech aivdm earthmate evermore fv18 garmin garmintx=
t
gpsclock itrax mtk3301 nmea ntrip navcom oceanserver oldstyle oncore
rtcm104v2 rtcm104v3 sirf superstar2 timing tsip tripmate tnt ubx"
INPUT_DEVICES=3D"keyboard mouse linuxinput ps2mouse serialmouse evdev"
KERNEL=3D"linux" LCD_DEVICES=3D"bayrad cfontz cfontz633 glk hd44780 lb2=
16
lcdm001 mtxorb ncurses text" LINGUAS=3D"de en" LIRC_DEVICES=3D"asusdh"
PHP_TARGETS=3D"php5-2" RUBY_TARGETS=3D"ruby18" USERLAND=3D"GNU"
VIDEO_CARDS=3D"ati vesa vga radeon r600" XTABLES_ADDONS=3D"quota2 psd
pknock lscan length2 ipv4options ipset ipp2p iface geoip fuzzy
condition tee tarpit sysrq steal rawnat logmark ipmark dhcpmac delude
chaos account"
Unset:  CPPFLAGS, CTARGET, FFLAGS, INSTALL_MASK, LC_ALL,
PORTAGE_BUNZIP2_COMMAND, PORTAGE_COMPRESS, PORTAGE_COMPRESS_FLAGS,
PORTAGE_RSYNC_EXTRA_OPTS

hardened toolchain and use-flags are unmasked via:

cat /etc/portage/profile/package.use.mask
sys-devel/gcc -hardened
sys-libs/glibc -hardened

and
USE=3D"hardened pic pie multislot"
(besides that other flags [non-hardened related] are set in USE but
those should be already covered by emerge --info above)

>
>> I'm not sure if it's even a problem with ext4 - I haven't had the ti=
me
>> to test with XFS yet - maybe it's also happening with that so it mor=
e
>> likely would be dm-core, like Milan suspected
>> (http://marc.info/?l=3Dlinux-kernel&m=3D129123636223477&w=3D2) :(
>
> It'd be interesting to try to reproduce with that same kernel but usi=
ng
> XFS. =A0I'll check with Milan on what he thinks would be the best nex=
t
> steps. =A0Ideally we'll be able to reproduce your results to aid in
> pinpointing the issue. =A0I think Milan will be trying to do so short=
ly
> (if he hasn't started already -- using gentoo emerge, etc).
>
>> even though most of the time it's compiling I don't need to do much =
-
>> I need the box for work so if my time allows next tests would be nex=
t
>> weekend and I'm back to my other partition
>>
>> I really do hope that this bugger can be nailed down ASAP - I like t=
he
>> improvements made in 2.6.37 but without the dm-crypt multi-cpu patch
>> it's only half the "fun" ;)
>
> Sure, we'll need to get to the bottom of this before we can have
> confidence sending the dm-crypt cpu scalability patch upstream.
>
> Thanks for your testing,
> Mike
>

Sure, you're welcome - I'm glad that I can help

Below attached/posted you'll find the full output of dmesg for that
session and my kernel-config (attaching file strangely doesn't seem to
work right now)

So that should be enough information to (hopefully) reproduce it or at
least fix underlying causes to prevent it in the future

Thanks & Regards

Matt









[    0.000000] Linux version
2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879d410+ (root@lupus) (gcc
version 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5) ) #2 SMP
PREEMPT Sat Dec 4 18:35:31 CET 2010
[    0.000000] Command line: dolvm root=3D/dev/ram0 init=3D/linuxrc
ramdisk=3D8192 crypt_root=3D/dev/sdd6 real_root=3D/dev/mapper/XPS-ROOT
noresume noresume2 udev ro elevator=3Ddeadline
snd-hda-intel.enable_msi=3D1 fbcon=3Dscrollback:256K pax_softmode=3D1
clocksource=3Dtsc usbcore.autosuspend=3D1 raid=3Dnoautodetect
video=3Dvesafb:mtrr:3,ywrap vga=3D794 nomodeset
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  BIOS-e820: 00000000bf780000 - 00000000bf78e000 (ACPI da=
ta)
[    0.000000]  BIOS-e820: 00000000bf78e000 - 00000000bf7d0000 (ACPI NV=
S)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000bf7ed000 - 00000000c0000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) =3D=3D> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (=
usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x1c0000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 000000000 mask E00000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x70106=
00070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 7GB, range: 1GB, type UC
[    0.000000] reg 1, base: 0GB, range: 8GB, type WB
[    0.000000] reg 2, base: 3GB, range: 1GB, type UC
[    0.000000] total RAM covered: 6144M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 4  	lose cove=
r RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 4GB, range: 2GB, type WB
[    0.000000] reg 3, base: 6GB, range: 1GB, type WB
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000
(usable) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbf780 max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved=
)
[    0.000000]  modified: 0000000000010000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved=
)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved=
)
[    0.000000]  modified: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  modified: 00000000bf780000 - 00000000bf78e000 (ACPI dat=
a)
[    0.000000]  modified: 00000000bf78e000 - 00000000bf7d0000 (ACPI NVS=
)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved=
)
[    0.000000]  modified: 00000000bf7ed000 - 00000000c0000000 (reserved=
)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved=
)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved=
)
[    0.000000]  modified: 0000000100000000 - 00000001c0000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf780000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf780000 page 4k
[    0.000000] kernel direct mapping tables up to bf780000 @ 16000-1b00=
0
[    0.000000] init_memory_mapping: 0000000100000000-00000001c0000000
[    0.000000]  0100000000 - 01c0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1c0000000 @ 19000-210=
00
[    0.000000] RAMDISK: 37cd4000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f9cf0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf780100 0006C (v01 ACRSYS ACRPRDCT
20100329 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf780290 000F4 (v04 ACRSYS FACP1137
20100329 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7805e0 07E42 (v02  926A1 926A1P15
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf78e000 00040
[    0.000000] ACPI: APIC 00000000bf780390 0008C (v02 ACRSYS APIC1137
20100329 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf780420 0003C (v01 ACRSYS OEMMCFG
20100329 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf780460 00176 (v01 ACRSYS ACRPRDCT
20100329 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf78e040 00072 (v01 ACRSYS OEMB1137
20100329 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf78a5e0 00038 (v01 ACRSYS OEMHPET
20100329 MSFT 00000097)
[    0.000000] ACPI: GSCI 00000000bf78e0c0 02024 (v01 ACRSYS GMCHSCI
20100329 MSFT 00000097)
[    0.000000] ACPI: AWMI 00000000bf7900f0 0004E (v01 ACRSYS OEMB1137
20100329 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf792c10 00363 (v01 DpgPmm    CpuPm
00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD ->
[ffff880002600000-ffff8800079fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf780
[    0.000000]     0: 0x00100000 -> 0x001c0000
[    0.000000] On node 0 totalpages: 1570573
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765880 pages, LIFO batch:31
[    0.000000]   Normal zone: 10752 pages used for memmap
[    0.000000]   Normal zone: 775680 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 0000000=
00009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000=
0000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000=
000100000
[    0.000000] PM: Registered nosave memory: 00000000bf780000 - 0000000=
0bf78e000
[    0.000000] PM: Registered nosave memory: 00000000bf78e000 - 0000000=
0bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 0000000=
0bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 0000000=
0bf7ed000
[    0.000000] PM: Registered nosave memory: 00000000bf7ed000 - 0000000=
0c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 0000000=
0fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 0000000=
0fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 0000000=
0ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000=
100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:3ee00000)
[    0.000000] early_res array is doubled to 64 at [1c000 - 1c7ff]
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880002000000 s81088
r8192 d21312 u262144
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u262144 alloc=3D1*209715=
2
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 1545485
[    0.000000] Kernel command line: dolvm root=3D/dev/ram0 init=3D/linu=
xrc
ramdisk=3D8192 crypt_root=3D/dev/sdd6 real_root=3D/dev/mapper/XPS-ROOT
noresume noresume2 udev ro elevator=3Ddeadline
snd-hda-intel.enable_msi=3D1 fbcon=3Dscrollback:256K pax_softmode=3D1
clocksource=3Dtsc usbcore.autosuspend=3D1 raid=3Dnoautodetect
video=3Dvesafb:mtrr:3,ywrap vga=3D794 nomodeset
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bai=
ling!
[    0.000000] Subtract (51 early reservations)
[    0.000000]   #1 [0001000000 - 0001ded3cc]   TEXT DATA BSS
[    0.000000]   #2 [0037cd4000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001dee000 - 0001dee243]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009dc00 - 00000fced0]   BIOS reserved
[    0.000000]   #7 [00000fd074 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fced0 - 00000fd074]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001c000]         PGTABLE
[    0.000000]   #13 [0001dee280 - 0001def280]         BOOTMEM
[    0.000000]   #14 [0001ded400 - 0001ded880]         BOOTMEM
[    0.000000]   #15 [00025f0000 - 00025f1000]         BOOTMEM
[    0.000000]   #16 [00025f1000 - 00025f2000]         BOOTMEM
[    0.000000]   #17 [0002600000 - 0007a00000]        MEMMAP 0
[    0.000000]   #18 [0001ded880 - 0001dedb00]         BOOTMEM
[    0.000000]   #19 [0001def280 - 0001e17280]         BOOTMEM
[    0.000000]   #20 [0001e17280 - 0001e3f280]         BOOTMEM
[    0.000000]   #21 [0001e40000 - 0001e41000]         BOOTMEM
[    0.000000]   #22 [0001dedb00 - 0001dedb41]         BOOTMEM
[    0.000000]   #23 [0001dedb80 - 0001dedbc3]         BOOTMEM
[    0.000000]   #24 [0001dedc00 - 0001dedea0]         BOOTMEM
[    0.000000]   #25 [0001dedec0 - 0001dedee0]         BOOTMEM
[    0.000000]   #26 [0001dedf00 - 0001dedf20]         BOOTMEM
[    0.000000]   #27 [0001e3f280 - 0001e3f3b5]         BOOTMEM
[    0.000000]   #28 [0001e3f3c0 - 0001e3f4f5]         BOOTMEM
[    0.000000]   #29 [0002000000 - 000201b000]         BOOTMEM
[    0.000000]   #30 [0002040000 - 000205b000]         BOOTMEM
[    0.000000]   #31 [0002080000 - 000209b000]         BOOTMEM
[    0.000000]   #32 [00020c0000 - 00020db000]         BOOTMEM
[    0.000000]   #33 [0002100000 - 000211b000]         BOOTMEM
[    0.000000]   #34 [0002140000 - 000215b000]         BOOTMEM
[    0.000000]   #35 [0002180000 - 000219b000]         BOOTMEM
[    0.000000]   #36 [00021c0000 - 00021db000]         BOOTMEM
[    0.000000]   #37 [0001dedf40 - 0001dedf48]         BOOTMEM
[    0.000000]   #38 [0001dedf80 - 0001dedf88]         BOOTMEM
[    0.000000]   #39 [0001dedfc0 - 0001dedfe0]         BOOTMEM
[    0.000000]   #40 [0001e3f500 - 0001e3f540]         BOOTMEM
[    0.000000]   #41 [0001e3f540 - 0001e3f660]         BOOTMEM
[    0.000000]   #42 [0001e3f680 - 0001e3f6c8]         BOOTMEM
[    0.000000]   #43 [0001e3f700 - 0001e3f748]         BOOTMEM
[    0.000000]   #44 [0001e41000 - 0001e49000]         BOOTMEM
[    0.000000]   #45 [0007a00000 - 0008200000]         BOOTMEM
[    0.000000]   #46 [00021db000 - 00025db000]         BOOTMEM
[    0.000000]   #47 [0008200000 - 000c200000]         BOOTMEM
[    0.000000]   #48 [0001e49000 - 0001e69000]         BOOTMEM
[    0.000000]   #49 [0001e69000 - 0001ea9000]         BOOTMEM
[    0.000000]   #50 [000001c800 - 0000024800]         BOOTMEM
[    0.000000] Memory: 6099300k/7340032k available (7320k kernel code,
1057740k absent, 182992k reserved, 5819k data, 548k init)
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] --------------------------------------------------------=
--------------------
[    0.000000]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]                      A-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok
|failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |failed|
 ok  |failed|failed|
[    0.000000]                   initialize
held:failed|failed|failed|failed|failed|failed|
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]               recursive read-lock:             |  ok  |
            |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |
            |failed|
[    0.000000]             mixed read-write-lock:             |failed|
            |failed|
[    0.000000]             mixed write-read-lock:             |failed|
            |failed|
[    0.000000]
-----------------------------------------------------------------------=
---
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  =
|
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  =
|
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] --------------------------------------------------------
[    0.000000] 142 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2793.165 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5586.33 BogoMIPS (lpj=3D2793165)
[    0.000011] pid_max: default: 32768 minimum: 301
[    0.000064] Mount-cache hash table entries: 256
[    0.000160] CPU: Physical Processor ID: 0
[    0.000163] CPU: Processor Core ID: 0
[    0.000169] mce: CPU supports 9 MCE banks
[    0.000182] CPU0: Thermal monitoring enabled (TM1)
[    0.000190] using mwait in idle threads.
[    0.000193] Performance Events: PEBS fmt1+, Nehalem events, Intel PM=
U driver.
[    0.000202] ... version:                3
[    0.000205] ... bit width:              48
[    0.000207] ... generic registers:      4
[    0.000210] ... value mask:             0000ffffffffffff
[    0.000214] ... max period:             000000007fffffff
[    0.000217] ... fixed-purpose events:   3
[    0.000220] ... event mask:             000000070000000f
[    0.000273] ACPI: Core revision 20100702
[    0.028494] Setting APIC routing to flat
[    0.028833] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.038821] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz st=
epping 05
[    0.142448] NMI watchdog enabled, takes one hw-pmu counter.
[    0.145357] Booting Node   0, Processors  #1
[    0.236270] NMI watchdog enabled, takes one hw-pmu counter.
[    0.238186]  #2
[    0.329091] NMI watchdog enabled, takes one hw-pmu counter.
[    0.331006]  #3
[    0.421916] NMI watchdog enabled, takes one hw-pmu counter.
[    0.423830]  #4
[    0.514762] NMI watchdog enabled, takes one hw-pmu counter.
[    0.516651]  #5
[    0.607543] NMI watchdog enabled, takes one hw-pmu counter.
[    0.609475]  #6
[    0.700368] NMI watchdog enabled, takes one hw-pmu counter.
[    0.702296]  #7 Ok.
[    0.793193] NMI watchdog enabled, takes one hw-pmu counter.
[    0.794119] Brought up 8 CPUs
[    0.794125] Total of 8 processors activated (44681.50 BogoMIPS).
[    0.797214] xor: automatically using best checksumming function: gen=
eric_sse
[    0.802099]    generic_sse: 10440.000 MB/sec
[    0.802102] xor: using function: generic_sse (10440.000 MB/sec)
[    0.802142] NET: Registered protocol family 16
[    0.802311] ACPI FADT declares the system doesn't support PCIe
ASPM, so disable it
[    0.802316] ACPI: bus type pci registered
[    0.802389] dca service started, version 1.12.1
[    0.802429] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.802434] PCI: not using MMCONFIG
[    0.802436] PCI: Using configuration type 1 for base access
[    0.806692] bio: create slab <bio-0> at 0
[    0.823077] raid6: int64x1   2539 MB/s
[    0.840047] raid6: int64x2   3042 MB/s
[    0.857013] raid6: int64x4   2148 MB/s
[    0.873970] raid6: int64x8   2183 MB/s
[    0.890931] raid6: sse2x1    6937 MB/s
[    0.907897] raid6: sse2x2    8089 MB/s
[    0.924870] raid6: sse2x4    9019 MB/s
[    0.924873] raid6: using algorithm sse2x4 (9019 MB/s)
[    0.925950] ACPI: EC: Look up EC in DSDT
[    0.927603] ACPI: Executed 1 blocks of module-level executable AML c=
ode
[    0.931520] ACPI: SSDT 00000000bf790140 0244C (v01 DpgPmm  P001Ist
00000011 INTL 20051117)
[    0.931840] ACPI: Dynamic OEM Table Load:
[    0.931844] ACPI: SSDT (null) 0244C (v01 DpgPmm  P001Ist 00000011
INTL 20051117)
[    0.932024] ACPI: SSDT 00000000bf792590 00678 (v01  PmRef  P001Cst
00003001 INTL 20051117)
[    0.932297] ACPI: Dynamic OEM Table Load:
[    0.932301] ACPI: SSDT (null) 00678 (v01  PmRef  P001Cst 00003001
INTL 20051117)
[    0.932369] ACPI: Interpreter enabled
[    0.932372] ACPI: (supports S0 S3 S4 S5)
[    0.932387] ACPI: Using IOAPIC for interrupt routing
[    0.932411] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.934599] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
in ACPI motherboard resources
[    0.969259] ACPI: No dock devices found.
[    0.969263] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=3Dnocrs" and report a bug
[    0.969460] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.969649] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0c=
f7]
[    0.969654] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xff=
ff]
[    0.969657] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.969661] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000dffff]
[    0.969665] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xdfffffff]
[    0.969669] pci_root PNP0A08:00: host bridge window [mem
0xf0000000-0xfed8ffff]
[    0.969753] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.969755] pci 0000:00:03.0: PME# disabled
[    0.969974] pci 0000:00:19.0: reg 10: [mem 0xfbcc0000-0xfbcdffff]
[    0.969981] pci 0000:00:19.0: reg 14: [mem 0xfbcfc000-0xfbcfcfff]
[    0.969989] pci 0000:00:19.0: reg 18: [io  0xbc00-0xbc1f]
[    0.970032] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.970035] pci 0000:00:19.0: PME# disabled
[    0.970072] pci 0000:00:1a.0: reg 10: [mem 0xfbcfa000-0xfbcfa3ff]
[    0.970138] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.970141] pci 0000:00:1a.0: PME# disabled
[    0.970172] pci 0000:00:1b.0: reg 10: [mem 0xfbcf4000-0xfbcf7fff 64b=
it]
[    0.970220] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.970223] pci 0000:00:1b.0: PME# disabled
[    0.970284] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.970287] pci 0000:00:1c.0: PME# disabled
[    0.970350] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.970353] pci 0000:00:1c.1: PME# disabled
[    0.970415] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.970418] pci 0000:00:1c.2: PME# disabled
[    0.970481] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.970484] pci 0000:00:1c.3: PME# disabled
[    0.970547] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.970549] pci 0000:00:1c.4: PME# disabled
[    0.970591] pci 0000:00:1d.0: reg 10: [mem 0xfbcf8000-0xfbcf83ff]
[    0.970656] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.970659] pci 0000:00:1d.0: PME# disabled
[    0.970842] pci 0000:00:1f.2: reg 10: [io  0xb880-0xb887]
[    0.970848] pci 0000:00:1f.2: reg 14: [io  0xb800-0xb803]
[    0.970855] pci 0000:00:1f.2: reg 18: [io  0xb480-0xb487]
[    0.970862] pci 0000:00:1f.2: reg 1c: [io  0xb400-0xb403]
[    0.970869] pci 0000:00:1f.2: reg 20: [io  0xb080-0xb09f]
[    0.970875] pci 0000:00:1f.2: reg 24: [mem 0xfbcf2000-0xfbcf27ff]
[    0.970905] pci 0000:00:1f.2: PME# supported from D3hot
[    0.970908] pci 0000:00:1f.2: PME# disabled
[    0.970933] pci 0000:00:1f.3: reg 10: [mem 0xfbcff800-0xfbcff8ff 64b=
it]
[    0.970952] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.971017] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64b=
it pref]
[    0.971026] pci 0000:01:00.0: reg 18: [mem 0xfbde0000-0xfbdfffff 64b=
it]
[    0.971033] pci 0000:01:00.0: reg 20: [io  0xc000-0xc0ff]
[    0.971044] pci 0000:01:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pre=
f]
[    0.971060] pci 0000:01:00.0: supports D1 D2
[    0.971087] pci 0000:01:00.1: reg 10: [mem 0xfbdbc000-0xfbdbffff 64b=
it]
[    0.971128] pci 0000:01:00.1: supports D1 D2
[    0.971142] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    0.971146] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    0.971149] pci 0000:00:03.0:   bridge window [mem 0xfbd00000-0xfbdf=
ffff]
[    0.971153] pci 0000:00:03.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.971188] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.971192] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971196] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971200] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971332] pci 0000:03:00.0: reg 24: [mem 0xfbefe000-0xfbefffff]
[    0.971373] pci 0000:03:00.0: PME# supported from D3hot
[    0.971377] pci 0000:03:00.0: PME# disabled
[    0.971423] pci 0000:03:00.1: reg 10: [io  0xdc00-0xdc07]
[    0.971436] pci 0000:03:00.1: reg 14: [io  0xd880-0xd883]
[    0.971449] pci 0000:03:00.1: reg 18: [io  0xd800-0xd807]
[    0.971461] pci 0000:03:00.1: reg 1c: [io  0xd480-0xd483]
[    0.971474] pci 0000:03:00.1: reg 20: [io  0xd400-0xd40f]
[    0.971540] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=3Dforce'
[    0.971545] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.971549] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.971552] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbef=
ffff]
[    0.971557] pci 0000:00:1c.1:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971592] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.971597] pci 0000:00:1c.2:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971600] pci 0000:00:1c.2:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971605] pci 0000:00:1c.2:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971640] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.971644] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971647] pci 0000:00:1c.3:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971652] pci 0000:00:1c.3:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971687] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.971692] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (d=
isabled)
[    0.971695] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.971700] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971748] pci 0000:07:06.0: reg 10: [mem 0xfbfff800-0xfbffffff]
[    0.971757] pci 0000:07:06.0: reg 14: [io  0xec00-0xec7f]
[    0.971814] pci 0000:07:06.0: supports D2
[    0.971815] pci 0000:07:06.0: PME# supported from D2 D3hot D3cold
[    0.971819] pci 0000:07:06.0: PME# disabled
[    0.971852] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive=
 decode)
[    0.971857] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.971860] pci 0000:00:1e.0:   bridge window [mem 0xfbf00000-0xfbff=
ffff]
[    0.971865] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.971866] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.971868] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.971870] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.971872] pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000dffff] (subtractive decode)
[    0.971873] pci 0000:00:1e.0:   bridge window [mem
0xc0000000-0xdfffffff] (subtractive decode)
[    0.971875] pci 0000:00:1e.0:   bridge window [mem
0xf0000000-0xfed8ffff] (subtractive decode)
[    0.971900] pci_bus 0000:00: on NUMA node 0
[    0.971902] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.972009] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
[    0.972041] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR20._PRT]
[    0.972062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR21._PRT]
[    0.972089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR22._PRT]
[    0.972110] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR23._PRT]
[    0.972130] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR24._PRT]
[    0.979958] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 =
14 15)
[    0.980000] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.980039] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 =
14 15)
[    0.980080] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 1=
4 *15)
[    0.980120] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 *=
14 15)
[    0.980161] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    0.980203] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 =
14 15)
[    0.980243] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 *7 10 11 12 =
14 15)
[    0.980281] HEST: Table is not found!
[    0.980427] SCSI subsystem initialized
[    0.980440] libata version 3.00 loaded.
[    0.980485] usbcore: registered new interface driver usbfs
[    0.980524] usbcore: registered new interface driver hub
[    0.980552] usbcore: registered new device driver usb
[    0.980669] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.980673] PCI: Using ACPI for IRQ routing
[    0.980676] PCI: pci_cache_line_size set to 64 bytes
[    0.980738] reserve RAM buffer: 000000000009dc00 - 000000000009ffff
[    0.980740] reserve RAM buffer: 00000000bf780000 - 00000000bfffffff
[    0.980843]   alloc irq_desc for 40 on node 0
[    0.980845]   alloc kstat_irqs on node 0
[    0.980850]   alloc irq_desc for 41 on node 0
[    0.980851]   alloc kstat_irqs on node 0
[    0.980854]   alloc irq_desc for 42 on node 0
[    0.980855]   alloc kstat_irqs on node 0
[    0.980858]   alloc irq_desc for 43 on node 0
[    0.980859]   alloc kstat_irqs on node 0
[    0.980861]   alloc irq_desc for 44 on node 0
[    0.980862]   alloc kstat_irqs on node 0
[    0.980865] HPET: 8 timers in total, 5 timers will be used for per-c=
pu timer
[    0.980874] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44=
, 0
[    0.980881] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.983779] hpet: hpet2 irq 40 for MSI
[    0.983880] hpet: hpet3 irq 41 for MSI
[    0.984869] hpet: hpet4 irq 42 for MSI
[    0.985877] hpet: hpet5 irq 43 for MSI
[    0.986910] hpet: hpet6 irq 44 for MSI
[    0.990871] Switching to clocksource tsc
[    0.990938] pnp: PnP ACPI init
[    0.990947] ACPI: bus type pnp registered
[    0.993484] pnp: PnP ACPI: found 16 devices
[    0.993488] ACPI: ACPI bus type pnp unregistered
[    0.993497] system 00:01: [mem 0xfc000000-0xfcffffff] has been reser=
ved
[    0.993501] system 00:01: [mem 0xfd000000-0xfdffffff] has been reser=
ved
[    0.993504] system 00:01: [mem 0xfe000000-0xfebfffff] has been reser=
ved
[    0.993508] system 00:01: [mem 0xfed14000-0xfed19fff] has been reser=
ved
[    0.993515] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.993518] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.993521] system 00:08: [io  0x0a20-0x0a2f] has been reserved
[    0.993525] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.993530] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.993534] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.993537] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.993541] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reser=
ved
[    0.993544] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reser=
ved
[    0.993548] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reser=
ved
[    0.993554] system 00:0c: [mem 0xffc00000-0xffefffff] has been reser=
ved
[    0.993559] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be r=
eserved
[    0.993563] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reser=
ved
[    0.993568] system 00:0e: [mem 0xe0000000-0xefffffff] has been reser=
ved
[    0.993575] system 00:0f: [mem 0x00000000-0x0009ffff] could not be r=
eserved
[    0.993579] system 00:0f: [mem 0x000c0000-0x000cffff] has been reser=
ved
[    0.993582] system 00:0f: [mem 0x000e0000-0x000fffff] could not be r=
eserved
[    0.993586] system 00:0f: [mem 0x00100000-0xbfffffff] could not be r=
eserved
[    0.993590] system 00:0f: [mem 0xfed90000-0xffffffff] could not be r=
eserved
[    1.000673] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01f=
ffff]
[    1.000679] pci 0000:00:1c.0: BAR 9: assigned [mem
0xc0200000-0xc03fffff 64bit pref]
[    1.000684] pci 0000:00:1c.1: BAR 9: assigned [mem
0xc0400000-0xc05fffff 64bit pref]
[    1.000688] pci 0000:00:1c.2: BAR 8: assigned [mem 0xc0600000-0xc07f=
ffff]
[    1.000692] pci 0000:00:1c.2: BAR 9: assigned [mem
0xc0800000-0xc09fffff 64bit pref]
[    1.000696] pci 0000:00:1c.3: BAR 8: assigned [mem 0xc0a00000-0xc0bf=
ffff]
[    1.000700] pci 0000:00:1c.3: BAR 9: assigned [mem
0xc0c00000-0xc0dfffff 64bit pref]
[    1.000705] pci 0000:00:1c.4: BAR 8: assigned [mem 0xc0e00000-0xc0ff=
ffff]
[    1.000709] pci 0000:00:1c.4: BAR 9: assigned [mem
0xc1000000-0xc11fffff 64bit pref]
[    1.000713] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    1.000717] pci 0000:00:1c.2: BAR 7: assigned [io  0x2000-0x2fff]
[    1.000720] pci 0000:00:1c.3: BAR 7: assigned [io  0x3000-0x3fff]
[    1.000724] pci 0000:00:1c.4: BAR 7: assigned [io  0x4000-0x4fff]
[    1.000727] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.000731] pci 0000:00:03.0:   bridge window [io  0xc000-0xcfff]
[    1.000736] pci 0000:00:03.0:   bridge window [mem 0xfbd00000-0xfbdf=
ffff]
[    1.000740] pci 0000:00:03.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    1.000746] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.000750] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.000756] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01f=
ffff]
[    1.000761] pci 0000:00:1c.0:   bridge window [mem
0xc0200000-0xc03fffff 64bit pref]
[    1.000768] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.000771] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    1.000777] pci 0000:00:1c.1:   bridge window [mem 0xfbe00000-0xfbef=
ffff]
[    1.000782] pci 0000:00:1c.1:   bridge window [mem
0xc0400000-0xc05fffff 64bit pref]
[    1.000789] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    1.000793] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    1.000798] pci 0000:00:1c.2:   bridge window [mem 0xc0600000-0xc07f=
ffff]
[    1.000803] pci 0000:00:1c.2:   bridge window [mem
0xc0800000-0xc09fffff 64bit pref]
[    1.000810] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    1.000814] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    1.000819] pci 0000:00:1c.3:   bridge window [mem 0xc0a00000-0xc0bf=
ffff]
[    1.000824] pci 0000:00:1c.3:   bridge window [mem
0xc0c00000-0xc0dfffff 64bit pref]
[    1.000831] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    1.000835] pci 0000:00:1c.4:   bridge window [io  0x4000-0x4fff]
[    1.000840] pci 0000:00:1c.4:   bridge window [mem 0xc0e00000-0xc0ff=
ffff]
[    1.000845] pci 0000:00:1c.4:   bridge window [mem
0xc1000000-0xc11fffff 64bit pref]
[    1.000852] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    1.000856] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    1.000861] pci 0000:00:1e.0:   bridge window [mem 0xfbf00000-0xfbff=
ffff]
[    1.000866] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.000877]   alloc irq_desc for 16 on node -1
[    1.000878]   alloc kstat_irqs on node -1
[    1.000881] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[    1.000886] pci 0000:00:03.0: setting latency timer to 64
[    1.000895] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.000900]   alloc irq_desc for 17 on node -1
[    1.000901]   alloc kstat_irqs on node -1
[    1.000904] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[    1.000909] pci 0000:00:1c.0: setting latency timer to 64
[    1.000915] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IR=
Q 16
[    1.000920] pci 0000:00:1c.1: setting latency timer to 64
[    1.000925] pci 0000:00:1c.2: enabling device (0104 -> 0107)
[    1.000929]   alloc irq_desc for 18 on node -1
[    1.000930]   alloc kstat_irqs on node -1
[    1.000933] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IR=
Q 18
[    1.000937] pci 0000:00:1c.2: setting latency timer to 64
[    1.000943] pci 0000:00:1c.3: enabling device (0104 -> 0107)
[    1.000947]   alloc irq_desc for 19 on node -1
[    1.000948]   alloc kstat_irqs on node -1
[    1.000951] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IR=
Q 19
[    1.000955] pci 0000:00:1c.3: setting latency timer to 64
[    1.000961] pci 0000:00:1c.4: enabling device (0104 -> 0107)
[    1.000965] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[    1.000970] pci 0000:00:1c.4: setting latency timer to 64
[    1.000975] pci 0000:00:1e.0: setting latency timer to 64
[    1.000978] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.000979] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.000981] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.000982] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.000984] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.000985] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.000987] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    1.000988] pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    1.000990] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    1.000992] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    1.000993] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    1.000995] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff
64bit pref]
[    1.000996] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.000998] pci_bus 0000:03: resource 1 [mem 0xfbe00000-0xfbefffff]
[    1.000999] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff
64bit pref]
[    1.001001] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    1.001002] pci_bus 0000:04: resource 1 [mem 0xc0600000-0xc07fffff]
[    1.001004] pci_bus 0000:04: resource 2 [mem 0xc0800000-0xc09fffff
64bit pref]
[    1.001006] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    1.001007] pci_bus 0000:05: resource 1 [mem 0xc0a00000-0xc0bfffff]
[    1.001009] pci_bus 0000:05: resource 2 [mem 0xc0c00000-0xc0dfffff
64bit pref]
[    1.001010] pci_bus 0000:06: resource 0 [io  0x4000-0x4fff]
[    1.001012] pci_bus 0000:06: resource 1 [mem 0xc0e00000-0xc0ffffff]
[    1.001013] pci_bus 0000:06: resource 2 [mem 0xc1000000-0xc11fffff
64bit pref]
[    1.001015] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    1.001016] pci_bus 0000:07: resource 1 [mem 0xfbf00000-0xfbffffff]
[    1.001018] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    1.001019] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    1.001021] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    1.001022] pci_bus 0000:07: resource 7 [mem 0x000d0000-0x000dffff]
[    1.001024] pci_bus 0000:07: resource 8 [mem 0xc0000000-0xdfffffff]
[    1.001026] pci_bus 0000:07: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.001066] NET: Registered protocol family 2
[    1.001118] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    1.001453] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    1.002537] TCP bind hash table entries: 65536 (order: 9, 2097152 by=
tes)
[    1.002973] TCP: Hash tables configured (established 262144 bind 655=
36)
[    1.002977] TCP reno registered
[    1.002984] UDP hash table entries: 4096 (order: 6, 393216 bytes)
[    1.003068] UDP-Lite hash table entries: 4096 (order: 6, 393216 byte=
s)
[    1.003227] NET: Registered protocol family 1
[    1.003310] RPC: Registered udp transport module.
[    1.003313] RPC: Registered tcp transport module.
[    1.003315] RPC: Registered tcp NFSv4.1 backchannel transport module=
=2E
[    1.003387] pci 0000:01:00.0: Boot video device
[    1.003398] PCI: CLS 32 bytes, default 64
[    1.013299] Trying to unpack rootfs image as initramfs...
[    1.064930] Freeing initrd memory: 3184k freed
[    1.065267] PCI-DMA: Using software bounce buffering for IO (SWIOTLB=
)
[    1.065271] Placing 64MB software IO TLB between ffff880008200000 -
ffff88000c200000
[    1.065275] software IO TLB at phys 0x8200000 - 0xc200000
[    1.067231] microcode: CPU0 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067238] microcode: CPU1 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067246] microcode: CPU2 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067253] microcode: CPU3 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067261] microcode: CPU4 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067269] microcode: CPU5 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067275] microcode: CPU6 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067282] microcode: CPU7 sig=3D0x106e5, pf=3D0x2, revision=3D0x3
[    1.067316] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.067322] Scanning for low memory corruption every 60 seconds
[    1.067414] Intel AES-NI instructions are not detected.
[    1.067417] Intel PCLMULQDQ-NI instructions are not detected.
[    1.067801] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.067983] VFS: Disk quotas dquot_6.5.2
[    1.068012] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    1.068177] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.068290] fuse init (API version 7.15)
[    1.068418] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    1.069560] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    1.069758] SGI XFS Quota Management subsystem
[    1.069866] Btrfs loaded
[    1.069871] msgmni has been set to 11918
[    1.070586] alg: No test for fcrypt (fcrypt-generic)
[    1.071793] alg: No test for stdrng (krng)
[    1.071837] async_tx: api initialized (async)
[    1.071878] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.071883] io scheduler noop registered
[    1.071885] io scheduler deadline registered (default)
[    1.071903] io scheduler cfq registered
[    1.073361] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.074040] vesafb: framebuffer at 0xd0000000, mapped to
0xffffc90010780000, using 5120k, total 16384k
[    1.074046] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D=
5
[    1.074049] vesafb: scrolling: redraw
[    1.074052] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.077657] Console: switching to colour frame buffer device 160x64
[    1.079024] fb0: VESA VGA frame buffer device
[    1.079074] intel_idle: MWAIT substates: 0x1120
[    1.079076] intel_idle: v0.4 model 0x1E
[    1.079077] intel_idle: lapic_timer_reliable_states 0x2
[    1.079404] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.079427] ACPI: Power Button [PWRB]
[    1.079485] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.079504] ACPI: Power Button [PWRF]
[    1.079689] ACPI: acpi_idle yielding to intel_idle
[    1.082403] ERST: Table is not found!
[    1.082660] Linux agpgart interface v0.103
[    1.082779] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180
seconds, margin is 60 seconds).
[    1.082799] Hangcheck: Using getrawmonotonic().
[    1.082812] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.084389] brd: module loaded
[    1.084562] Loading iSCSI transport class v2.0-870.
[    1.084815] SCSI Media Changer driver v0.25
[    1.084885] ahci 0000:00:1f.2: version 3.0
[    1.084895] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    1.084934]   alloc irq_desc for 45 on node -1
[    1.084936]   alloc kstat_irqs on node -1
[    1.084943] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    1.084964] ahci: SSS flag set, parallel bus scan disabled
[    1.095774] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    1.095816] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems sxs apst
[    1.095844] ahci 0000:00:1f.2: setting latency timer to 64
[    1.105801] scsi0 : ahci
[    1.105921] scsi1 : ahci
[    1.106010] scsi2 : ahci
[    1.106098] scsi3 : ahci
[    1.106186] scsi4 : ahci
[    1.106276] scsi5 : ahci
[    1.106411] ata1: SATA max UDMA/133 abar m2048@0xfbcf2000 port
0xfbcf2100 irq 45
[    1.106429] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.106447] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.106466] ata4: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.106484] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.106502] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection
status changed irq 45
[    1.106541] ahci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
[    1.116744] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3
Gbps 0x3 impl SATA mode
[    1.116786] ahci 0000:03:00.0: flags: 64bit ncq led clo pmp pio
[    1.116808] ahci 0000:03:00.0: setting latency timer to 64
[    1.116897] scsi6 : ahci
[    1.117005] scsi7 : ahci
[    1.118326] ata7: SATA max UDMA/133 abar m8192@0xfbefe000 port
0xfbefe100 irq 17
[    1.119571] ata8: SATA max UDMA/133 abar m8192@0xfbefe000 port
0xfbefe180 irq 17
[    1.121721] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001=
)
[    1.122948] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 18 (level,
low) -> IRQ 18
[    1.124195] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    1.124246] scsi8 : pata_jmicron
[    1.125580] scsi9 : pata_jmicron
[    1.127154] ata9: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd4=
00 irq 18
[    1.128415] ata10: PATA max UDMA/100 cmd 0xd800 ctl 0xd480 bmdma
0xd408 irq 18
[    1.130412] tun: Universal TUN/TAP device driver, 1.6
[    1.131678] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.133073] uhci_hcd: USB Universal Host Controller Interface driver
[    1.134435] usbcore: registered new interface driver wusb-cbaf
[    1.135739] usbcore: registered new interface driver libusual
[    1.137101] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    1.138737] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.139992] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.141343] mice: PS/2 mouse device common for all mice
[    1.142820] rtc_cmos 00:03: RTC can wake from S4
[    1.144111] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.145389] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet=
 irqs
[    1.146731] lirc_dev: IR Remote Control driver registered, major 251
[    1.147969] Linux video capture interface: v2.00
[    1.149289] md: linear personality registered for level -1
[    1.150550] md: raid0 personality registered for level 0
[    1.151805] md: raid1 personality registered for level 1
[    1.153046] md: raid10 personality registered for level 10
[    1.154291] md: raid6 personality registered for level 6
[    1.155527] md: raid5 personality registered for level 5
[    1.156746] md: raid4 personality registered for level 4
[    1.157965] md: multipath personality registered for level -4
[    1.159214] device-mapper: uevent: version 1.0.3
[    1.160492] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29)
initialised: dm-devel@redhat.com
[    1.161727] device-mapper: multipath: version 1.1.1 loaded
[    1.162898] device-mapper: multipath round-robin: version 1.0.0 load=
ed
[    1.164101] EDAC MC: Ver: 2.1.0 Dec  4 2010
[    1.166261] cpuidle: using governor ladder
[    1.169101] cpuidle: using governor menu
[    1.170238] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.172437] usbcore: registered new interface driver hiddev
[    1.173580] usbcore: registered new interface driver usbhid
[    1.174680] usbhid: USB HID core driver
[    1.178355]   alloc irq_desc for 22 on node -1
[    1.178356]   alloc kstat_irqs on node -1
[    1.178361] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    1.179462]   alloc irq_desc for 46 on node -1
[    1.179463]   alloc kstat_irqs on node -1
[    1.179470] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    1.179487] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    1.193885] hda_codec: ALC888: BIOS auto-probing.
[    1.200893] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    1.202105]   alloc irq_desc for 47 on node -1
[    1.202107]   alloc kstat_irqs on node -1
[    1.202113] HDA Intel 0000:01:00.1: irq 47 for MSI/MSI-X
[    1.202128] HDA Intel 0000:01:00.1: setting latency timer to 64
[    1.206666] ALSA device list:
[    1.207848]   #0: HDA Intel at 0xfbcf4000 irq 46
[    1.209044]   #1: HD-Audio Generic at 0xfbdbc000 irq 47
[    1.210481] TCP cubic registered
[    1.211681] Initializing XFRM netlink socket
[    1.213232] NET: Registered protocol family 10
[    1.214809] lo: Disabled Privacy Extensions
[    1.216238] IPv6 over IPv4 tunneling driver
[    1.217729] sit0: Disabled Privacy Extensions
[    1.219244] NET: Registered protocol family 17
[    1.220445] NET: Registered protocol family 15
[    1.221630] lib80211: common routines for IEEE802.11 drivers
[    1.222801] lib80211_crypt: registered algorithm 'NULL'
[    1.222803] Registering the dns_resolver key type
[    1.226063] registered taskstats version 1
[    1.227575] rtc_cmos 00:03: setting system clock to 2010-12-04
21:56:40 UTC (1291499800)
[    1.410376] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.413187] ata1.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDM=
A/133
[    1.414865] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    1.417886] ata1.00: configured for UDMA/133
[    1.425361] ata8: SATA link down (SStatus 0 SControl 300)
[    1.427131] ata7: SATA link down (SStatus 0 SControl 300)
[    1.430440] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.433231] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    1.433669] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.436592] sd 0:0:0:0: [sda] Write Protect is off
[    1.438220] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.438248] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.458941]  sda: sda1 sda2 < sda5 >
[    1.461929] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.155092] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.158494] ata2.00: ATAPI: ATAPI   iHAS324   Y, BL1Y, max UDMA/100
[    2.162223] ata2.00: configured for UDMA/100
[    2.176329] scsi 1:0:0:0: CD-ROM            ATAPI    iHAS324   Y
  BL1Y PQ: 0 ANSI: 5
[    2.183221] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.184982] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.187139] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.187396] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.910824] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.914641] ata3.00: ATA-8: WDC WD10EADS-22M2B0, 01.00A01, max UDMA/=
133
[    2.916402] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    2.920428] ata3.00: configured for UDMA/133
[    2.932909] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD10EADS-22M 01.0 PQ: 0 ANSI: 5
[    2.935428] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    2.935738] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.939296] sd 2:0:0:0: [sdb] Write Protect is off
[    2.941169] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.941197] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.978580]  sdb: sdb1 sdb2 < sdb5 >
[    2.981312] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.657635] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.662585] ata4.00: ATAPI: HL-DT-ST DVDRAM GH41N, MN01, max UDMA/10=
0
[    3.668021] ata4.00: configured for UDMA/100
[    3.687830] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH41N
  MN01 PQ: 0 ANSI: 5
[    3.712257] sr1: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw
xa/form2 cdda tray
[    3.714638] sr 3:0:0:0: Attached scsi CD-ROM sr1
[    3.714995] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    4.438337] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.446952] ata5.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[    4.448960] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    4.457703] ata5.00: configured for UDMA/133
[    4.470275] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG
HD154UI  1AG0 PQ: 0 ANSI: 5
[    4.472883] sd 4:0:0:0: [sdc] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[    4.473014] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    4.476923] sd 4:0:0:0: [sdc] Write Protect is off
[    4.478852] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.478888] sd 4:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    4.547327]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 >
[    4.550459] sd 4:0:0:0: [sdc] Attached SCSI disk
[    5.195012] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.202976] ata6.00: ATA-8: SAMSUNG HD203WI, 1AN10003, max UDMA/133
[    5.204987] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 3=
1/32), AA
[    5.213178] ata6.00: configured for UDMA/133
[    5.225054] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG
HD203WI  1AN1 PQ: 0 ANSI: 5
[    5.227692] sd 5:0:0:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    5.227820] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    5.232018] sd 5:0:0:0: [sdd] Write Protect is off
[    5.234096] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.234124] sd 5:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.314664]  sdd: sdd1 sdd2 sdd3 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 sd=
d11 >
[    5.317923] sd 5:0:0:0: [sdd] Attached SCSI disk
[    5.390527] Freeing unused kernel memory: 548k freed
[    5.392723] Write protecting the kernel read-only data: 12288k
[    5.395303] Freeing unused kernel memory: 852k freed
[    5.397766] Freeing unused kernel memory: 1472k freed
[    6.144288] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    6.144293] Warning! ehci_hcd should always be loaded before
uhci_hcd and ohci_hcd, not after
[    6.144297] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    6.144415] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    6.144494] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.144499] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    6.144521] drivers/usb/core/inode.c: creating file 'devices'
[    6.144526] drivers/usb/core/inode.c: creating file '001'
[    6.144745] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    6.144756] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=3D2
cc=3D0 pcc=3D0 ordered !ppc ports=3D2
[    6.144762] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching
frame 1024 64 bit addr
[    6.144781] ehci_hcd 0000:00:1a.0: support lpm
[    6.144794] ehci_hcd 0000:00:1a.0: debug port 2
[    6.144801] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.148700] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supp=
orted
[    6.148703] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
[    6.148729] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfbcfa000
[    6.148735] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.152614] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=3D0
ithresh=3D1 period=3D1024 RUN
[    6.155435] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.155465] usb usb1: default language 0x0409
[    6.155476] usb usb1: udev 1, busnum 1, minor =3D 0
[    6.155479] usb usb1: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[    6.155483] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    6.155486] usb usb1: Product: EHCI Host Controller
[    6.155490] usb usb1: Manufacturer: Linux
2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879d410+ ehci_hcd
[    6.155493] usb usb1: SerialNumber: 0000:00:1a.0
[    6.155714] usb usb1: usb_probe_device
[    6.155719] usb usb1: configuration #1 chosen from 1 choice
[    6.155732] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    6.155935] hub 1-0:1.0: usb_probe_interface
[    6.155939] hub 1-0:1.0: usb_probe_interface - got id
[    6.155943] hub 1-0:1.0: USB hub found
[    6.155950] hub 1-0:1.0: 2 ports detected
[    6.155953] hub 1-0:1.0: standalone hub
[    6.155955] hub 1-0:1.0: no power switching (usb 1.0)
[    6.155958] hub 1-0:1.0: individual port over-current protection
[    6.155961] hub 1-0:1.0: power on to power good time: 20ms
[    6.155968] hub 1-0:1.0: local power source is good
[    6.155971] hub 1-0:1.0: trying to enable port power on non-switchab=
le hub
[    6.156180] drivers/usb/core/inode.c: creating file '001'
[    6.156250]   alloc irq_desc for 23 on node -1
[    6.156253]   alloc kstat_irqs on node -1
[    6.156261] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) =
-> IRQ 23
[    6.156282] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.156287] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    6.156299] drivers/usb/core/inode.c: creating file '002'
[    6.156565] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    6.156576] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=3D2
cc=3D0 pcc=3D0 ordered !ppc ports=3D2
[    6.156581] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching
frame 1024 64 bit addr
[    6.156600] ehci_hcd 0000:00:1d.0: support lpm
[    6.156613] ehci_hcd 0000:00:1d.0: debug port 2
[    6.156619] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.160517] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supp=
orted
[    6.160521] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
[    6.160541] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfbcf8000
[    6.160548] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0
ithresh=3D8 period=3D1024 Reset HALT
[    6.164433] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=3D0
ithresh=3D1 period=3D1024 RUN
[    6.167411] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.167436] usb usb2: default language 0x0409
[    6.167446] usb usb2: udev 1, busnum 2, minor =3D 128
[    6.167450] usb usb2: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[    6.167453] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
SerialNumber=3D1
[    6.167457] usb usb2: Product: EHCI Host Controller
[    6.167460] usb usb2: Manufacturer: Linux
2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879d410+ ehci_hcd
[    6.167464] usb usb2: SerialNumber: 0000:00:1d.0
[    6.167754] usb usb2: usb_probe_device
[    6.167759] usb usb2: configuration #1 chosen from 1 choice
[    6.167770] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    6.167958] hub 2-0:1.0: usb_probe_interface
[    6.167962] hub 2-0:1.0: usb_probe_interface - got id
[    6.167966] hub 2-0:1.0: USB hub found
[    6.167973] hub 2-0:1.0: 2 ports detected
[    6.167976] hub 2-0:1.0: standalone hub
[    6.167978] hub 2-0:1.0: no power switching (usb 1.0)
[    6.167981] hub 2-0:1.0: individual port over-current protection
[    6.167984] hub 2-0:1.0: power on to power good time: 20ms
[    6.167990] hub 2-0:1.0: local power source is good
[    6.167993] hub 2-0:1.0: trying to enable port power on non-switchab=
le hub
[    6.168195] drivers/usb/core/inode.c: creating file '001'
[    6.200453] Initializing USB Mass Storage driver...
[    6.200652] usbcore: registered new interface driver usb-storage
[    6.200656] USB Mass Storage support registered.
[    6.240820] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.240825] ohci_hcd: block sizes: ed 80 td 96
[    6.255195] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0
 ACK POWER sig=3Dj CSC CONNECT
[    6.255203] hub 1-0:1.0: port 1: status 0501 change 0001
[    6.265495] sl811: driver sl811-hcd, 19 May 2005
[    6.267247] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0
 ACK POWER sig=3Dj CSC CONNECT
[    6.267254] hub 2-0:1.0: port 1: status 0501 change 0001
[    6.356074] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    6.356087] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    6.367194] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21=
-k6-NAPI
[    6.367199] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.407201] ehci_hcd 0000:00:1a.0: port 1 high speed
[    6.407210] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.457962] usb 1-1: new high speed USB device using ehci_hcd and ad=
dress 2
[    6.509149] ehci_hcd 0000:00:1a.0: port 1 high speed
[    6.509158] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.571806] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    6.571813] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    6.572107] usb 1-1: udev 2, busnum 1, minor =3D 1
[    6.572112] usb 1-1: New USB device found, idVendor=3D8087, idProduc=
t=3D0020
[    6.572117] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    6.572558] usb 1-1: usb_probe_device
[    6.572564] usb 1-1: configuration #1 chosen from 1 choice
[    6.572753] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    6.573049] hub 1-1:1.0: usb_probe_interface
[    6.573054] hub 1-1:1.0: usb_probe_interface - got id
[    6.573059] hub 1-1:1.0: USB hub found
[    6.573242] hub 1-1:1.0: 6 ports detected
[    6.573246] hub 1-1:1.0: standalone hub
[    6.573249] hub 1-1:1.0: individual port power switching
[    6.573252] hub 1-1:1.0: individual port over-current protection
[    6.573255] hub 1-1:1.0: Single TT
[    6.573258] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    6.573261] hub 1-1:1.0: Port indicators are supported
[    6.573264] hub 1-1:1.0: power on to power good time: 100ms
[    6.573548] hub 1-1:1.0: local power source is good
[    6.573554] hub 1-1:1.0: enabling power on all ports
[    6.574729] drivers/usb/core/inode.c: creating file '002'
[    6.574766] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    6.574777] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    6.625949] ehci_hcd 0000:00:1d.0: port 1 high speed
[    6.625957] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.673666] hub 1-1:1.0: port 1: status 0101 change 0001
[    6.673945] hub 1-1:1.0: port 2: status 0101 change 0001
[    6.674306] hub 1-1:1.0: port 4: status 0101 change 0001
[    6.676541] usb 2-1: new high speed USB device using ehci_hcd and ad=
dress 2
[    6.727648] ehci_hcd 0000:00:1d.0: port 1 high speed
[    6.727657] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0
 ACK POWER sig=3Dse0 PE CONNECT
[    6.774447] usb 1-1: link qh256-0001/ffff8801bc3ce840 start 1 [1/0 u=
s]
[    6.790467] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    6.790474] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    6.790710] usb 2-1: udev 2, busnum 2, minor =3D 129
[    6.790714] usb 2-1: New USB device found, idVendor=3D8087, idProduc=
t=3D0020
[    6.790717] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[    6.791121] usb 2-1: usb_probe_device
[    6.791128] usb 2-1: configuration #1 chosen from 1 choice
[    6.791317] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    6.791656] hub 2-1:1.0: usb_probe_interface
[    6.791661] hub 2-1:1.0: usb_probe_interface - got id
[    6.791667] hub 2-1:1.0: USB hub found
[    6.791808] hub 2-1:1.0: 8 ports detected
[    6.791813] hub 2-1:1.0: standalone hub
[    6.791817] hub 2-1:1.0: individual port power switching
[    6.791821] hub 2-1:1.0: individual port over-current protection
[    6.791825] hub 2-1:1.0: Single TT
[    6.791830] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    6.791834] hub 2-1:1.0: Port indicators are supported
[    6.791839] hub 2-1:1.0: power on to power good time: 100ms
[    6.792078] hub 2-1:1.0: local power source is good
[    6.792082] hub 2-1:1.0: enabling power on all ports
[    6.793468] drivers/usb/core/inode.c: creating file '002'
[    6.793514] hub 1-1:1.0: state 7 ports 6 chg 0016 evt 0000
[    6.793679] hub 1-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.804466] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    6.866510] usb 1-1.1: new low speed USB device using ehci_hcd and a=
ddress 3
[    6.878438] hub 1-1:1.0: port 1 not reset yet, waiting 10ms
[    6.893031] hub 2-1:1.0: port 7: status 0101 change 0001
[    6.956053] usb 1-1.1: skipped 1 descriptor after interface
[    6.956059] usb 1-1.1: skipped 1 descriptor after interface
[    6.956673] usb 1-1.1: default language 0x0409
[    6.958673] usb 1-1.1: udev 3, busnum 1, minor =3D 2
[    6.958677] usb 1-1.1: New USB device found, idVendor=3D046d, idProd=
uct=3Dc521
[    6.958680] usb 1-1.1: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D0
[    6.958684] usb 1-1.1: Product: USB Receiver
[    6.958687] usb 1-1.1: Manufacturer: Logitech
[    6.959104] usb 1-1.1: usb_probe_device
[    6.959110] usb 1-1.1: configuration #1 chosen from 1 choice
[    6.961093] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    6.961447] usbhid 1-1.1:1.0: usb_probe_interface
[    6.961452] usbhid 1-1.1:1.0: usb_probe_interface - got id
[    6.965526] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input2
[    6.966455] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.1/input0
[    6.966487] usb 1-1.1: adding 1-1.1:1.1 (config #1, interface 1)
[    6.966784] usbhid 1-1.1:1.1: usb_probe_interface
[    6.966789] usbhid 1-1.1:1.1: usb_probe_interface - got id
[    6.973941] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.1/input/input3
[    6.974013] usb 1-1.1: link qh8-0e01/ffff8801bc3cef40 start 2 [1/2 u=
s]
[    6.974841] usbhid 1-1.1:1.1: looking for a minor, starting at 0
[    6.975665] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1:
USB HID v1.11 Device [Logitech USB Receiver] on
usb-0000:00:1a.0-1.1/input1
[    6.976135] drivers/usb/core/inode.c: creating file '003'
[    6.976254] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    6.987129] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    6.993013] usb 2-1: link qh256-0001/ffff8801bf5bdc40 start 1 [1/0 u=
s]
[    7.049198] usb 1-1.2: new high speed USB device using ehci_hcd and =
address 4
[    7.060126] hub 1-1:1.0: port 2 not reset yet, waiting 10ms
[    7.135040] usb 1-1.2: default language 0x0409
[    7.135800] usb 1-1.2: udev 4, busnum 1, minor =3D 3
[    7.135805] usb 1-1.2: New USB device found, idVendor=3D04f9, idProd=
uct=3D002a
[    7.135809] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[    7.135813] usb 1-1.2: Product: HL-5240
[    7.135816] usb 1-1.2: Manufacturer: Brother
[    7.135818] usb 1-1.2: SerialNumber: H7J241026
[    7.136251] usb 1-1.2: usb_probe_device
[    7.136257] usb 1-1.2: configuration #1 chosen from 1 choice
[    7.136401] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
[    7.137100] drivers/usb/core/inode.c: creating file '004'
[    7.137272] hub 1-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    7.147977] hub 1-1:1.0: port 4 not reset yet, waiting 10ms
[    7.209924] usb 1-1.4: new low speed USB device using ehci_hcd and a=
ddress 5
[    7.222846] hub 1-1:1.0: port 4 not reset yet, waiting 10ms
[    7.307325] usb 1-1.4: skipped 1 descriptor after interface
[    7.307331] usb 1-1.4: skipped 1 descriptor after interface
[    7.308100] usb 1-1.4: default language 0x0409
[    7.317605] usb 1-1.4: udev 5, busnum 1, minor =3D 4
[    7.317610] usb 1-1.4: New USB device found, idVendor=3D045e, idProd=
uct=3D00db
[    7.317615] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D0
[    7.317618] usb 1-1.4: Product: Natural=AE Ergonomic Keyboard 4000
[    7.317622] usb 1-1.4: Manufacturer: Microsoft
[    7.318051] usb 1-1.4: usb_probe_device
[    7.318057] usb 1-1.4: configuration #1 chosen from 1 choice
[    7.318819] usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
[    7.319174] usbhid 1-1.4:1.0: usb_probe_interface
[    7.319179] usbhid 1-1.4:1.0: usb_probe_interface - got id
[    7.327300] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input4
[    7.327333] usb 1-1.4: link qh8-0e01/ffff8801bc24b7c0 start 3 [1/2 u=
s]
[    7.327994] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID
v1.11 Keyboard [Microsoft Natural=AE Ergonomic Keyboard 4000] on
usb-0000:00:1a.0-1.4/input0
[    7.328028] usb 1-1.4: adding 1-1.4:1.1 (config #1, interface 1)
[    7.328318] usbhid 1-1.4:1.1: usb_probe_interface
[    7.328323] usbhid 1-1.4:1.1: usb_probe_interface - got id
[    7.339687] input: Microsoft Natural=AE Ergonomic Keyboard 4000 as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/input/input5
[    7.339719] usb 1-1.4: link qh8-0e01/ffff8801bc24ba40 start 4 [1/2 u=
s]
[    7.340332] microsoft 0003:045E:00DB.0004: input,hidraw3: USB HID
v1.11 Device [Microsoft Natural=AE Ergonomic Keyboard 4000] on
usb-0000:00:1a.0-1.4/input1
[    7.340615] drivers/usb/core/inode.c: creating file '005'
[    7.340648] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
[    7.340765] hub 2-1:1.0: state 7 ports 8 chg 0080 evt 0000
[    7.340917] hub 2-1:1.0: port 7, status 0101, change 0000, 12 Mb/s
[    7.351506] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    7.413561] usb 2-1.7: new high speed USB device using ehci_hcd and =
address 3
[    7.427493] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    7.513356] usb 2-1.7: skipped 1 descriptor after interface
[    7.514189] usb 2-1.7: default language 0x0409
[    7.519623] usb 2-1.7: udev 3, busnum 2, minor =3D 130
[    7.519628] usb 2-1.7: New USB device found, idVendor=3D0bda, idProd=
uct=3D0182
[    7.519633] usb 2-1.7: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[    7.519637] usb 2-1.7: Product: USB2.0-CRW
[    7.519639] usb 2-1.7: Manufacturer: Generic
[    7.519642] usb 2-1.7: SerialNumber: 20060413092100000
[    7.520026] usb 2-1.7: usb_probe_device
[    7.520033] usb 2-1.7: configuration #1 chosen from 1 choice
[    7.522459] usb 2-1.7: adding 2-1.7:1.0 (config #1, interface 0)
[    7.526585] libusual 2-1.7:1.0: usb_probe_interface
[    7.526597] libusual 2-1.7:1.0: usb_probe_interface - got id
[    7.526620] usb-storage 2-1.7:1.0: usb_probe_interface
[    7.526630] usb-storage 2-1.7:1.0: usb_probe_interface - got id
[    7.526949] scsi10 : usb-storage 2-1.7:1.0
[    7.527738] usb 2-1.7: adding 2-1.7:1.1 (config #1, interface 1)
[    7.528014] usbhid 2-1.7:1.1: usb_probe_interface
[    7.528020] usbhid 2-1.7:1.1: usb_probe_interface - got id
[    7.534756] generic-usb: probe of 0003:0BDA:0182.0005 failed with er=
ror -22
[    7.535052] drivers/usb/core/inode.c: creating file '003'
[    7.535284] hub 2-1:1.0: state 7 ports 8 chg 0000 evt fe80
[    8.529494] scsi 10:0:0:0: Direct-Access     Generic- Compact Flash
   1.00 PQ: 0 ANSI: 0 CCS
[    8.532663] scsi 10:0:0:1: Direct-Access     Generic- xD-Picture
   1.00 PQ: 0 ANSI: 0 CCS
[    8.535795] scsi 10:0:0:2: Direct-Access     Generic- SD/MMC
   1.00 PQ: 0 ANSI: 0 CCS
[    8.539166] scsi 10:0:0:3: Direct-Access     Generic- MS/MS-Pro/HG
   1.00 PQ: 0 ANSI: 0 CCS
[    8.542286] scsi 10:0:0:4: Direct-Access     Generic- MicroSD
   1.00 PQ: 0 ANSI: 0 CCS
[    8.543971] sd 10:0:0:0: Attached scsi generic sg6 type 0
[    8.544781] sd 10:0:0:1: Attached scsi generic sg7 type 0
[    8.545644] sd 10:0:0:2: Attached scsi generic sg8 type 0
[    8.546625] sd 10:0:0:3: Attached scsi generic sg9 type 0
[    8.547454] sd 10:0:0:4: Attached scsi generic sg10 type 0
[    8.556428] sd 10:0:0:3: [sdh] Attached SCSI removable disk
[    8.559077] sd 10:0:0:1: [sdf] Attached SCSI removable disk
[    8.561561] sd 10:0:0:0: [sde] Attached SCSI removable disk
[    8.566573] sd 10:0:0:2: [sdg] Attached SCSI removable disk
[    8.569374] sd 10:0:0:4: [sdi] Attached SCSI removable disk
[   61.717812] alg: No test for xts(twofish) (xts(twofish-asm))
[   61.740032] CE: hpet increased min_delta_ns to 7500 nsec
[   64.151414] EXT3-fs (dm-2): error: couldn't mount because of
unsupported optional features (240)
[   64.154045] EXT2-fs (dm-2): error: couldn't mount because of
unsupported optional features (240)
[   64.176266] EXT4-fs (dm-2): mounted filesystem with ordered data
mode. Opts: (null)
[   66.032986] udev[4646]: starting version 164
[   66.221244] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[   66.221246] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[   66.221275]   alloc irq_desc for 20 on node -1
[   66.221277]   alloc kstat_irqs on node -1
[   66.221281] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) ->=
 IRQ 20
[   66.221287] e1000e 0000:00:19.0: setting latency timer to 64
[   66.221437]   alloc irq_desc for 48 on node -1
[   66.221438]   alloc kstat_irqs on node -1
[   66.221445] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   66.243447] usb 1-1.1: link qh8-0e01/ffff8801bc2456c0 start 5 [1/2 u=
s]
[   66.253281] ACPI: WMI: Mapper loaded
[   66.278254] usb 1-1.1: unlink qh8-0e01/ffff8801bc2456c0 start 5 [1/2=
 us]
[   66.301578] firewire_ohci 0000:07:06.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[   66.354258] firewire_ohci: Added fw-ohci device 0000:07:06.0, OHCI
v1.10, 4 IR + 8 IT contexts, quirks 0x1
[   66.449171] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width
x1) 90:fb:a6:46:2d:ec
[   66.449174] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Con=
nection
[   66.449208] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: fffff=
f-0ff
[   66.449249] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   66.449429] shpchp: Standard Hot Plug PCI Controller Driver version:=
 0.4
[   66.675286] fglrx: module license 'Proprietary. (C) 2002 - ATI
Technologies, Starnberg, GERMANY' taints kernel.
[   66.675291] Disabling lock debugging due to kernel taint
[   66.698309] [fglrx] Maximum main memory to use for locked dma
buffers: 5765 MBytes.
[   66.698356] [fglrx]   vendor: 1002 device: 6899 count: 1
[   66.698613] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   66.698625] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[   66.698628] pci 0000:01:00.0: setting latency timer to 64
[   66.698847] [fglrx] Kernel PAT support is enabled
[   66.698859] [fglrx] module loaded - fglrx 8.79.4 [Oct 26 2010] with =
1 minors
[   66.854507] firewire_core: created device fw0: GUID 00016c20013727d2=
, S400
[   69.559903] EXT4-fs (dm-2): re-mounted. Opts: commit=3D600
[   69.711466] REISERFS (device sdd1): found reiserfs format "3.6"
with standard journal
[   69.711483] REISERFS (device sdd1): using ordered data mode
[   69.722619] REISERFS (device sdd1): journal params: device sdd1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 600, max trans age 600
[   69.722965] REISERFS (device sdd1): checking transaction log (sdd1)
[   69.736959] REISERFS (device sdd1): Using r5 hash to sort names
[   71.122482] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   71.173254] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[   71.174534] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   72.658979] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow
Control: RX
[   72.658986] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   72.660164] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   76.012185] Adding 9420796k swap on /dev/mapper/XPS-SWAP.
Priority:-1 extents:1 across:9420796k
[   82.851744] eth0: no IPv6 routers present
[   93.047830] ehci_hcd 0000:00:1a.0: reused qh ffff8801bc2456c0 schedu=
le
[   93.047838] usb 1-1.1: link qh8-0e01/ffff8801bc2456c0 start 5 [1/2 u=
s]
[   93.973379] coretemp coretemp.0: TjMax is 99 C.
[   93.973668] coretemp coretemp.1: TjMax is 99 C.
[   93.973802] coretemp coretemp.2: TjMax is 99 C.
[   93.974013] coretemp coretemp.3: TjMax is 99 C.
[   94.000505] it87: Found IT8720F chip at 0xa10, revision 8
[   94.000513] it87: VID is disabled (pins used for GPIO)
[   94.000523] it87: Beeping is supported
[  112.781656] ip_tables: (C) 2000-2006 Netfilter Core Team
[  112.828569] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  114.449277] CPUFREQ: Per core conservative sysfs interface is
deprecated - up_threshold
[  114.466801] CPUFREQ: Per core conservative sysfs interface is
deprecated - down_threshold
[  114.538954] firewire_ohci 0000:07:06.0: PCI INT A disabled
[  114.538959] firewire_ohci: Removed fw-ohci device.
[  114.555531] usb 2-1.7: usb_disable_device nuking non-ep0 URBs
[  114.555540] usb 2-1.7: unregistering interface 2-1.7:1.0
[  114.600307] usb 2-1.7: unregistering interface 2-1.7:1.1
[  114.600867] hub 2-1:1.0: logical disconnect on port 7
[  114.601105] hub 2-1:1.0: state 7 ports 8 chg 0080 evt fe00
[  114.601221] hub 2-1:1.0: port 7, status 0501, change 0000, 480 Mb/s
[  114.601353] usb 2-1.7: USB disconnect, address 3
[  114.601358] usb 2-1.7: unregistering device
[  114.601362] usb 2-1.7: usb_disable_device nuking all URBs
[  114.604484] Enabling EXPERIMENTAL delayed logging feature - use at
your own risk.
[  114.641240] XFS mounting filesystem dm-4
[  114.899543] Ending clean XFS mount for filesystem: dm-4
[  115.719119] hub 2-1:1.0: hub_suspend
[  115.719130] usb 2-1: unlink qh256-0001/ffff8801bf5bdc40 start 1 [1/0=
 us]
[  115.719368] usb 2-1: usb auto-suspend
[  117.723726] hub 2-0:1.0: hub_suspend
[  117.723737] usb usb2: bus auto-suspend
[  117.723743] ehci_hcd 0000:00:1d.0: suspend root hub
[  124.414736]   alloc irq_desc for 49 on node -1
[  124.414741]   alloc kstat_irqs on node -1
[  124.414754] fglrx_pci 0000:01:00.0: irq 49 for MSI/MSI-X
[  124.415803] [fglrx] Firegl kernel thread PID: 6526
[  124.416124] [fglrx] IRQ 49 Enabled
[  124.746047] [fglrx] Gart USWC size:1280 M.
[  124.746052] [fglrx] Gart cacheable size:508 M.
[  124.746059] [fglrx] Reserved FB block: Shared offset:0, size:1000000
[  124.746063] [fglrx] Reserved FB block: Unshared offset:f8fd000, size=
:403000
[  124.746067] [fglrx] Reserved FB block: Unshared offset:3fff4000, siz=
e:c000
[  188.989504] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: commit=3D600
[ 1402.175961] conftest[3904]: segfault at ff845f5c ip
00000000f779fff7 sp 00000000ff845f60 error 6 in
ld-2.12.1.so[f779e000+1c000]
[ 1702.266982] hda-intel: IRQ timing workaround is activated for card
#1. Suggest a bigger bdl_pos_adj.
[ 4308.683872] chrome_sandbox (3170): /proc/3168/oom_adj is
deprecated, please use /proc/3168/oom_score_adj instead.
[ 4421.503477] ------------[ cut here ]------------
[ 4421.503482] kernel BUG at fs/ext4/inode.c:2714!
[ 4421.503484] invalid opcode: 0000 [#1] PREEMPT SMP
[ 4421.503487] last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:07:06.0/local_cpus
[ 4421.503489] CPU 5
[ 4421.503490] Modules linked in: iptable_filter ipt_addrtype
xt_iprange xt_conntrack xt_hashlimit xt_string xt_DSCP xt_NFQUEUE
xt_connmark nf_conntrack xt_mark xt_multiport xt_dscp xt_owner
ip_tables x_tables it87 hwmon_vid coretemp hwmon fglrx(P) i2c_i801 wmi
shpchp e1000e libphy e1000 scsi_wait_scan sl811_hcd ohci_hcd ssb
usb_storage ehci_hcd [last unloaded: tg3]
[ 4421.503513]
[ 4421.503516] Pid: 4541, comm: jbd2/dm-2-8 Tainted: P
2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879d410+ #2 FMP55/ipower
G3710
[ 4421.503519] RIP: 0010:[<ffffffff8119cef3>]  [<ffffffff8119cef3>]
ext4_writepage+0x243/0x250
[ 4421.503526] RSP: 0018:ffff8801bc3dfb50  EFLAGS: 00010246
[ 4421.503528] RAX: 800000000002002d RBX: ffffea00047e9190 RCX: 0000000=
000000030
[ 4421.503530] RDX: 0000000000000040 RSI: ffff8801bc3dfcc0 RDI: ffffea0=
0047e9190
[ 4421.503531] RBP: ffff88015d52c120 R08: ffff88012bffede8 R09: 0000000=
000000000
[ 4421.503533] R10: 0000000000000001 R11: 0000000000000008 R12: 0000000=
000001000
[ 4421.503535] R13: ffffea00047e9190 R14: ffff8801bc3dfcc0 R15: ffff880=
1bc3dfc30
[ 4421.503538] FS:  0000000000000000(0000) GS:ffff880002140000(0000)
knlGS:0000000000000000
[ 4421.503540] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4421.503542] CR2: 00007f824cff07e0 CR3: 0000000001c04000 CR4: 0000000=
0000006e0
[ 4421.503544] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 4421.503546] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 4421.503548] Process jbd2/dm-2-8 (pid: 4541, threadinfo
ffff8801bc3de000, task ffff8801bfe3d040)
[ 4421.503549] Stack:
[ 4421.503551]  ffff88015d52c288 ffff88015d52c288 ffff88015d52c288
0000000000000040
[ 4421.503554] <0> ffffea00047e9190 0000000000000007 ffff8801bc3dfc30
ffffffff810a261d
[ 4421.503558] <0> 000000000000000a ffffffff810a2ab1 0000000000000019
ffff8801bc3dfcc0
[ 4421.503562] Call Trace:
[ 4421.503568]  [<ffffffff810a261d>] ? __writepage+0xd/0x40
[ 4421.503571]  [<ffffffff810a2ab1>] ? write_cache_pages+0x1b1/0x3d0
[ 4421.503574]  [<ffffffff810a2610>] ? __writepage+0x0/0x40
[ 4421.503579]  [<ffffffff811d1129>] ? journal_submit_data_buffers+0x99=
/0x100
[ 4421.503583]  [<ffffffff811d1671>] ?
jbd2_journal_commit_transaction+0x331/0x1330
[ 4421.503588]  [<ffffffff8172064b>] ? schedule+0x37b/0x8d0
[ 4421.503591]  [<ffffffff817234c8>] ? _raw_spin_lock_irqsave+0x18/0x20
[ 4421.503596]  [<ffffffff810538c3>] ? lock_timer_base.clone.23+0x33/0x=
70
[ 4421.503599]  [<ffffffff8105396e>] ? try_to_del_timer_sync+0x6e/0x90
[ 4421.503602]  [<ffffffff811d5651>] ? kjournald2+0xb1/0x210
[ 4421.503606]  [<ffffffff81062b80>] ? autoremove_wake_function+0x0/0x3=
0
[ 4421.503609]  [<ffffffff811d55a0>] ? kjournald2+0x0/0x210
[ 4421.503611]  [<ffffffff811d55a0>] ? kjournald2+0x0/0x210
[ 4421.503614]  [<ffffffff81062706>] ? kthread+0x96/0xa0
[ 4421.503619]  [<ffffffff81003394>] ? kernel_thread_helper+0x4/0x10
[ 4421.503622]  [<ffffffff81062670>] ? kthread+0x0/0xa0
[ 4421.503625]  [<ffffffff81003390>] ? kernel_thread_helper+0x0/0x10
[ 4421.503626] Code: ff eb 85 0f 1f 44 00 00 8b 42 70 25 00 0c 00 00
3d 00 04 00 00 74 a4 48 8b 85 78 ff ff ff f6 c4 40 0f 84 6e fe ff ff
eb 92 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 08 ba 01
00 00
[ 4421.503654] RIP  [<ffffffff8119cef3>] ext4_writepage+0x243/0x250
[ 4421.503658]  RSP <ffff8801bc3dfb50>
[ 4421.503660] ---[ end trace e4015dccdd3e00bb ]---



output after mounting the system-partition from my production-system re=
ad-only:

[  297.916518] EXT4-fs (dm-7): INFO: recovery required on readonly file=
system
[  297.916524] EXT4-fs (dm-7): write access will be enabled during reco=
very
[  299.163548] EXT4-fs (dm-7): orphan cleanup on readonly fs
[  299.163560] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135728
[  299.163590] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135724
[  299.163602] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2135723
[  299.163613] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2130123
[  299.163625] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2130118
[  299.163637] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2130112
[  299.163649] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2124353
[  299.163663] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2124352
[  299.163676] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231602
[  299.163719] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231855
[  299.163742] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239521
[  299.163763] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239522
[  299.163784] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239543
[  299.163805] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256039
[  299.163909] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2229219
[  299.163943] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231604
[  299.163968] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239061
[  299.163993] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239066
[  299.164019] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239076
[  299.164043] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255614
[  299.164065] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231130
[  299.164086] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231418
[  299.164107] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239494
[  299.164128] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239501
[  299.164147] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239502
[  299.164168] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255995
[  299.164190] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2124230
[  299.164219] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2124229
[  299.164240] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239530
[  299.164260] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239675
[  299.164281] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239698
[  299.164303] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256311
[  299.164331] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2121629
[  299.164352] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231128
[  299.164373] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256642
[  299.164393] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396379
[  299.164425] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2396382
[  299.164444] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2394210
[  299.164504] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2394225
[  299.164558] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2394213
[  299.164578] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231127
[  299.164598] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2231129
[  299.164618] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255759
[  299.164638] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255765
[  299.164659] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255766
[  299.164679] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256260
[  299.164757] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310848
[  299.164789] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310828
[  299.164833] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2119751
[  299.164855] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2119749
[  299.164876] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2121630
[  299.164896] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239661
[  299.164918] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239662
[  299.164938] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256248
[  299.164970] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118252
[  299.164991] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118116
[  299.165011] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239162
[  299.165032] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239210
[  299.165054] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255869
[  299.165075] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118051
[  299.165095] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118050
[  299.165115] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2124234
[  299.165134] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239552
[  299.165153] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239553
[  299.165174] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2256120
[  299.165202] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118049
[  299.165221] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118048
[  299.165241] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239340
[  299.165263] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239341
[  299.165288] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239342
[  299.165579] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255886
[  299.165609] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118047
[  299.165640] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2118046
[  299.165663] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2141211
[  299.165689] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239013
[  299.165714] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255754
[  299.165741] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2115691
[  299.165767] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111912
[  299.165792] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239350
[  299.165828] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2239382
[  299.165859] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2255884
[  299.165890] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111911
[  299.165910] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2111910
[  299.176933] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144426
[  299.176975] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144430
[  299.177024] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144438
[  299.177055] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144443
[  299.177092] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144446
[  299.177120] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144448
[  299.177150] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1310823
[  299.192467] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 1318750
[  299.200600] EXT4-fs (dm-7): ext4_orphan_cleanup: deleting
unreferenced inode 2144930
[  299.200669] EXT4-fs (dm-7): 92 orphan inodes deleted
[  299.200674] EXT4-fs (dm-7): recovery complete
[  300.069586] EXT4-fs (dm-7): mounted filesystem with ordered data
mode. Opts: commit=3D600,barrier=3D1


addr2line -e /mnt/gentoo/usr/src/linux-2.6.37-rc_1de3e3df917459422cb2ae=
cac440febc8879d410/vmlinux
-i ffffffff8119cef3
inode.c:0






















#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.36-rc6_1de3e3df917459422cb2aecac440febc8879=
d410
# Sat Dec  4 18:32:40 2010
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_HAVE_EARLY_RES=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_X86_TRAMPOLINE=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=3Dy

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=3Dy
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_POSIX_MQUEUE_SYSCTL=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=3Dy
CONFIG_TASK_DELAY_ACCT=3Dy
CONFIG_TASK_XACCT=3Dy
CONFIG_TASK_IO_ACCOUNTING=3Dy
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
CONFIG_TREE_PREEMPT_RCU=3Dy
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=3Dy
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D"/usr/share/v86d/initramfs"
CONFIG_INITRAMFS_ROOT_UID=3D0
CONFIG_INITRAMFS_ROOT_GID=3D0
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_RD_LZO=3Dy
# CONFIG_INITRAMFS_COMPRESSION_NONE is not set
# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
CONFIG_INITRAMFS_COMPRESSION_LZMA=3Dy
# CONFIG_INITRAMFS_COMPRESSION_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EMBEDDED=3Dy
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=3Dy
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=3Dy
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_DEFAULT_DEADLINE=3Dy
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"deadline"
CONFIG_PADATA=3Dy
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_SMP=3Dy
CONFIG_SPARSE_IRQ=3Dy
CONFIG_X86_MPPARSE=3Dy
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=3Dy
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=3Dy
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=3Dy
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_P6_NOP=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_PROCESSOR_SELECT=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
CONFIG_CALGARY_IOMMU=3Dy
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=3Dy
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D16
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=3Dy
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=3Dy
CONFIG_I8K=3Dm
CONFIG_MICROCODE=3Dy
CONFIG_MICROCODE_INTEL=3Dy
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D999999
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_KSM=3Dy
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=3Dy
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=3Dy
CONFIG_X86_RESERVE_LOW_64K=3Dy
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
CONFIG_CC_STACKPROTECTOR=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
CONFIG_HZ=3D1000
CONFIG_SCHED_HRTICK=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND_NVS=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_PM_RUNTIME=3Dy
CONFIG_PM_OPS=3Dy
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_PROCFS_POWER=3Dy
CONFIG_ACPI_POWER_METER=3Dm
CONFIG_ACPI_SYSFS_POWER=3Dy
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_FAN=3Dy
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_PROCESSOR_AGGREGATOR=3Dm
CONFIG_ACPI_THERMAL=3Dy
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=3Dy
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dy
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=3Dm
CONFIG_ACPI_APEI=3Dy
CONFIG_ACPI_APEI_GHES=3Dm
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
CONFIG_CPU_FREQ_DEBUG=3Dy
CONFIG_CPU_FREQ_STAT=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=3Dy
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dy

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
CONFIG_PCI_CNB20LE_QUIRK=3Dy
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_HOTPLUG_PCI_PCIE=3Dm
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=3Dy
CONFIG_PCIEASPM_DEBUG=3Dy
CONFIG_PCIE_PME=3Dy
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=3Dy
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_K8_NB=3Dy
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=3Dy
CONFIG_HOTPLUG_PCI_FAKE=3Dm
CONFIG_HOTPLUG_PCI_ACPI=3Dm
CONFIG_HOTPLUG_PCI_ACPI_IBM=3Dm
CONFIG_HOTPLUG_PCI_CPCI=3Dy
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=3Dm
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=3Dm
CONFIG_HOTPLUG_PCI_SHPC=3Dm

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_NET=3Dy
CONFIG_COMPAT_NETLINK_MESSAGES=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dy
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=3Dy
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dy
CONFIG_NET_KEY=3Dy
CONFIG_NET_KEY_MIGRATE=3Dy
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
CONFIG_IP_ROUTE_MULTIPATH=3Dy
CONFIG_IP_ROUTE_VERBOSE=3Dy
CONFIG_IP_PNP=3Dy
CONFIG_IP_PNP_DHCP=3Dy
CONFIG_IP_PNP_BOOTP=3Dy
CONFIG_IP_PNP_RARP=3Dy
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dy
CONFIG_INET_ESP=3Dy
CONFIG_INET_IPCOMP=3Dy
CONFIG_INET_XFRM_TUNNEL=3Dy
CONFIG_INET_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_BEET=3Dy
CONFIG_INET_LRO=3Dy
CONFIG_INET_DIAG=3Dy
CONFIG_INET_TCP_DIAG=3Dy
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
CONFIG_TCP_MD5SIG=3Dy
CONFIG_IPV6=3Dy
CONFIG_IPV6_PRIVACY=3Dy
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=3Dy
CONFIG_INET6_ESP=3Dy
CONFIG_INET6_IPCOMP=3Dy
CONFIG_IPV6_MIP6=3Dm
CONFIG_INET6_XFRM_TUNNEL=3Dy
CONFIG_INET6_TUNNEL=3Dy
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET6_XFRM_MODE_BEET=3Dy
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=3Dm
CONFIG_IPV6_SIT=3Dy
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dm
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=3Dy
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
CONFIG_NF_CONNTRACK=3Dm
CONFIG_NF_CONNTRACK_MARK=3Dy
CONFIG_NF_CONNTRACK_SECMARK=3Dy
CONFIG_NF_CONNTRACK_EVENTS=3Dy
CONFIG_NF_CT_PROTO_DCCP=3Dm
CONFIG_NF_CT_PROTO_GRE=3Dm
CONFIG_NF_CT_PROTO_SCTP=3Dm
CONFIG_NF_CT_PROTO_UDPLITE=3Dm
CONFIG_NF_CONNTRACK_AMANDA=3Dm
CONFIG_NF_CONNTRACK_FTP=3Dm
CONFIG_NF_CONNTRACK_H323=3Dm
CONFIG_NF_CONNTRACK_IRC=3Dm
CONFIG_NF_CONNTRACK_NETBIOS_NS=3Dm
CONFIG_NF_CONNTRACK_PPTP=3Dm
CONFIG_NF_CONNTRACK_SANE=3Dm
CONFIG_NF_CONNTRACK_SIP=3Dm
CONFIG_NF_CONNTRACK_TFTP=3Dm
CONFIG_NF_CT_NETLINK=3Dm
CONFIG_NETFILTER_TPROXY=3Dm
CONFIG_NETFILTER_XTABLES=3Dm

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=3Dm
CONFIG_NETFILTER_XT_CONNMARK=3Dm

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=3Dm
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=3Dm
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dm
CONFIG_NETFILTER_XT_TARGET_HL=3Dm
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=3Dm
CONFIG_NETFILTER_XT_TARGET_LED=3Dm
CONFIG_NETFILTER_XT_TARGET_MARK=3Dm
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dm
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=3Dm
CONFIG_NETFILTER_XT_TARGET_NOTRACK=3Dm
CONFIG_NETFILTER_XT_TARGET_RATEEST=3Dm
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=3Dm
CONFIG_NETFILTER_XT_TARGET_TRACE=3Dm
CONFIG_NETFILTER_XT_TARGET_SECMARK=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPMSS=3Dm
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=3Dm

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=3Dm
CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNMARK=3Dm
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=3Dm
CONFIG_NETFILTER_XT_MATCH_CPU=3Dm
CONFIG_NETFILTER_XT_MATCH_DCCP=3Dm
CONFIG_NETFILTER_XT_MATCH_DSCP=3Dm
CONFIG_NETFILTER_XT_MATCH_ESP=3Dm
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_HELPER=3Dm
CONFIG_NETFILTER_XT_MATCH_HL=3Dm
CONFIG_NETFILTER_XT_MATCH_IPRANGE=3Dm
CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
CONFIG_NETFILTER_XT_MATCH_LIMIT=3Dm
CONFIG_NETFILTER_XT_MATCH_MAC=3Dm
CONFIG_NETFILTER_XT_MATCH_MARK=3Dm
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=3Dm
CONFIG_NETFILTER_XT_MATCH_OSF=3Dm
CONFIG_NETFILTER_XT_MATCH_OWNER=3Dm
CONFIG_NETFILTER_XT_MATCH_POLICY=3Dm
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=3Dm
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=3Dm
CONFIG_NETFILTER_XT_MATCH_QUOTA=3Dm
CONFIG_NETFILTER_XT_MATCH_RATEEST=3Dm
CONFIG_NETFILTER_XT_MATCH_REALM=3Dm
CONFIG_NETFILTER_XT_MATCH_RECENT=3Dm
CONFIG_NETFILTER_XT_MATCH_SCTP=3Dm
CONFIG_NETFILTER_XT_MATCH_SOCKET=3Dm
CONFIG_NETFILTER_XT_MATCH_STATE=3Dm
CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
CONFIG_NETFILTER_XT_MATCH_STRING=3Dm
CONFIG_NETFILTER_XT_MATCH_TCPMSS=3Dm
CONFIG_NETFILTER_XT_MATCH_TIME=3Dm
CONFIG_NETFILTER_XT_MATCH_U32=3Dm
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dm
CONFIG_NF_CONNTRACK_IPV4=3Dm
CONFIG_NF_CONNTRACK_PROC_COMPAT=3Dy
CONFIG_IP_NF_QUEUE=3Dm
CONFIG_IP_NF_IPTABLES=3Dm
CONFIG_IP_NF_MATCH_ADDRTYPE=3Dm
CONFIG_IP_NF_MATCH_AH=3Dm
CONFIG_IP_NF_MATCH_ECN=3Dm
CONFIG_IP_NF_MATCH_TTL=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_TARGET_REJECT=3Dm
CONFIG_IP_NF_TARGET_LOG=3Dm
CONFIG_IP_NF_TARGET_ULOG=3Dm
CONFIG_NF_NAT=3Dm
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dm
CONFIG_IP_NF_TARGET_NETMAP=3Dm
CONFIG_IP_NF_TARGET_REDIRECT=3Dm
CONFIG_NF_NAT_SNMP_BASIC=3Dm
CONFIG_NF_NAT_PROTO_DCCP=3Dm
CONFIG_NF_NAT_PROTO_GRE=3Dm
CONFIG_NF_NAT_PROTO_UDPLITE=3Dm
CONFIG_NF_NAT_PROTO_SCTP=3Dm
CONFIG_NF_NAT_FTP=3Dm
CONFIG_NF_NAT_IRC=3Dm
CONFIG_NF_NAT_TFTP=3Dm
CONFIG_NF_NAT_AMANDA=3Dm
CONFIG_NF_NAT_PPTP=3Dm
CONFIG_NF_NAT_H323=3Dm
CONFIG_NF_NAT_SIP=3Dm
CONFIG_IP_NF_MANGLE=3Dm
CONFIG_IP_NF_TARGET_CLUSTERIP=3Dm
CONFIG_IP_NF_TARGET_ECN=3Dm
CONFIG_IP_NF_TARGET_TTL=3Dm
CONFIG_IP_NF_RAW=3Dm
CONFIG_IP_NF_ARPTABLES=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP_NF_ARP_MANGLE=3Dm

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=3Dm
CONFIG_IP6_NF_QUEUE=3Dm
CONFIG_IP6_NF_IPTABLES=3Dm
CONFIG_IP6_NF_MATCH_AH=3Dm
CONFIG_IP6_NF_MATCH_EUI64=3Dm
CONFIG_IP6_NF_MATCH_FRAG=3Dm
CONFIG_IP6_NF_MATCH_OPTS=3Dm
CONFIG_IP6_NF_MATCH_HL=3Dm
CONFIG_IP6_NF_MATCH_IPV6HEADER=3Dm
CONFIG_IP6_NF_MATCH_MH=3Dm
CONFIG_IP6_NF_MATCH_RT=3Dm
CONFIG_IP6_NF_TARGET_HL=3Dm
CONFIG_IP6_NF_TARGET_LOG=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_IP6_NF_TARGET_REJECT=3Dm
CONFIG_IP6_NF_MANGLE=3Dm
CONFIG_IP6_NF_RAW=3Dm
CONFIG_BRIDGE_NF_EBTABLES=3Dm
CONFIG_BRIDGE_EBT_BROUTE=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_NAT=3Dm
CONFIG_BRIDGE_EBT_802_3=3Dm
CONFIG_BRIDGE_EBT_AMONG=3Dm
CONFIG_BRIDGE_EBT_ARP=3Dm
CONFIG_BRIDGE_EBT_IP=3Dm
CONFIG_BRIDGE_EBT_IP6=3Dm
CONFIG_BRIDGE_EBT_LIMIT=3Dm
CONFIG_BRIDGE_EBT_MARK=3Dm
CONFIG_BRIDGE_EBT_PKTTYPE=3Dm
CONFIG_BRIDGE_EBT_STP=3Dm
CONFIG_BRIDGE_EBT_VLAN=3Dm
CONFIG_BRIDGE_EBT_ARPREPLY=3Dm
CONFIG_BRIDGE_EBT_DNAT=3Dm
CONFIG_BRIDGE_EBT_MARK_T=3Dm
CONFIG_BRIDGE_EBT_REDIRECT=3Dm
CONFIG_BRIDGE_EBT_SNAT=3Dm
CONFIG_BRIDGE_EBT_LOG=3Dm
CONFIG_BRIDGE_EBT_ULOG=3Dm
CONFIG_BRIDGE_EBT_NFLOG=3Dm
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=3Dm
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=3Dy
CONFIG_RDS=3Dm
CONFIG_RDS_TCP=3Dm
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=3Dm
CONFIG_ATM_CLIP=3Dm
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=3Dm
CONFIG_ATM_MPOA=3Dm
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=3Dm
CONFIG_BRIDGE=3Dm
CONFIG_BRIDGE_IGMP_SNOOPING=3Dy
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=3Dm
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=3Dm
# CONFIG_LLC2 is not set
CONFIG_IPX=3Dm
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=3Dm
CONFIG_DEV_APPLETALK=3Dm
CONFIG_IPDDP=3Dm
CONFIG_IPDDP_ENCAP=3Dy
CONFIG_IPDDP_DECAP=3Dy
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=3Dm
CONFIG_IEEE802154=3Dm
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=3Dy
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=3Dy
CONFIG_RPS=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=3Dm
CONFIG_CAN_RAW=3Dm
CONFIG_CAN_BCM=3Dm

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=3Dm
CONFIG_CAN_DEV=3Dm
CONFIG_CAN_CALC_BITTIMING=3Dy
CONFIG_CAN_SJA1000=3Dm
CONFIG_CAN_SJA1000_PLATFORM=3Dm
CONFIG_CAN_EMS_PCI=3Dm
CONFIG_CAN_KVASER_PCI=3Dm
# CONFIG_CAN_PLX_PCI is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
CONFIG_BT_SCO=3Dm
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
CONFIG_BT_CMTP=3Dm
CONFIG_BT_HIDP=3Dm

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=3Dm
CONFIG_BT_HCIBTSDIO=3Dm
CONFIG_BT_HCIUART=3Dm
CONFIG_BT_HCIUART_H4=3Dy
CONFIG_BT_HCIUART_BCSP=3Dy
CONFIG_BT_HCIUART_ATH3K=3Dy
CONFIG_BT_HCIUART_LL=3Dy
CONFIG_BT_HCIBCM203X=3Dm
CONFIG_BT_HCIBPA10X=3Dm
CONFIG_BT_HCIBFUSB=3Dm
CONFIG_BT_HCIVHCI=3Dm
CONFIG_BT_MRVL=3Dm
CONFIG_BT_MRVL_SDIO=3Dm
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_WIRELESS_EXT=3Dy
CONFIG_WEXT_CORE=3Dy
CONFIG_WEXT_PROC=3Dy
CONFIG_WEXT_SPY=3Dy
CONFIG_WEXT_PRIV=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=3Dy
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=3Dy
CONFIG_WIRELESS_EXT_SYSFS=3Dy
CONFIG_LIB80211=3Dy
CONFIG_LIB80211_CRYPT_WEP=3Dm
CONFIG_LIB80211_CRYPT_CCMP=3Dm
CONFIG_LIB80211_CRYPT_TKIP=3Dm
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_HAS_RC=3Dy
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=3Dy
CONFIG_MAC80211_RC_MINSTREL_HT=3Dy
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=3Dm
CONFIG_WIMAX_DEBUG_LEVEL=3D8
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_LEDS=3Dy
CONFIG_RFKILL_INPUT=3Dy
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dy
CONFIG_PROC_EVENTS=3Dy
# CONFIG_MTD is not set
CONFIG_PARPORT=3Dm
CONFIG_PARPORT_PC=3Dm
CONFIG_PARPORT_SERIAL=3Dm
CONFIG_PARPORT_PC_FIFO=3Dy
CONFIG_PARPORT_PC_SUPERIO=3Dy
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=3Dm
CONFIG_PARPORT_1284=3Dy
CONFIG_PARPORT_NOT_PC=3Dy
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
CONFIG_BLK_DEV_FD=3Dm
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D16384
CONFIG_BLK_DEV_XIP=3Dy
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=3Dy
CONFIG_AD525X_DPOT=3Dm
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=3Dm
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
CONFIG_SENSORS_TSL2550=3Dm
CONFIG_SENSORS_BH1780=3Dm
CONFIG_HMC6352=3Dm
CONFIG_DS1682=3Dm
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=3Dm
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=3Dm
CONFIG_EEPROM_93CX6=3Dm
CONFIG_CB710_CORE=3Dm
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=3Dy
CONFIG_IWMC3200TOP=3Dm
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set
CONFIG_HAVE_IDE=3Dy
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
CONFIG_RAID_ATTRS=3Dy
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dy
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dy
CONFIG_CHR_DEV_SCH=3Dy
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=3Dy
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dy
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=3Dy
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=3Dy
CONFIG_SATA_SIL24=3Dy
CONFIG_ATA_SFF=3Dy

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=3Dy
CONFIG_SATA_QSTOR=3Dy
CONFIG_SATA_SX4=3Dy
CONFIG_ATA_BMDMA=3Dy

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=3Dy
CONFIG_SATA_MV=3Dy
CONFIG_SATA_NV=3Dy
CONFIG_SATA_PROMISE=3Dy
CONFIG_SATA_SIL=3Dy
CONFIG_SATA_SIS=3Dy
CONFIG_SATA_SVW=3Dy
CONFIG_SATA_ULI=3Dy
CONFIG_SATA_VIA=3Dy
CONFIG_SATA_VITESSE=3Dy

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=3Dy
CONFIG_PATA_AMD=3Dy
CONFIG_PATA_ARTOP=3Dy
CONFIG_PATA_ATIIXP=3Dy
CONFIG_PATA_ATP867X=3Dy
CONFIG_PATA_CMD64X=3Dy
CONFIG_PATA_CS5520=3Dy
CONFIG_PATA_CS5530=3Dy
CONFIG_PATA_CYPRESS=3Dy
CONFIG_PATA_EFAR=3Dy
CONFIG_PATA_HPT366=3Dy
CONFIG_PATA_HPT37X=3Dy
CONFIG_PATA_HPT3X2N=3Dy
CONFIG_PATA_HPT3X3=3Dy
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=3Dy
CONFIG_PATA_IT821X=3Dy
CONFIG_PATA_JMICRON=3Dy
CONFIG_PATA_MARVELL=3Dy
CONFIG_PATA_NETCELL=3Dy
CONFIG_PATA_NINJA32=3Dy
CONFIG_PATA_NS87415=3Dy
CONFIG_PATA_OLDPIIX=3Dy
CONFIG_PATA_OPTIDMA=3Dy
CONFIG_PATA_PDC2027X=3Dy
CONFIG_PATA_PDC_OLD=3Dy
CONFIG_PATA_RADISYS=3Dy
CONFIG_PATA_RDC=3Dy
CONFIG_PATA_SC1200=3Dy
CONFIG_PATA_SCH=3Dy
CONFIG_PATA_SERVERWORKS=3Dy
CONFIG_PATA_SIL680=3Dy
CONFIG_PATA_SIS=3Dy
CONFIG_PATA_TOSHIBA=3Dy
CONFIG_PATA_TRIFLEX=3Dy
CONFIG_PATA_VIA=3Dy
CONFIG_PATA_WINBOND=3Dy

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=3Dy
CONFIG_PATA_MPIIX=3Dy
CONFIG_PATA_NS87410=3Dy
CONFIG_PATA_OPTI=3Dy
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=3Dy

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=3Dy
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
CONFIG_MD_LINEAR=3Dy
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
CONFIG_MD_RAID10=3Dy
CONFIG_MD_RAID456=3Dy
CONFIG_MULTICORE_RAID456=3Dy
CONFIG_MD_MULTIPATH=3Dy
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dy
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dy
CONFIG_DM_SNAPSHOT=3Dy
CONFIG_DM_MIRROR=3Dy
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=3Dy
CONFIG_DM_MULTIPATH=3Dy
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=3Dy
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=3Dm
CONFIG_FIREWIRE_OHCI=3Dm
CONFIG_FIREWIRE_OHCI_DEBUG=3Dy
CONFIG_FIREWIRE_SBP2=3Dm
# CONFIG_FIREWIRE_NET is not set
# CONFIG_IEEE1394 is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=3Dm
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=3Dy
CONFIG_I2O_EXT_ADAPTEC=3Dy
CONFIG_I2O_EXT_ADAPTEC_DMA64=3Dy
CONFIG_I2O_CONFIG=3Dm
CONFIG_I2O_CONFIG_OLD_IOCTL=3Dy
CONFIG_I2O_BUS=3Dm
CONFIG_I2O_BLOCK=3Dm
CONFIG_I2O_SCSI=3Dm
CONFIG_I2O_PROC=3Dm
CONFIG_MACINTOSH_DRIVERS=3Dy
CONFIG_MAC_EMUMOUSEBTN=3Dy
CONFIG_NETDEVICES=3Dy
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=3Dy
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=3Dm

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=3Dm
CONFIG_DAVICOM_PHY=3Dm
CONFIG_QSEMI_PHY=3Dm
CONFIG_LXT_PHY=3Dm
CONFIG_CICADA_PHY=3Dm
CONFIG_VITESSE_PHY=3Dm
CONFIG_SMSC_PHY=3Dm
CONFIG_BROADCOM_PHY=3Dm
CONFIG_ICPLUS_PHY=3Dm
CONFIG_REALTEK_PHY=3Dm
CONFIG_NATIONAL_PHY=3Dm
CONFIG_STE10XP=3Dm
CONFIG_LSI_ET1011C_PHY=3Dm
CONFIG_MICREL_PHY=3Dm
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
CONFIG_HAPPYMEAL=3Dm
CONFIG_SUNGEM=3Dm
CONFIG_CASSINI=3Dm
CONFIG_NET_VENDOR_3COM=3Dy
CONFIG_VORTEX=3Dm
CONFIG_TYPHOON=3Dm
CONFIG_ETHOC=3Dm
CONFIG_DNET=3Dm
CONFIG_NET_TULIP=3Dy
CONFIG_DE2104X=3Dm
CONFIG_DE2104X_DSL=3D0
CONFIG_TULIP=3Dm
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=3Dm
CONFIG_WINBOND_840=3Dm
CONFIG_DM9102=3Dm
CONFIG_ULI526X=3Dm
CONFIG_HP100=3Dm
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=3Dy
CONFIG_PCNET32=3Dm
CONFIG_AMD8111_ETH=3Dm
CONFIG_ADAPTEC_STARFIRE=3Dm
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=3Dm
CONFIG_B44_PCI_AUTOSELECT=3Dy
CONFIG_B44_PCICORE_AUTOSELECT=3Dy
CONFIG_B44_PCI=3Dy
CONFIG_FORCEDETH=3Dm
CONFIG_E100=3Dm
CONFIG_FEALNX=3Dm
CONFIG_NATSEMI=3Dm
CONFIG_NE2K_PCI=3Dm
CONFIG_8139CP=3Dm
CONFIG_8139TOO=3Dm
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=3Dy
CONFIG_8139TOO_8129=3Dy
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=3Dm
CONFIG_SIS900=3Dm
CONFIG_EPIC100=3Dm
CONFIG_SMSC9420=3Dm
CONFIG_SUNDANCE=3Dm
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=3Dm
CONFIG_KS8842=3Dm
CONFIG_KS8851_MLL=3Dm
CONFIG_VIA_RHINE=3Dm
CONFIG_VIA_RHINE_MMIO=3Dy
CONFIG_SC92031=3Dm
CONFIG_NET_POCKET=3Dy
CONFIG_ATP=3Dm
CONFIG_DE600=3Dm
CONFIG_DE620=3Dm
CONFIG_ATL2=3Dm
CONFIG_NETDEV_1000=3Dy
CONFIG_ACENIC=3Dm
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=3Dm
CONFIG_E1000=3Dm
CONFIG_E1000E=3Dm
CONFIG_IP1000=3Dm
CONFIG_IGB=3Dm
CONFIG_IGB_DCA=3Dy
CONFIG_IGBVF=3Dm
CONFIG_NS83820=3Dm
CONFIG_HAMACHI=3Dm
CONFIG_YELLOWFIN=3Dm
CONFIG_R8169=3Dm
CONFIG_R8169_VLAN=3Dy
CONFIG_SIS190=3Dm
CONFIG_SKGE=3Dm
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=3Dm
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=3Dm
CONFIG_TIGON3=3Dm
CONFIG_BNX2=3Dm
CONFIG_CNIC=3Dm
CONFIG_QLA3XXX=3Dm
CONFIG_ATL1=3Dm
CONFIG_ATL1E=3Dm
CONFIG_ATL1C=3Dm
CONFIG_JME=3Dm
CONFIG_NETDEV_10000=3Dy
CONFIG_MDIO=3Dm
CONFIG_CHELSIO_T1=3Dm
CONFIG_CHELSIO_T1_1G=3Dy
CONFIG_CHELSIO_T3_DEPENDS=3Dy
CONFIG_CHELSIO_T3=3Dm
CONFIG_CHELSIO_T4_DEPENDS=3Dy
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF_DEPENDS=3Dy
CONFIG_CHELSIO_T4VF=3Dm
CONFIG_ENIC=3Dm
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_IXGB=3Dm
CONFIG_S2IO=3Dm
CONFIG_VXGE=3Dm
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_MYRI10GE=3Dm
CONFIG_MYRI10GE_DCA=3Dy
CONFIG_NETXEN_NIC=3Dm
CONFIG_NIU=3Dm
CONFIG_MLX4_EN=3Dm
CONFIG_MLX4_CORE=3Dm
# CONFIG_MLX4_DEBUG is not set
CONFIG_TEHUTI=3Dm
CONFIG_BNX2X=3Dm
# CONFIG_QLCNIC is not set
CONFIG_QLGE=3Dm
CONFIG_SFC=3Dm
CONFIG_BE2NET=3Dm
# CONFIG_TR is not set
CONFIG_WLAN=3Dy
CONFIG_LIBERTAS_THINFIRM=3Dm
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=3Dm
CONFIG_AIRO=3Dm
CONFIG_ATMEL=3Dm
CONFIG_PCI_ATMEL=3Dm
CONFIG_AT76C50X_USB=3Dm
CONFIG_PRISM54=3Dm
CONFIG_USB_ZD1201=3Dm
CONFIG_USB_NET_RNDIS_WLAN=3Dm
CONFIG_RTL8180=3Dm
CONFIG_RTL8187=3Dm
CONFIG_RTL8187_LEDS=3Dy
CONFIG_ADM8211=3Dm
CONFIG_MAC80211_HWSIM=3Dm
CONFIG_MWL8K=3Dm
CONFIG_ATH_COMMON=3Dm
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=3Dm
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
CONFIG_AR9170_USB=3Dm
CONFIG_AR9170_LEDS=3Dy
CONFIG_B43=3Dm
CONFIG_B43_PCI_AUTOSELECT=3Dy
CONFIG_B43_PCICORE_AUTOSELECT=3Dy
# CONFIG_B43_SDIO is not set
CONFIG_B43_PIO=3Dy
CONFIG_B43_PHY_LP=3Dy
CONFIG_B43_LEDS=3Dy
CONFIG_B43_HWRNG=3Dy
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=3Dm
CONFIG_B43LEGACY_PCI_AUTOSELECT=3Dy
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=3Dy
CONFIG_B43LEGACY_LEDS=3Dy
CONFIG_B43LEGACY_HWRNG=3Dy
CONFIG_B43LEGACY_DEBUG=3Dy
CONFIG_B43LEGACY_DMA=3Dy
CONFIG_B43LEGACY_PIO=3Dy
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=3Dy
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HOSTAP=3Dm
CONFIG_HOSTAP_FIRMWARE=3Dy
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=3Dm
CONFIG_HOSTAP_PCI=3Dm
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=3Dm
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=3Dm
CONFIG_IWM=3Dm
# CONFIG_IWM_DEBUG is not set
CONFIG_LIBERTAS=3Dm
CONFIG_LIBERTAS_USB=3Dm
CONFIG_LIBERTAS_SDIO=3Dm
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=3Dm
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=3Dy
CONFIG_PLX_HERMES=3Dm
CONFIG_TMD_HERMES=3Dm
CONFIG_NORTEL_HERMES=3Dm
# CONFIG_ORINOCO_USB is not set
CONFIG_P54_COMMON=3Dm
CONFIG_P54_USB=3Dm
CONFIG_P54_PCI=3Dm
CONFIG_P54_LEDS=3Dy
CONFIG_RT2X00=3Dm
CONFIG_RT2400PCI=3Dm
CONFIG_RT2500PCI=3Dm
CONFIG_RT61PCI=3Dm
CONFIG_RT2800PCI_PCI=3Dy
CONFIG_RT2800PCI=3Dm
# CONFIG_RT2800PCI_RT30XX is not set
# CONFIG_RT2800PCI_RT35XX is not set
CONFIG_RT2500USB=3Dm
CONFIG_RT73USB=3Dm
CONFIG_RT2800USB=3Dm
# CONFIG_RT2800USB_RT30XX is not set
# CONFIG_RT2800USB_RT35XX is not set
# CONFIG_RT2800USB_UNKNOWN is not set
CONFIG_RT2800_LIB=3Dm
CONFIG_RT2X00_LIB_PCI=3Dm
CONFIG_RT2X00_LIB_USB=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_HT=3Dy
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2X00_LIB_CRYPTO=3Dy
CONFIG_RT2X00_LIB_LEDS=3Dy
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_WL12XX is not set
CONFIG_ZD1211RW=3Dm
# CONFIG_ZD1211RW_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WIMAX_I2400M_SDIO is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_AX8817X=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_DM9601=3Dm
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=3Dm
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
CONFIG_USB_NET_MCS7830=3Dm
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
CONFIG_USB_KC2190=3Dy
CONFIG_USB_NET_ZAURUS=3Dm
CONFIG_USB_HSO=3Dm
CONFIG_USB_NET_INT51X1=3Dm
CONFIG_USB_CDC_PHONET=3Dm
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=3Dy
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=3Dm
CONFIG_ATM_LANAI=3Dm
CONFIG_ATM_ENI=3Dm
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=3Dm
CONFIG_ATM_ZATM=3Dm
# CONFIG_ATM_ZATM_DEBUG is not set
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=3Dm
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=3Dy
CONFIG_ATM_AMBASSADOR=3Dm
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=3Dm
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=3Dm
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=3Dm
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=3D16
CONFIG_ATM_FORE200E_DEBUG=3D0
CONFIG_ATM_HE=3Dm
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=3Dm
CONFIG_IEEE802154_DRIVERS=3Dm
# CONFIG_IEEE802154_FAKEHARD is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
CONFIG_PPPOATM=3Dm
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dm
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_VMXNET3=3Dm
CONFIG_ISDN=3Dy
CONFIG_ISDN_I4L=3Dm
# CONFIG_ISDN_PPP is not set
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=3Dm
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=3Dy
CONFIG_CAPI_TRACE=3Dy
CONFIG_ISDN_CAPI_MIDDLEWARE=3Dy
CONFIG_ISDN_CAPI_CAPI20=3Dm
CONFIG_ISDN_CAPI_CAPIFS_BOOL=3Dy
CONFIG_ISDN_CAPI_CAPIFS=3Dm
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=3Dy
CONFIG_ISDN_DRV_AVMB1_B1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=3Dy
CONFIG_ISDN_DRV_AVMB1_T1PCI=3Dm
CONFIG_ISDN_DRV_AVMB1_C4=3Dm
CONFIG_CAPI_EICON=3Dy
CONFIG_ISDN_DIVAS=3Dm
CONFIG_ISDN_DIVAS_BRIPCI=3Dy
CONFIG_ISDN_DIVAS_PRIPCI=3Dy
CONFIG_ISDN_DIVAS_DIVACAPI=3Dm
CONFIG_ISDN_DIVAS_USERIDI=3Dm
CONFIG_ISDN_DIVAS_MAINT=3Dm
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_HYSDN is not set
CONFIG_MISDN=3Dm
CONFIG_MISDN_DSP=3Dm
CONFIG_MISDN_L1OIP=3Dm

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=3Dm
CONFIG_MISDN_HFCMULTI=3Dm
CONFIG_MISDN_HFCUSB=3Dm
CONFIG_MISDN_AVMFRITZ=3Dm
CONFIG_MISDN_SPEEDFAX=3Dm
CONFIG_MISDN_INFINEON=3Dm
CONFIG_MISDN_W6692=3Dm
CONFIG_MISDN_NETJET=3Dm
CONFIG_MISDN_IPAC=3Dm
CONFIG_MISDN_ISAR=3Dm
CONFIG_ISDN_HDLC=3Dm
CONFIG_PHONE=3Dm
CONFIG_PHONE_IXJ=3Dm

#
# Input device support
#
CONFIG_INPUT=3Dy
CONFIG_INPUT_FF_MEMLESS=3Dy
CONFIG_INPUT_POLLDEV=3Dy
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dy
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ADP5588=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=3Dm
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_LM8323=3Dm
CONFIG_KEYBOARD_MAX7359=3Dm
CONFIG_KEYBOARD_MCS=3Dm
CONFIG_KEYBOARD_NEWTON=3Dm
CONFIG_KEYBOARD_OPENCORES=3Dm
CONFIG_KEYBOARD_STOWAWAY=3Dm
CONFIG_KEYBOARD_SUNKBD=3Dm
CONFIG_KEYBOARD_XTKBD=3Dm
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dy
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
CONFIG_MOUSE_PS2_ELANTECH=3Dy
CONFIG_MOUSE_PS2_SENTELIC=3Dy
CONFIG_MOUSE_PS2_TOUCHKIT=3Dy
CONFIG_MOUSE_SERIAL=3Dm
CONFIG_MOUSE_APPLETOUCH=3Dm
CONFIG_MOUSE_BCM5974=3Dm
CONFIG_MOUSE_VSXXXAA=3Dm
CONFIG_MOUSE_SYNAPTICS_I2C=3Dy
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=3Dy
CONFIG_TABLET_USB_ACECAD=3Dm
CONFIG_TABLET_USB_AIPTEK=3Dm
CONFIG_TABLET_USB_GTCO=3Dm
CONFIG_TABLET_USB_KBTAB=3Dm
CONFIG_TABLET_USB_WACOM=3Dm
CONFIG_INPUT_TOUCHSCREEN=3Dy
CONFIG_TOUCHSCREEN_AD7879=3Dm
CONFIG_TOUCHSCREEN_AD7879_I2C=3Dm
CONFIG_TOUCHSCREEN_DYNAPRO=3Dm
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=3Dm
CONFIG_TOUCHSCREEN_FUJITSU=3Dm
CONFIG_TOUCHSCREEN_GUNZE=3Dm
CONFIG_TOUCHSCREEN_ELO=3Dm
CONFIG_TOUCHSCREEN_WACOM_W8001=3Dm
CONFIG_TOUCHSCREEN_MCS5000=3Dm
CONFIG_TOUCHSCREEN_MTOUCH=3Dm
CONFIG_TOUCHSCREEN_INEXIO=3Dm
CONFIG_TOUCHSCREEN_MK712=3Dm
CONFIG_TOUCHSCREEN_PENMOUNT=3Dm
CONFIG_TOUCHSCREEN_QT602240=3Dm
CONFIG_TOUCHSCREEN_TOUCHRIGHT=3Dm
CONFIG_TOUCHSCREEN_TOUCHWIN=3Dm
CONFIG_TOUCHSCREEN_WM97XX=3Dm
CONFIG_TOUCHSCREEN_WM9705=3Dy
CONFIG_TOUCHSCREEN_WM9712=3Dy
CONFIG_TOUCHSCREEN_WM9713=3Dy
CONFIG_TOUCHSCREEN_USB_COMPOSITE=3Dm
CONFIG_TOUCHSCREEN_USB_EGALAX=3Dy
CONFIG_TOUCHSCREEN_USB_PANJIT=3Dy
CONFIG_TOUCHSCREEN_USB_3M=3Dy
CONFIG_TOUCHSCREEN_USB_ITM=3Dy
CONFIG_TOUCHSCREEN_USB_ETURBO=3Dy
CONFIG_TOUCHSCREEN_USB_GUNZE=3Dy
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=3Dy
CONFIG_TOUCHSCREEN_USB_IRTOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_IDEALTEK=3Dy
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=3Dy
CONFIG_TOUCHSCREEN_USB_GOTOP=3Dy
CONFIG_TOUCHSCREEN_USB_JASTEC=3Dy
CONFIG_TOUCHSCREEN_USB_E2I=3Dy
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=3Dy
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=3Dy
CONFIG_TOUCHSCREEN_USB_NEXIO=3Dy
CONFIG_TOUCHSCREEN_TOUCHIT213=3Dm
CONFIG_TOUCHSCREEN_TSC2007=3Dm
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=3Dy
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=3Dm
CONFIG_INPUT_WINBOND_CIR=3Dm
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
CONFIG_SERIO_CT82C710=3Dm
CONFIG_SERIO_PARKBD=3Dm
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=3Dm
CONFIG_GAMEPORT=3Dm
CONFIG_GAMEPORT_NS558=3Dm
CONFIG_GAMEPORT_L4=3Dm
CONFIG_GAMEPORT_EMU10K1=3Dm
CONFIG_GAMEPORT_FM801=3Dm

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
CONFIG_NOZOMI=3Dm

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_FIX_EARLYCON_MEM=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D32
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
CONFIG_SERIAL_8250_DETECT_IRQ=3Dy
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=3Dm
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_CORE_CONSOLE=3Dy
CONFIG_SERIAL_JSM=3Dm
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=3Dm
CONFIG_LP_CONSOLE=3Dy
CONFIG_PPDEV=3Dm
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_TIMERIOMEM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dm
CONFIG_HW_RANDOM_VIA=3Dm
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=3Dm
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=3Dy
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dy
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_RAMOOPS is not set
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_COMPAT=3Dy
CONFIG_I2C_CHARDEV=3Dm
CONFIG_I2C_MUX=3Dm

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA954x=3Dm
CONFIG_I2C_HELPER_AUTO=3Dy
CONFIG_I2C_SMBUS=3Dm
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=3Dm
CONFIG_I2C_ALI1563=3Dm
CONFIG_I2C_ALI15X3=3Dm
CONFIG_I2C_AMD756=3Dm
CONFIG_I2C_AMD756_S4882=3Dm
CONFIG_I2C_AMD8111=3Dm
CONFIG_I2C_I801=3Dm
CONFIG_I2C_ISCH=3Dm
CONFIG_I2C_PIIX4=3Dm
CONFIG_I2C_NFORCE2=3Dm
CONFIG_I2C_NFORCE2_S4985=3Dm
CONFIG_I2C_SIS5595=3Dm
CONFIG_I2C_SIS630=3Dm
CONFIG_I2C_SIS96X=3Dm
CONFIG_I2C_VIA=3Dm
CONFIG_I2C_VIAPRO=3Dm

#
# ACPI drivers
#
CONFIG_I2C_SCMI=3Dm

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_OCORES=3Dm
CONFIG_I2C_PCA_PLATFORM=3Dm
CONFIG_I2C_SIMTEC=3Dm
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=3Dm
CONFIG_I2C_TAOS_EVM=3Dm
CONFIG_I2C_TINY_USB=3Dm

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=3Dm
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=3Dm
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
CONFIG_W1=3Dm
CONFIG_W1_CON=3Dy

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=3Dm
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=3Dm
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=3Dm
CONFIG_BATTERY_DS2782=3Dm
CONFIG_BATTERY_BQ27x00=3Dm
CONFIG_BATTERY_MAX17040=3Dm
CONFIG_HWMON=3Dm
CONFIG_HWMON_VID=3Dm
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=3Dm
CONFIG_SENSORS_ABITUGURU3=3Dm
CONFIG_SENSORS_AD7414=3Dm
CONFIG_SENSORS_AD7418=3Dm
CONFIG_SENSORS_ADM1021=3Dm
CONFIG_SENSORS_ADM1025=3Dm
CONFIG_SENSORS_ADM1026=3Dm
CONFIG_SENSORS_ADM1029=3Dm
CONFIG_SENSORS_ADM1031=3Dm
CONFIG_SENSORS_ADM9240=3Dm
CONFIG_SENSORS_ADT7411=3Dm
CONFIG_SENSORS_ADT7462=3Dm
CONFIG_SENSORS_ADT7470=3Dm
CONFIG_SENSORS_ADT7475=3Dm
CONFIG_SENSORS_ASC7621=3Dm
CONFIG_SENSORS_K8TEMP=3Dm
CONFIG_SENSORS_K10TEMP=3Dm
CONFIG_SENSORS_ASB100=3Dm
CONFIG_SENSORS_ATXP1=3Dm
CONFIG_SENSORS_DS1621=3Dm
CONFIG_SENSORS_I5K_AMB=3Dm
CONFIG_SENSORS_F71805F=3Dm
CONFIG_SENSORS_F71882FG=3Dm
CONFIG_SENSORS_F75375S=3Dm
CONFIG_SENSORS_FSCHMD=3Dm
CONFIG_SENSORS_G760A=3Dm
CONFIG_SENSORS_GL518SM=3Dm
CONFIG_SENSORS_GL520SM=3Dm
CONFIG_SENSORS_CORETEMP=3Dm
CONFIG_SENSORS_PKGTEMP=3Dm
CONFIG_SENSORS_IT87=3Dm
CONFIG_SENSORS_JC42=3Dm
CONFIG_SENSORS_LM63=3Dm
CONFIG_SENSORS_LM73=3Dm
CONFIG_SENSORS_LM75=3Dm
CONFIG_SENSORS_LM77=3Dm
CONFIG_SENSORS_LM78=3Dm
CONFIG_SENSORS_LM80=3Dm
CONFIG_SENSORS_LM83=3Dm
CONFIG_SENSORS_LM85=3Dm
CONFIG_SENSORS_LM87=3Dm
CONFIG_SENSORS_LM90=3Dm
CONFIG_SENSORS_LM92=3Dm
CONFIG_SENSORS_LM93=3Dm
CONFIG_SENSORS_LTC4215=3Dm
CONFIG_SENSORS_LTC4245=3Dm
CONFIG_SENSORS_LM95241=3Dm
CONFIG_SENSORS_MAX1619=3Dm
CONFIG_SENSORS_MAX6650=3Dm
CONFIG_SENSORS_PC87360=3Dm
CONFIG_SENSORS_PC87427=3Dm
CONFIG_SENSORS_PCF8591=3Dm
CONFIG_SENSORS_SIS5595=3Dm
CONFIG_SENSORS_SMM665=3Dm
CONFIG_SENSORS_DME1737=3Dm
CONFIG_SENSORS_EMC1403=3Dm
CONFIG_SENSORS_EMC2103=3Dm
CONFIG_SENSORS_SMSC47M1=3Dm
CONFIG_SENSORS_SMSC47M192=3Dm
CONFIG_SENSORS_SMSC47B397=3Dm
CONFIG_SENSORS_ADS7828=3Dm
CONFIG_SENSORS_AMC6821=3Dm
CONFIG_SENSORS_THMC50=3Dm
CONFIG_SENSORS_TMP102=3Dm
CONFIG_SENSORS_TMP401=3Dm
CONFIG_SENSORS_TMP421=3Dm
CONFIG_SENSORS_VIA_CPUTEMP=3Dm
CONFIG_SENSORS_VIA686A=3Dm
CONFIG_SENSORS_VT1211=3Dm
CONFIG_SENSORS_VT8231=3Dm
CONFIG_SENSORS_W83781D=3Dm
CONFIG_SENSORS_W83791D=3Dm
CONFIG_SENSORS_W83792D=3Dm
CONFIG_SENSORS_W83793=3Dm
CONFIG_SENSORS_W83L785TS=3Dm
CONFIG_SENSORS_W83L786NG=3Dm
CONFIG_SENSORS_W83627HF=3Dm
CONFIG_SENSORS_W83627EHF=3Dm
CONFIG_SENSORS_HDAPS=3Dm
CONFIG_SENSORS_LIS3_I2C=3Dm
CONFIG_SENSORS_APPLESMC=3Dm

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=3Dm
CONFIG_SENSORS_LIS3LV02D=3Dm
CONFIG_THERMAL=3Dy
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dm
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_BLOCKIO=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
CONFIG_SSB_B43_PCI_BRIDGE=3Dy
CONFIG_SSB_SDIOHOST_POSSIBLE=3Dy
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
# CONFIG_MFD_SUPPORT is not set
CONFIG_MFD_CORE=3Dm
CONFIG_LPC_SCH=3Dm
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=3Dy

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=3Dy
CONFIG_VIDEO_V4L2_COMMON=3Dy
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=3Dy
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=3Dy

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=3Dm
CONFIG_VIDEO_SAA7146_VV=3Dm
CONFIG_IR_CORE=3Dy
CONFIG_VIDEO_IR=3Dy
CONFIG_LIRC=3Dy
# CONFIG_RC_MAP is not set
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_IMON is not set
CONFIG_IR_MCEUSB=3Dm
# CONFIG_IR_ENE is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_MEDIA_ATTACH=3Dy
CONFIG_MEDIA_TUNER=3Dy
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=3Dy
CONFIG_MEDIA_TUNER_TDA8290=3Dy
CONFIG_MEDIA_TUNER_TDA9887=3Dy
CONFIG_MEDIA_TUNER_TEA5761=3Dy
CONFIG_MEDIA_TUNER_TEA5767=3Dy
CONFIG_MEDIA_TUNER_MT20XX=3Dy
CONFIG_MEDIA_TUNER_XC2028=3Dy
CONFIG_MEDIA_TUNER_XC5000=3Dy
CONFIG_MEDIA_TUNER_MC44S803=3Dy
CONFIG_VIDEO_V4L2=3Dy
CONFIG_VIDEOBUF_GEN=3Dm
CONFIG_VIDEOBUF_DMA_SG=3Dm
CONFIG_VIDEOBUF_VMALLOC=3Dm
CONFIG_VIDEO_BTCX=3Dm
CONFIG_VIDEO_TVEEPROM=3Dm
CONFIG_VIDEO_TUNER=3Dm
CONFIG_VIDEO_CAPTURE_DRIVERS=3Dy
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=3Dy
CONFIG_VIDEO_IR_I2C=3Dy
CONFIG_VIDEO_TVAUDIO=3Dm
CONFIG_VIDEO_TDA7432=3Dm
CONFIG_VIDEO_MSP3400=3Dm
CONFIG_VIDEO_CS53L32A=3Dm
CONFIG_VIDEO_M52790=3Dm
CONFIG_VIDEO_WM8775=3Dm
CONFIG_VIDEO_WM8739=3Dm
CONFIG_VIDEO_VP27SMPX=3Dm
CONFIG_VIDEO_SAA6588=3Dm
CONFIG_VIDEO_BT819=3Dm
CONFIG_VIDEO_BT856=3Dm
CONFIG_VIDEO_BT866=3Dm
CONFIG_VIDEO_KS0127=3Dm
CONFIG_VIDEO_OV7670=3Dm
CONFIG_VIDEO_MT9V011=3Dm
CONFIG_VIDEO_SAA7110=3Dm
CONFIG_VIDEO_SAA711X=3Dm
CONFIG_VIDEO_SAA717X=3Dm
CONFIG_VIDEO_TVP5150=3Dm
CONFIG_VIDEO_VPX3220=3Dm
CONFIG_VIDEO_CX25840=3Dm
CONFIG_VIDEO_CX2341X=3Dm
CONFIG_VIDEO_SAA7127=3Dm
CONFIG_VIDEO_SAA7185=3Dm
CONFIG_VIDEO_ADV7170=3Dm
CONFIG_VIDEO_ADV7175=3Dm
CONFIG_VIDEO_UPD64031A=3Dm
CONFIG_VIDEO_UPD64083=3Dm
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=3Dm
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_W9966 is not set
CONFIG_VIDEO_SAA5246A=3Dm
CONFIG_VIDEO_SAA5249=3Dm
CONFIG_VIDEO_ZORAN=3Dm
CONFIG_VIDEO_ZORAN_DC30=3Dm
CONFIG_VIDEO_ZORAN_ZR36060=3Dm
CONFIG_VIDEO_ZORAN_BUZ=3Dm
CONFIG_VIDEO_ZORAN_DC10=3Dm
CONFIG_VIDEO_ZORAN_LML33=3Dm
CONFIG_VIDEO_ZORAN_LML33R10=3Dm
CONFIG_VIDEO_ZORAN_AVS6EYES=3Dm
CONFIG_VIDEO_SAA7134=3Dm
CONFIG_VIDEO_SAA7134_ALSA=3Dm
# CONFIG_VIDEO_MXB is not set
CONFIG_VIDEO_HEXIUM_ORION=3Dm
CONFIG_VIDEO_HEXIUM_GEMINI=3Dm
CONFIG_VIDEO_CX88=3Dm
CONFIG_VIDEO_CX88_ALSA=3Dm
CONFIG_VIDEO_CX88_BLACKBIRD=3Dm
CONFIG_VIDEO_CX88_MPEG=3Dm
CONFIG_VIDEO_IVTV=3Dm
CONFIG_VIDEO_FB_IVTV=3Dm
CONFIG_VIDEO_CAFE_CCIC=3Dm
CONFIG_SOC_CAMERA=3Dm
CONFIG_SOC_CAMERA_MT9M001=3Dm
CONFIG_SOC_CAMERA_MT9M111=3Dm
CONFIG_SOC_CAMERA_MT9T031=3Dm
CONFIG_SOC_CAMERA_MT9T112=3Dm
CONFIG_SOC_CAMERA_MT9V022=3Dm
CONFIG_SOC_CAMERA_RJ54N1=3Dm
CONFIG_SOC_CAMERA_TW9910=3Dm
CONFIG_SOC_CAMERA_PLATFORM=3Dm
CONFIG_SOC_CAMERA_OV772X=3Dm
CONFIG_SOC_CAMERA_OV9640=3Dm
CONFIG_V4L_USB_DRIVERS=3Dy
CONFIG_USB_VIDEO_CLASS=3Dm
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=3Dy
CONFIG_USB_GSPCA=3Dm
CONFIG_USB_M5602=3Dm
CONFIG_USB_STV06XX=3Dm
CONFIG_USB_GL860=3Dm
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=3Dm
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=3Dm
CONFIG_USB_GSPCA_FINEPIX=3Dm
CONFIG_USB_GSPCA_JEILINJ=3Dm
CONFIG_USB_GSPCA_MARS=3Dm
CONFIG_USB_GSPCA_MR97310A=3Dm
CONFIG_USB_GSPCA_OV519=3Dm
CONFIG_USB_GSPCA_OV534=3Dm
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=3Dm
CONFIG_USB_GSPCA_PAC7302=3Dm
CONFIG_USB_GSPCA_PAC7311=3Dm
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=3Dm
CONFIG_USB_GSPCA_SONIXB=3Dm
CONFIG_USB_GSPCA_SONIXJ=3Dm
CONFIG_USB_GSPCA_SPCA500=3Dm
CONFIG_USB_GSPCA_SPCA501=3Dm
CONFIG_USB_GSPCA_SPCA505=3Dm
CONFIG_USB_GSPCA_SPCA506=3Dm
CONFIG_USB_GSPCA_SPCA508=3Dm
CONFIG_USB_GSPCA_SPCA561=3Dm
CONFIG_USB_GSPCA_SPCA1528=3Dm
CONFIG_USB_GSPCA_SQ905=3Dm
CONFIG_USB_GSPCA_SQ905C=3Dm
CONFIG_USB_GSPCA_SQ930X=3Dm
CONFIG_USB_GSPCA_STK014=3Dm
CONFIG_USB_GSPCA_STV0680=3Dm
CONFIG_USB_GSPCA_SUNPLUS=3Dm
CONFIG_USB_GSPCA_T613=3Dm
CONFIG_USB_GSPCA_TV8532=3Dm
CONFIG_USB_GSPCA_VC032X=3Dm
CONFIG_USB_GSPCA_ZC3XX=3Dm
CONFIG_VIDEO_PVRUSB2=3Dm
CONFIG_VIDEO_PVRUSB2_SYSFS=3Dy
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=3Dm
CONFIG_VIDEO_EM28XX=3Dm
CONFIG_VIDEO_EM28XX_ALSA=3Dm
CONFIG_VIDEO_CX231XX=3Dm
CONFIG_VIDEO_CX231XX_ALSA=3Dm
CONFIG_VIDEO_USBVISION=3Dm
CONFIG_USB_ET61X251=3Dm
CONFIG_USB_SN9C102=3Dm
CONFIG_USB_ZR364XX=3Dm
CONFIG_USB_STKWEBCAM=3Dm
CONFIG_USB_S2255=3Dm
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
CONFIG_AGP_INTEL=3Dy
CONFIG_AGP_SIS=3Dy
CONFIG_AGP_VIA=3Dy
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=3Dy
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=3Dy
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dm
CONFIG_BACKLIGHT_GENERIC=3Dm
CONFIG_BACKLIGHT_PROGEAR=3Dm
CONFIG_BACKLIGHT_MBP_NVIDIA=3Dm
CONFIG_BACKLIGHT_SAHARA=3Dm
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=3Dy

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK=3Dy
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=3D256
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
CONFIG_FONT_6x11=3Dy
CONFIG_FONT_7x14=3Dy
CONFIG_FONT_PEARL_8x8=3Dy
CONFIG_FONT_ACORN_8x8=3Dy
CONFIG_FONT_MINI_4x6=3Dy
CONFIG_FONT_SUN8x16=3Dy
CONFIG_FONT_SUN12x22=3Dy
CONFIG_FONT_10x18=3Dy
CONFIG_LOGO=3Dy
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=3Dy
CONFIG_SOUND=3Dy
CONFIG_SOUND_OSS_CORE=3Dy
CONFIG_SOUND_OSS_CORE_PRECLAIM=3Dy
CONFIG_SND=3Dy
CONFIG_SND_TIMER=3Dy
CONFIG_SND_PCM=3Dy
CONFIG_SND_HWDEP=3Dy
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_JACK=3Dy
CONFIG_SND_SEQUENCER=3Dy
CONFIG_SND_SEQ_DUMMY=3Dy
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dy
CONFIG_SND_PCM_OSS=3Dy
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=3Dy
CONFIG_SND_SUPPORT_OLD_API=3Dy
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
CONFIG_SND_RAWMIDI_SEQ=3Dm
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DRIVERS=3Dy
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_MTS64=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm
CONFIG_SND_PORTMAN2X4=3Dm
CONFIG_SND_AC97_POWER_SAVE=3Dy
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=3D30
CONFIG_SND_PCI=3Dy
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CS5535AUDIO=3Dm
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=3Dy
CONFIG_SND_HDA_HWDEP=3Dy
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_INPUT_JACK=3Dy
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
CONFIG_SND_HDA_CODEC_ATIHDMI=3Dy
CONFIG_SND_HDA_CODEC_NVHDMI=3Dy
CONFIG_SND_HDA_CODEC_INTELHDMI=3Dy
CONFIG_SND_HDA_ELD=3Dy
CONFIG_SND_HDA_CODEC_CIRRUS=3Dy
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
CONFIG_SND_HDA_CODEC_CA0110=3Dy
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
CONFIG_SND_HDA_POWER_SAVE=3Dy
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D30
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
CONFIG_HIDRAW=3Dy

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
CONFIG_HID_PID=3Dy
CONFIG_USB_HIDDEV=3Dy

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=3Dy
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_DRAGONRISE=3Dy
CONFIG_DRAGONRISE_FF=3Dy
# CONFIG_HID_EGALAX is not set
CONFIG_HID_ELECOM=3Dm
CONFIG_HID_EZKEY=3Dy
CONFIG_HID_KYE=3Dy
CONFIG_HID_GYRATION=3Dy
CONFIG_HID_TWINHAN=3Dy
CONFIG_HID_KENSINGTON=3Dy
CONFIG_HID_LOGITECH=3Dy
CONFIG_LOGITECH_FF=3Dy
CONFIG_LOGIRUMBLEPAD2_FF=3Dy
# CONFIG_LOGIG940_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=3Dy
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=3Dy
CONFIG_HID_NTRIG=3Dy
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=3Dy
CONFIG_PANTHERLORD_FF=3Dy
CONFIG_HID_PETALYNX=3Dy
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
CONFIG_HID_SAMSUNG=3Dy
CONFIG_HID_SONY=3Dy
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=3Dy
CONFIG_HID_GREENASIA=3Dy
CONFIG_GREENASIA_FF=3Dy
CONFIG_HID_SMARTJOYPLUS=3Dy
CONFIG_SMARTJOYPLUS_FF=3Dy
CONFIG_HID_TOPSEED=3Dy
CONFIG_HID_THRUSTMASTER=3Dy
CONFIG_THRUSTMASTER_FF=3Dy
CONFIG_HID_WACOM=3Dm
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
CONFIG_HID_ZEROPLUS=3Dy
CONFIG_ZEROPLUS_FF=3Dy
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
CONFIG_USB_DEBUG=3Dy
CONFIG_USB_ANNOUNCE_NEW_DEVICES=3Dy

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_DEVICE_CLASS=3Dy
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=3Dy
CONFIG_USB_WUSB=3Dy
CONFIG_USB_WUSB_CBAF=3Dy
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=3Dm
CONFIG_USB_XHCI_HCD=3Dm
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=3Dm
CONFIG_USB_EHCI_ROOT_HUB_TT=3Dy
CONFIG_USB_EHCI_TT_NEWSCHED=3Dy
CONFIG_USB_OXU210HP_HCD=3Dm
CONFIG_USB_ISP116X_HCD=3Dm
CONFIG_USB_ISP1760_HCD=3Dm
CONFIG_USB_ISP1362_HCD=3Dm
CONFIG_USB_OHCI_HCD=3Dm
CONFIG_USB_OHCI_HCD_SSB=3Dy
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dy
CONFIG_USB_U132_HCD=3Dm
CONFIG_USB_SL811_HCD=3Dm
CONFIG_USB_R8A66597_HCD=3Dm
CONFIG_USB_WHCI_HCD=3Dm
CONFIG_USB_HWA_HCD=3Dm

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=3Dm
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dm
CONFIG_USB_STORAGE_FREECOM=3Dm
CONFIG_USB_STORAGE_ISD200=3Dm
CONFIG_USB_STORAGE_USBAT=3Dm
CONFIG_USB_STORAGE_SDDR09=3Dm
CONFIG_USB_STORAGE_SDDR55=3Dm
CONFIG_USB_STORAGE_JUMPSHOT=3Dm
CONFIG_USB_STORAGE_ALAUDA=3Dm
CONFIG_USB_STORAGE_ONETOUCH=3Dm
CONFIG_USB_STORAGE_KARMA=3Dm
CONFIG_USB_STORAGE_CYPRESS_ATACB=3Dm
CONFIG_USB_LIBUSUAL=3Dy

#
# USB Imaging devices
#
CONFIG_USB_MDC800=3Dm
CONFIG_USB_MICROTEK=3Dm

#
# USB port drivers
#
CONFIG_USB_USS720=3Dm
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_EZUSB=3Dy
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=3Dm
CONFIG_USB_SERIAL_ARK3116=3Dm
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_CH341=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP210X=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
CONFIG_USB_SERIAL_FUNSOFT=3Dm
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_IUU=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
CONFIG_USB_SERIAL_KEYSPAN_MPR=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28X=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA18X=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19W=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA49W=3Dy
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=3Dy
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
CONFIG_USB_SERIAL_MOS7720=3Dm
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=3Dm
CONFIG_USB_SERIAL_MOTOROLA=3Dm
CONFIG_USB_SERIAL_NAVMAN=3Dm
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_OTI6858=3Dm
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=3Dm
CONFIG_USB_SERIAL_SPCP8X5=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
CONFIG_USB_SERIAL_SAFE_PADDED=3Dy
CONFIG_USB_SERIAL_SIEMENS_MPI=3Dm
CONFIG_USB_SERIAL_SIERRAWIRELESS=3Dm
CONFIG_USB_SERIAL_SYMBOL=3Dm
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
CONFIG_USB_SERIAL_WWAN=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
CONFIG_USB_SERIAL_OMNINET=3Dm
CONFIG_USB_SERIAL_OPTICON=3Dm
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_SSU100=3Dm
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=3Dm
CONFIG_USB_EMI26=3Dm
CONFIG_USB_ADUTUX=3Dm
CONFIG_USB_SEVSEG=3Dm
CONFIG_USB_RIO500=3Dm
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=3Dm
CONFIG_USB_LED=3Dm
CONFIG_USB_CYPRESS_CY7C63=3Dm
CONFIG_USB_CYTHERM=3Dm
CONFIG_USB_IDMOUSE=3Dm
CONFIG_USB_FTDI_ELAN=3Dm
CONFIG_USB_APPLEDISPLAY=3Dm
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=3Dm
CONFIG_USB_ATM=3Dm
CONFIG_USB_SPEEDTOUCH=3Dm
CONFIG_USB_CXACRU=3Dm
CONFIG_USB_UEAGLEATM=3Dm
CONFIG_USB_XUSBATM=3Dm
CONFIG_USB_GADGET=3Dy
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=3D2
CONFIG_USB_GADGET_SELECTED=3Dy
# CONFIG_USB_GADGET_R8A66597 is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
CONFIG_USB_GADGET_LANGWELL=3Dy
CONFIG_USB_LANGWELL=3Dy
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=3Dy
CONFIG_USB_ZERO=3Dm
CONFIG_USB_AUDIO=3Dm
CONFIG_USB_ETH=3Dm
CONFIG_USB_ETH_RNDIS=3Dy
# CONFIG_USB_ETH_EEM is not set
CONFIG_USB_GADGETFS=3Dm
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_FILE_STORAGE=3Dm
# CONFIG_USB_FILE_STORAGE_TEST is not set
CONFIG_USB_MASS_STORAGE=3Dm
CONFIG_USB_G_SERIAL=3Dm
CONFIG_USB_MIDI_GADGET=3Dm
CONFIG_USB_G_PRINTER=3Dm
CONFIG_USB_CDC_COMPOSITE=3Dm
# CONFIG_USB_G_NOKIA is not set
CONFIG_USB_G_MULTI=3Dm
CONFIG_USB_G_MULTI_RNDIS=3Dy
CONFIG_USB_G_MULTI_CDC=3Dy
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=3Dy
CONFIG_NOP_USB_XCEIV=3Dm
CONFIG_UWB=3Dy
CONFIG_UWB_HWA=3Dm
CONFIG_UWB_WHCI=3Dm
CONFIG_UWB_WLP=3Dm
CONFIG_UWB_I1480U=3Dm
CONFIG_UWB_I1480U_WLP=3Dm
CONFIG_MMC=3Dm
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=3Dm
CONFIG_MMC_BLOCK_BOUNCE=3Dy
CONFIG_SDIO_UART=3Dm
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=3Dm
CONFIG_MMC_SDHCI_PCI=3Dm
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_PLTFM=3Dm
CONFIG_MMC_WBSD=3Dm
CONFIG_MMC_TIFM_SD=3Dm
CONFIG_MMC_CB710=3Dm
CONFIG_MMC_VIA_SDMMC=3Dm
CONFIG_MEMSTICK=3Dm
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=3Dm

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=3Dm
CONFIG_MEMSTICK_JMICRON_38X=3Dm
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dm

#
# LED drivers
#
CONFIG_LEDS_ALIX2=3Dm
CONFIG_LEDS_PCA9532=3Dm
CONFIG_LEDS_LP3944=3Dm
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=3Dm
CONFIG_LEDS_BD2802=3Dm
CONFIG_LEDS_INTEL_SS4200=3Dm
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_TRIGGERS=3Dy

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=3Dm
CONFIG_LEDS_TRIGGER_HEARTBEAT=3Dm
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=3Dm

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=3Dy

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=3Dy
CONFIG_EDAC_MM_EDAC=3Dy
CONFIG_EDAC_MCE=3Dy
CONFIG_EDAC_AMD64=3Dm
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=3Dm
CONFIG_EDAC_I82975X=3Dm
CONFIG_EDAC_I3000=3Dm
CONFIG_EDAC_I3200=3Dm
CONFIG_EDAC_X38=3Dm
CONFIG_EDAC_I5400=3Dm
CONFIG_EDAC_I7CORE=3Dm
CONFIG_EDAC_I5000=3Dm
CONFIG_EDAC_I5100=3Dm
CONFIG_RTC_LIB=3Dy
CONFIG_RTC_CLASS=3Dy
CONFIG_RTC_HCTOSYS=3Dy
CONFIG_RTC_HCTOSYS_DEVICE=3D"rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=3Dy
CONFIG_RTC_INTF_PROC=3Dy
CONFIG_RTC_INTF_DEV=3Dy
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=3Dm
CONFIG_RTC_DRV_DS1374=3Dm
CONFIG_RTC_DRV_DS1672=3Dm
CONFIG_RTC_DRV_DS3232=3Dm
CONFIG_RTC_DRV_MAX6900=3Dm
CONFIG_RTC_DRV_RS5C372=3Dm
CONFIG_RTC_DRV_ISL1208=3Dm
CONFIG_RTC_DRV_ISL12022=3Dm
CONFIG_RTC_DRV_X1205=3Dm
CONFIG_RTC_DRV_PCF8563=3Dm
CONFIG_RTC_DRV_PCF8583=3Dm
CONFIG_RTC_DRV_M41T80=3Dm
CONFIG_RTC_DRV_M41T80_WDT=3Dy
CONFIG_RTC_DRV_BQ32K=3Dm
CONFIG_RTC_DRV_S35390A=3Dm
CONFIG_RTC_DRV_FM3130=3Dm
CONFIG_RTC_DRV_RX8581=3Dm
CONFIG_RTC_DRV_RX8025=3Dm

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=3Dy
CONFIG_RTC_DRV_DS1286=3Dm
CONFIG_RTC_DRV_DS1511=3Dm
CONFIG_RTC_DRV_DS1553=3Dm
CONFIG_RTC_DRV_DS1742=3Dm
CONFIG_RTC_DRV_STK17TA8=3Dm
CONFIG_RTC_DRV_M48T86=3Dm
CONFIG_RTC_DRV_M48T35=3Dm
CONFIG_RTC_DRV_M48T59=3Dm
CONFIG_RTC_DRV_MSM6242=3Dm
CONFIG_RTC_DRV_BQ4802=3Dm
CONFIG_RTC_DRV_RP5C01=3Dm
CONFIG_RTC_DRV_V3020=3Dm

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=3Dm
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=3Dy
CONFIG_INTEL_IOATDMA=3Dy
CONFIG_TIMB_DMA=3Dm
CONFIG_PCH_DMA=3Dm
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=3Dy
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=3Dm
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=3Dm
CONFIG_UIO_PDRV_GENIRQ=3Dm
CONFIG_UIO_AEC=3Dm
CONFIG_UIO_SERCOS3=3Dm
CONFIG_UIO_PCI_GENERIC=3Dm
# CONFIG_UIO_NETX is not set
CONFIG_STAGING=3Dy
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_TM6000 is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_OTUS is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192SU is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_IIO is not set
CONFIG_ZRAM=3Dm
CONFIG_ZRAM_STATS=3Dy
# CONFIG_BATMAN_ADV is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_ST_BT is not set
# CONFIG_FB_XGI is not set
# CONFIG_LIRC_STAGING is not set
# CONFIG_EASYCAP is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_WMI=3Dm
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_ACPI is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_INTEL_MENLOW=3Dm
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=3Dm
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=3Dm
CONFIG_ACPI_CMPC=3Dm
CONFIG_INTEL_IPS=3Dm

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=3Dy
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dy
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
CONFIG_EXT3_DEFAULTS_TO_ORDERED=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=3Dy
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=3Dy
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
CONFIG_JFS_FS=3Dy
CONFIG_JFS_POSIX_ACL=3Dy
CONFIG_JFS_SECURITY=3Dy
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=3Dy
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_XFS_FS=3Dy
CONFIG_XFS_QUOTA=3Dy
CONFIG_XFS_POSIX_ACL=3Dy
CONFIG_XFS_RT=3Dy
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=3Dy
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_NILFS2_FS=3Dm
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=3Dy
CONFIG_QUOTA_NETLINK_INTERFACE=3Dy
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=3Dy
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=3Dy
CONFIG_QUOTACTL=3Dy
CONFIG_QUOTACTL_COMPAT=3Dy
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=3Dy
CONFIG_CUSE=3Dy
CONFIG_GENERIC_ACL=3Dy

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dy
CONFIG_MSDOS_FS=3Dy
CONFIG_VFAT_FS=3Dy
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-15"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_CONFIGFS_FS=3Dy
CONFIG_MISC_FILESYSTEMS=3Dy
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=3Dm
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=3Dm
CONFIG_HFSPLUS_FS=3Dm
CONFIG_BEFS_FS=3Dm
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=3Dm
CONFIG_EFS_FS=3Dm
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=3Dm
CONFIG_SQUASHFS=3Dy
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
CONFIG_VXFS_FS=3Dm
CONFIG_MINIX_FS=3Dm
CONFIG_OMFS_FS=3Dm
CONFIG_HPFS_FS=3Dm
CONFIG_QNX4FS_FS=3Dm
CONFIG_ROMFS_FS=3Dm
CONFIG_ROMFS_BACKED_BY_BLOCK=3Dy
CONFIG_ROMFS_ON_BLOCK=3Dy
CONFIG_SYSV_FS=3Dm
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=3Dy
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
# CONFIG_NFSD is not set
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dy
CONFIG_RPCSEC_GSS_KRB5=3Dy
CONFIG_RPCSEC_GSS_SPKM3=3Dm
# CONFIG_SMB_FS is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
CONFIG_CIFS_STATS2=3Dy
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_EXPERIMENTAL=3Dy
CONFIG_NCP_FS=3Dm
CONFIG_NCPFS_PACKET_SIGNING=3Dy
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=3Dy
CONFIG_NCPFS_NFS_NS=3Dy
CONFIG_NCPFS_OS2_NS=3Dy
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=3Dy
CONFIG_NCPFS_EXTRAS=3Dy
CONFIG_CODA_FS=3Dm
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
CONFIG_ACORN_PARTITION=3Dy
CONFIG_ACORN_PARTITION_CUMANA=3Dy
CONFIG_ACORN_PARTITION_EESOX=3Dy
CONFIG_ACORN_PARTITION_ICS=3Dy
CONFIG_ACORN_PARTITION_ADFS=3Dy
CONFIG_ACORN_PARTITION_POWERTEC=3Dy
CONFIG_ACORN_PARTITION_RISCIX=3Dy
CONFIG_OSF_PARTITION=3Dy
CONFIG_AMIGA_PARTITION=3Dy
CONFIG_ATARI_PARTITION=3Dy
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
CONFIG_MINIX_SUBPARTITION=3Dy
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=3Dy
CONFIG_ULTRIX_PARTITION=3Dy
CONFIG_SUN_PARTITION=3Dy
CONFIG_KARMA_PARTITION=3Dy
CONFIG_EFI_PARTITION=3Dy
CONFIG_SYSV68_PARTITION=3Dy
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dy
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dy
CONFIG_NLS_CODEPAGE_950=3Dy
CONFIG_NLS_CODEPAGE_932=3Dy
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dy
CONFIG_NLS_ISO8859_1=3Dy
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dy
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dy
CONFIG_DLM=3Dm
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_FRAME_WARN=3D2048
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_STRIP_ASM_SYMS=3Dy
CONFIG_UNUSED_SYMBOLS=3Dy
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_DEBUG_SHIRQ=3Dy
CONFIG_LOCKUP_DETECTOR=3Dy
CONFIG_HARDLOCKUP_DETECTOR=3Dy
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=3D0
CONFIG_DETECT_HUNG_TASK=3Dy
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHEDSTATS=3Dy
CONFIG_TIMER_STATS=3Dy
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_PI_LIST=3Dy
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=3Dy
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_TRACING_SUPPORT=3Dy
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_KMEMCHECK is not set
CONFIG_STRICT_DEVMEM=3Dy
CONFIG_X86_VERBOSE_BOOTUP=3Dy
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=3Dy
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_XOR_BLOCKS=3Dy
CONFIG_ASYNC_CORE=3Dy
CONFIG_ASYNC_MEMCPY=3Dy
CONFIG_ASYNC_XOR=3Dy
CONFIG_ASYNC_PQ=3Dy
CONFIG_ASYNC_RAID6_RECOV=3Dy
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=3Dy
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dy
CONFIG_CRYPTO_PCOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=3Dy
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_PCRYPT=3Dy
CONFIG_CRYPTO_WORKQUEUE=3Dy
CONFIG_CRYPTO_CRYPTD=3Dy
CONFIG_CRYPTO_AUTHENC=3Dy
CONFIG_CRYPTO_TEST=3Dm

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=3Dy
CONFIG_CRYPTO_GCM=3Dy
CONFIG_CRYPTO_SEQIV=3Dy

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_CTR=3Dy
CONFIG_CRYPTO_CTS=3Dy
CONFIG_CRYPTO_ECB=3Dy
CONFIG_CRYPTO_LRW=3Dy
CONFIG_CRYPTO_PCBC=3Dy
CONFIG_CRYPTO_XTS=3Dy
CONFIG_CRYPTO_FPU=3Dy

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
CONFIG_CRYPTO_XCBC=3Dy
CONFIG_CRYPTO_VMAC=3Dy

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CRC32C_INTEL=3Dy
CONFIG_CRYPTO_GHASH=3Dy
CONFIG_CRYPTO_MD4=3Dy
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
CONFIG_CRYPTO_RMD128=3Dy
CONFIG_CRYPTO_RMD160=3Dy
CONFIG_CRYPTO_RMD256=3Dy
CONFIG_CRYPTO_RMD320=3Dy
CONFIG_CRYPTO_SHA1=3Dy
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
CONFIG_CRYPTO_TGR192=3Dy
CONFIG_CRYPTO_WP512=3Dy
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=3Dy

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dy
CONFIG_CRYPTO_AES_X86_64=3Dy
CONFIG_CRYPTO_AES_NI_INTEL=3Dy
CONFIG_CRYPTO_ANUBIS=3Dy
CONFIG_CRYPTO_ARC4=3Dy
CONFIG_CRYPTO_BLOWFISH=3Dy
CONFIG_CRYPTO_CAMELLIA=3Dy
CONFIG_CRYPTO_CAST5=3Dy
CONFIG_CRYPTO_CAST6=3Dy
CONFIG_CRYPTO_DES=3Dy
CONFIG_CRYPTO_FCRYPT=3Dy
CONFIG_CRYPTO_KHAZAD=3Dy
CONFIG_CRYPTO_SALSA20=3Dy
CONFIG_CRYPTO_SALSA20_X86_64=3Dy
CONFIG_CRYPTO_SEED=3Dy
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_TEA=3Dy
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
CONFIG_CRYPTO_TWOFISH_X86_64=3Dy

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dy
CONFIG_CRYPTO_ZLIB=3Dy
CONFIG_CRYPTO_LZO=3Dy

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dm
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_PADLOCK=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_AES=3Dm
CONFIG_CRYPTO_DEV_PADLOCK_SHA=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X=3Dm
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=3Dy
CONFIG_HAVE_KVM=3Dy
CONFIG_VIRTUALIZATION=3Dy
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=3Dy
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_FIND_NEXT_BIT=3Dy
CONFIG_GENERIC_FIND_LAST_BIT=3Dy
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dy
CONFIG_LIBCRC32C=3Dy
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_DECOMPRESS_LZO=3Dy
CONFIG_TEXTSEARCH=3Dy
CONFIG_TEXTSEARCH_KMP=3Dm
CONFIG_TEXTSEARCH_BM=3Dm
CONFIG_TEXTSEARCH_FSM=3Dm
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_NLATTR=3Dy
