From: Andreas Mohr <andi@lisas.de>
Subject: Noticeable usability weakness of ext4 recovery, especially during
 boot
Date: Sun, 20 Mar 2016 18:10:53 +0100
Message-ID: <20160320171053.GA24115@rhlx01.hs-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello all,

I tried using a semi-recent (3.16.0-38-generic) live ISO session of MINT today,
but I noticed that my system completely hung at boot
(having booted via a hot reset of the machine).
Thus after a while, I decided to cold boot it instead (thinking
"WTF, hardware state must have been influenced by cosmic radiation").
Less surprisingly, it managed to hang again.
Thus I decided to keep waiting some more.
And finally (after several minutes) it reacted with message
EXT4-fs (sda2): recovery complete

dmesg timed trace:
[   14.192858] [drm] Cannot find any crtc or sizes - going 1024x768
[   14.219096] nouveau  [     DRM] allocated 1024x768 fb: 0x70000, bo f6af2800
[   14.222758] nouveau 0000:04:00.0: fb1: nouveaufb frame buffer device
[   14.226297] [drm] Initialized nouveau 1.1.2 20120801 for 0000:04:00.0 on mino
r 1
[   15.367568] sd 4:0:0:0: [sda] Attached SCSI removable disk
[   16.967523] SGI XFS with ACLs, security attributes, realtime, large block/ino
de numbers, no debug enabled
[   17.005616] JFS: nTxBlock = 8192, nTxLock = 65536
[   18.127082] FAT-fs (sda1): Volume was not properly unmounted. Some data may b
e corrupt. Please run fsck.
[   18.164828] EXT4-fs (sda2): mounting ext3 file system using the ext4 subsyste
m
[   18.651731] random: nonblocking pool is initialized
[   19.788049] ACPI Warning: \_SB_.PCI0.P0P4.GFX0._DSM: Argument #4 type mismatc
h - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[   19.790853] ACPI Warning: \_SB_.PCI0.P0P4.GFX0._DSM: Argument #4 type mismatc
h - Found [Buffer], ACPI requires [Package] (20140424/nsarguments-95)
[  248.211176] EXT4-fs (sda2): recovery complete
[  249.595977] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: 
(null)

(note the HUGE gap in dmesg timestamps above)


All that *may* have been acceptable, if it were not for the fact
that especially during boot
certain activity progress is not readily visible,
thus there's a *lot* of confusion of what is [not] happening with the system
(as strongly opposed to a situation where one is mounting an ext4 partition
directly via the shell, where it's quite obvious that mount is hanging
right at the shell prompt,
and diagnostic verification via dmesg etc. is readily reachable,
as opposed to system boot).


This issue likely is reproducible via the same live boot,
in combination with an ext4 partition (e.g. sitting on same boot block device)
which has been set up to need recovery.

Details (grub.conf setup etc.):

menuentry "Linux Mint 17.2 KDE 32-bit" {
  set isofile="/boot/mint/linuxmint-17.2-kde-32bit.iso"
  export isofile
  set boottool="casper"
  export boottool
  set liveinitrd="/$boottool/initrd.lz"
  export liveinitrd
  loopback loop $isofile
  set gfxpayload=keep
  #linux (loop)/$boottool/vmlinuz file=/cdrom/preseed/linuxmint.seed boot=$boott
ool iso-scan/filename=${iso_path} config initrd=$liveinitrd live-media-path=/$bo
ottool debug nosplash fromiso=/dev/disk/by-label/amohr_iso2/$isofile --
  linux (loop)/$boottool/vmlinuz file=/cdrom/preseed/linuxmint.seed boot=$bootto
ol iso-scan/filename=$isofile config initrd=$liveinitrd live-media-path=/$bootto
ol debug nosplash fromiso=/dev/disk/by-label/amohr_iso2/$isofile --
  initrd (loop)$liveinitrd
  #linux (loop)/casper/vmlinuz boot=casper quiet splash noeject noprompt fromiso
=/dev/disk/by-label/amohr_iso2/$isofile boot=live config live-media-path=/casper
 --
  #initrd (loop)/casper/initrd.lz
  #linux (loop)/live/vmlinuz boot=live config initrd=/live/initrd.img live-media-path=/live debug nosplash fromiso=/dev/disk/by-label/amohr_iso2/$isofile --
  #initrd (loop)/live/initrd.img
}


So, all in all it's just a pretty surprising situation
to have to wait for several minutes during boot
(with some other potentially confusing kernel messages
generated in the meantime),
and then finally surprisingly being greeted with a "recovery complete" message
despite never actually having been informed that ext4 mounting
*IS* in fact entering recovery
(or any other potentially longer-term activity during mounting)!!


So, plain cold usability-focussed judgment:
- mounting may hang for longer times, even during (potentially non-observable,
  especially in GUI-only boot environment) boot,
  without much indication of *both* state *and* progress
- progress may easily not be determinable via "out of band signalling" ;)
  (completely silent USB stick rather than plain old metal platters HDD!!)
- ext4 mount log as of 3.16.0
  does *not* have properly implemented "state progress"
  when it comes to properly informing the user of what is happening
  (namely, *enter*ing a longer-lasting recovery mode,
  rather than merely having *finished* it)

Thus, the question here would be
which parts may need to be sufficiently improved
to achieve an acceptable level of usability.
I'd think that even simply adding a message
that one is about to enter a potentially longer-term operation
(with a details message such as "recovery")
rather than "standard" mount activity
would be sufficient,
both for text boot *and* GUI boot with some sufficiently accessible
"boot details" window.

Thanks,

Andreas Mohr
