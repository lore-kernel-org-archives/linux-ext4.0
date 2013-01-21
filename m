From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Tue, 22 Jan 2013 00:04:32 +0100
Message-ID: <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
	<CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
	<20130121104733.GE5588@quack.suse.cz>
	<CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
	<CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
	<20130121140738.GI5588@quack.suse.cz>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:53427 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3AUXEd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 18:04:33 -0500
In-Reply-To: <20130121140738.GI5588@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2013 at 3:07 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 21-01-13 13:30:26, Sedat Dilek wrote:
>> On Mon, Jan 21, 2013 at 12:40 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Mon, Jan 21, 2013 at 11:47 AM, Jan Kara <jack@suse.cz> wrote:
>> >>   The traces don't suggest an ext4/jbd2 problem. What is happening is that
>> >> jbd2 is waiting for IO to finish and that never happens. Seeing that you
>> >> loop device I'd think it's some interaction of the loop device and
>> >> freezing. Can you reproduce the issue without the loop device (i.e. with
>> >> the filesystem directly on e.g. scsi disk)? I suspect the reason is
>> >> something like that the backing filesystem is already frozen so filesystem
>> >> on top of it cannot write all the data and hangs waiting for IO -> suspend
>> >> doesn't happen. Contents of /proc/mounts and losetup -l would help us
>> >> understand what's going on.
>> >>
>> >
>> > As said I am here in a very uncommon WUBI environment means my
>> > Ubuntu/precise rootfs-image lays on the Win7-partition (NTFS).
>> > Your explanation sounds reasonable to me as this line from my attached
>> > testcase causes the troubles.
>> >
>> >      echo mem > /sys/power/state && sleep 1
>> >
>> > So, /sys/ is not writable immediately after freezer ends
>> >
>> > I checked again and again my logs and have seen "starving" lines
>> > reported by rtkit-daemon, but did not really get wiser what they want
>> > to tell me. Stopping rtkit-daemon or resetting all or all-known
>> > threads before running my pm_test/freezer did not help, too.
>> >
>> > /usr/sbin/rtkitctl --help
>> > rtkitctl [options]
>> >
>> >   -h, --help         Show this help
>> >       --version      Show version
>> >
>> >       --reset-known  Reset real-time status of known threads
>> >       --reset-all    Reset real-time status of all threads
>> >       --start        Start RealtimeKit if it is not running already
>> >   -k, --exit         Terminate running RealtimeKit daemon
>> >
>> > Here are the outputs you wanted with some more (fstab, grub-config) etc.
>> > I have here no -l option for losetup command.
>> >
>> >
>> > - Sedat -
>> >
>> > P.S.: Outputs for Honza...
>> >
>> > $ sudo cat /proc/mounts
>> > rootfs / rootfs rw 0 0
>> > sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
>> > proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
>> > udev /dev devtmpfs rw,relatime,size=1966948k,nr_inodes=491737,mode=755 0 0
>> > devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
>> > tmpfs /run tmpfs rw,nosuid,relatime,size=788076k,mode=755 0 0
>> > /dev/sda2 /host fuseblk
>> > rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096
>> > 0 0
>> > /dev/loop0 / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
>> > none /sys/fs/fuse/connections fusectl rw,relatime 0 0
>> > none /sys/kernel/debug debugfs rw,relatime 0 0
>> > none /sys/kernel/security securityfs rw,relatime 0 0
>> > none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
>> > none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
>> > gvfs-fuse-daemon /home/wearefam/.gvfs fuse.gvfs-fuse-daemon
>> > rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
>> >
>> > $ sudo losetup --all --verbose
>> > /dev/loop0: [0802]:17982 (/host/ubuntu/disks/root.disk)
>> >
>> > $ sudo losetup --find --verbose
>> > Loop device is /dev/loop1
>> > /dev/loop1
>> >
>> >  [ /etc/fstab ]
>> > # /etc/fstab: static file system information.
>> >
>> > # Use 'blkid' to print the universally unique identifier for a
>> > # device; this may be used with UUID= as a more robust way to name devices
>> > # that works even if disks are added and removed. See fstab(5).
>> >
>> > # <file system>                 <mount point>   <type>  <options>
>> >          <dump>  <pass>
>> > proc                            /proc           proc
>> > nodev,noexec,nosuid     0       0
>> > /host/ubuntu/disks/root.disk    /               ext4
>> > loop,errors=remount-ro  0       1
>> > /host/ubuntu/disks/swap.disk    none            swap    loop,sw
>> >          0       0
>> > - EOF -
>> >
>> > [ /boot/grub/grub.cfg ]
>> > ...
>> > menuentry 'Ubuntu, mit Linux 3.8.0-rc4-next20130121-1-iniza-generic'
>> > --class ubuntu --class gnu-linux --class gnu --class os {
>> >         set gfxpayload=$linux_gfx_mode
>> >         insmod part_msdos
>> >         insmod ntfs
>> >         set root='(hd0,msdos2)'
>> >         search --no-floppy --fs-uuid --set=root 001AADA61AAD9964
>> >         loopback loop0 /ubuntu/disks/root.disk
>> >         set root=(loop0)
>> >         linux   /boot/vmlinuz-3.8.0-rc4-next20130121-1-iniza-generic
>> > root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>> >         initrd  /boot/initrd.img-3.8.0-rc4-next20130121-1-iniza-generic
>> > }
>> > ...
>> >
>>
>> Here some more useful outputs:
>>
>> $ LC_ALL=C df -h -T
>> Filesystem     Type      Size  Used Avail Use% Mounted on
>> rootfs         rootfs     17G   15G  1.5G  92% /
>> udev           devtmpfs  1.9G   12K  1.9G   1% /dev
>> tmpfs          tmpfs     770M  892K  769M   1% /run
>> /dev/sda2      fuseblk   444G   81G  364G  19% /host
>> /dev/loop0     ext4       17G   15G  1.5G  92% /
>> none           tmpfs     5.0M     0  5.0M   0% /run/lock
>> none           tmpfs     1.9G  260K  1.9G   1% /run/shm
>>
>> $ sudo LC_ALL=C fdisk -l /dev/sda
>>
>> Disk /dev/sda: 500.1 GB, 500107862016 bytes
>> 255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0xcb9885ab
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1   *        2048      206847      102400    7  HPFS/NTFS/exFAT
>> /dev/sda2          206848   931299327   465546240    7  HPFS/NTFS/exFAT
>> /dev/sda3       931299328   976773119    22736896   27  Hidden NTFS WinRE
>>
>> I am still reflecting on any shitty userspace app is causing all the
>> trouble, but I have zero clue how to dig that...
>   Well, I think the outputs make it pretty clear. /dev/loop0 is a mounted
> image from fuse filesystem. Fuse daemon making filesystem accessible gets
> frozen before /dev/loop0 gets fully written out and so jbd2 journal thread
> hangs. Maybe Miklos (added to CC) could fill in some details / ideas but I
> think the setup like you have never really worked...
>

Beyond the FUSE/LOOP fun, will you apply this patch to your linux-next GIT tree?

Feel free to add...

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

A similiar patch for JBD went through your tree into mainline (see [1] and [2]).

Thanks!

- Sedat -


[1] http://git.kernel.org/?p=linux/kernel/git/jack/linux-fs.git;a=shortlog;h=refs/heads/for_next
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=31db720643073571f15eede808486371556f6380
[3] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=7e2fb2d7e6a3094473f101ae33dd6431ae6d2ed1


>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
