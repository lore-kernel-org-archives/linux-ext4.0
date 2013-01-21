From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: jbd2: don't wake kjournald unnecessarily
Date: Mon, 21 Jan 2013 13:30:26 +0100
Message-ID: <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
	<CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
	<20130121104733.GE5588@quack.suse.cz>
	<CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 21, 2013 at 12:40 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Mon, Jan 21, 2013 at 11:47 AM, Jan Kara <jack@suse.cz> wrote:
>> On Sun 20-01-13 01:06:40, Sedat Dilek wrote:
>>> On Sun, Jan 20, 2013 at 12:44 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> > Hi,
>>> >
>>> > I and some others hit a similiar problem in Linux-Next
>>> > (next-20130118), please see [1] and [2].
>>> >
>>> > [3] has a interim analyze of my problems.
>>> >
>>> > After suspecting the problem was caused by TTY-NEXT, it turned out to
>>> > be a JBD2 problem finally.
>>> > The freezer/pm_test was helpful to hit the issue (Thanks Rafael for the hint!).
>>> >
>>> > So, the issue has two faces: TTY and JBD2.
>>> > [4] gives a list and URLs of the patches I had to apply to have a
>>> > clean system again.
>>> >
>>> > After applying the two TTY patches (without Eric's JBD2-fix!) the
>>> > call-trace after freezer/pm_test looked like this;
>>> >
>>> > [  433.527986] PM: Syncing filesystems ... done.
>>> > [  433.843761] PM: Preparing system for mem sleep
>>> > [  436.306002] Freezing user space processes ...
>>> > [  456.304956] Freezing of tasks failed after 20.01 seconds (1 tasks
>>> > refusing to freeze, wq_busy=0):
>>> > [  456.305060] Cache I/O       D ffffffff8180d780     0  2132      1 0x00000004
>>> > [  456.305065]  ffff88007b9dfe18 0000000000000046 ffff88007b9dfdc8
>>> > 0000000300000001
>>> > [  456.305069]  ffff880097e21720 ffff88007b9dffd8 ffff88007b9dffd8
>>> > ffff88007b9dffd8
>>> > [  456.305072]  ffff880119b32e40 ffff880097e21720 ffff88007b9dfe28
>>> > ffff880118077800
>>> > [  456.305076] Call Trace:
>>> > [  456.305085]  [<ffffffff816b7469>] schedule+0x29/0x70
>>> > [  456.305089]  [<ffffffff8129067d>] jbd2_log_wait_commit+0xcd/0x1a0
>>> > [  456.305094]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>>> > [  456.305098]  [<ffffffff812307a5>] ext4_sync_file+0x205/0x380
>>> > [  456.305103]  [<ffffffff811c43ad>] do_fsync+0x5d/0x90
>>> > [  456.305108]  [<ffffffff8119442b>] ? sys_write+0x6b/0xa0
>>> > [  456.305111]  [<ffffffff811c4790>] sys_fsync+0x10/0x20
>>> > [  456.305114]  [<ffffffff816c0edd>] system_call_fastpath+0x1a/0x1f
>>> > [  456.305122]
>>> > [  456.305124] Restarting tasks ... done.
>>> > [  456.315056] video LNXVIDEO:00: Restoring backlight state
>>> >
>>> > After applying Eric's patch [5], I could not hit the call-trace again.
>>> > NOTE: The patch is from December 2012 and is not shipped in latest Linux-Next.
>>> >
>>> > The attached testcase script was helpful to force the call-trace.
>>> > I have run 50 loops of it w/o an issue!
>>> >
>>> > Feel free to add a Reported-by/Tested-by.
>>> > ( The issue kept me busy for the last days. )
>>> >
>>> > Regards,
>>> > - Sedat -
>>> >
>>> > [1] http://marc.info/?t=135283664600002&r=1&w=2
>>> > [2] http://marc.info/?t=135862023700004&r=1&w=2
>>> > [3] http://marc.info/?l=linux-kernel&m=135862010419101&w=2
>>> > [4] http://marc.info/?l=linux-next&m=135863550923093&w=2
>>> > [5] http://patchwork.ozlabs.org/patch/207237/
>>>
>>> Hi all,
>>>
>>> this is really ugly... I could cry!
>>>
>>> GRRR, I have hit the original issue again while running my testcase script!
>>>
>>> [  363.831226] PM: Syncing filesystems ... done.
>>> [  363.988855] PM: Preparing system for mem sleep
>>> [  369.032965] Freezing user space processes ... (elapsed 0.11 seconds) done.
>>> [  369.145792] Freezing remaining freezable tasks ...
>>> [  389.137643] Freezing of tasks failed after 20.01 seconds (1 tasks
>>> refusing to freeze, wq_busy=0):
>>> [  389.137760] jbd2/loop0-8    D ffffffff8180d780     0   295      2 0x00000000
>>> [  389.137769]  ffff8801181dfb68 0000000000000046 ffff880117de5c80
>>> 0000000000000001
>>> [  389.137778]  ffff880117de5c80 ffff8801181dffd8 ffff8801181dffd8
>>> ffff8801181dffd8
>>> [  389.137784]  ffffffff81c15440 ffff880117de5c80 ffff8801181dfb68
>>> ffff88011fa14738
>>> [  389.137791] Call Trace:
>>> [  389.137810]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
>>> [  389.137819]  [<ffffffff816b7479>] schedule+0x29/0x70
>>> [  389.137825]  [<ffffffff816b754f>] io_schedule+0x8f/0xd0
>>> [  389.137832]  [<ffffffff811c683e>] sleep_on_buffer+0xe/0x20
>>> [  389.137842]  [<ffffffff816b5d4f>] __wait_on_bit+0x5f/0x90
>>> [  389.137849]  [<ffffffff811c5ef1>] ? submit_bh+0x121/0x1e0
>>> [  389.137856]  [<ffffffff811c6830>] ? __wait_on_buffer+0x30/0x30
>>> [  389.137864]  [<ffffffff816b5dfc>] out_of_line_wait_on_bit+0x7c/0x90
>>> [  389.137873]  [<ffffffff8107eb00>] ? autoremove_wake_function+0x40/0x40
>>> [  389.137879]  [<ffffffff811c682e>] __wait_on_buffer+0x2e/0x30
>>> [  389.137891]  [<ffffffff8128c02c>]
>>> jbd2_journal_commit_transaction+0x18cc/0x1d60
>>> [  389.137899]  [<ffffffff816b860e>] ? _raw_spin_lock_irqsave+0x2e/0x40
>>> [  389.137908]  [<ffffffff81069fbf>] ? try_to_del_timer_sync+0x4f/0x70
>>> [  389.137915]  [<ffffffff81290836>] kjournald2+0xd6/0x3e0
>>> [  389.137921]  [<ffffffff8107eac0>] ? add_wait_queue+0x60/0x60
>>> [  389.137926]  [<ffffffff81290760>] ? commit_timeout+0x10/0x10
>>> [  389.137932]  [<ffffffff8107ded0>] kthread+0xc0/0xd0
>>> [  389.137939]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>>> [  389.137946]  [<ffffffff816c0e2c>] ret_from_fork+0x7c/0xb0
>>> [  389.137951]  [<ffffffff8107de10>] ? flush_kthread_worker+0xb0/0xb0
>>> [  389.138017]
>>> [  389.138021] Restarting kernel threads ... done.
>>> [  389.138173] Restarting tasks ... done.
>>> [  389.147980] video LNXVIDEO:00: Restoring backlight state
>>>
>>> I suspect there are still issues in JBD2 (BTW I run here EXT4FS).
>>>
>>> [  389.137643] Freezing of tasks failed after 20.01 seconds (1 tasks
>>> refusing to freeze, wq_busy=0):
>>> [  389.137760] jbd2/loop0-8    D ffffffff8180d780     0   295      2 0x00000000
>>>
>>> Have a good night, /me -> watching TV!
>>   The traces don't suggest an ext4/jbd2 problem. What is happening is that
>> jbd2 is waiting for IO to finish and that never happens. Seeing that you
>> loop device I'd think it's some interaction of the loop device and
>> freezing. Can you reproduce the issue without the loop device (i.e. with
>> the filesystem directly on e.g. scsi disk)? I suspect the reason is
>> something like that the backing filesystem is already frozen so filesystem
>> on top of it cannot write all the data and hangs waiting for IO -> suspend
>> doesn't happen. Contents of /proc/mounts and losetup -l would help us
>> understand what's going on.
>>
>
> As said I am here in a very uncommon WUBI environment means my
> Ubuntu/precise rootfs-image lays on the Win7-partition (NTFS).
> Your explanation sounds reasonable to me as this line from my attached
> testcase causes the troubles.
>
>      echo mem > /sys/power/state && sleep 1
>
> So, /sys/ is not writable immediately after freezer ends
>
> I checked again and again my logs and have seen "starving" lines
> reported by rtkit-daemon, but did not really get wiser what they want
> to tell me. Stopping rtkit-daemon or resetting all or all-known
> threads before running my pm_test/freezer did not help, too.
>
> /usr/sbin/rtkitctl --help
> rtkitctl [options]
>
>   -h, --help         Show this help
>       --version      Show version
>
>       --reset-known  Reset real-time status of known threads
>       --reset-all    Reset real-time status of all threads
>       --start        Start RealtimeKit if it is not running already
>   -k, --exit         Terminate running RealtimeKit daemon
>
> Here are the outputs you wanted with some more (fstab, grub-config) etc.
> I have here no -l option for losetup command.
>
>
> - Sedat -
>
> P.S.: Outputs for Honza...
>
> $ sudo cat /proc/mounts
> rootfs / rootfs rw 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> udev /dev devtmpfs rw,relatime,size=1966948k,nr_inodes=491737,mode=755 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> tmpfs /run tmpfs rw,nosuid,relatime,size=788076k,mode=755 0 0
> /dev/sda2 /host fuseblk
> rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096
> 0 0
> /dev/loop0 / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> none /sys/fs/fuse/connections fusectl rw,relatime 0 0
> none /sys/kernel/debug debugfs rw,relatime 0 0
> none /sys/kernel/security securityfs rw,relatime 0 0
> none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
> gvfs-fuse-daemon /home/wearefam/.gvfs fuse.gvfs-fuse-daemon
> rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
>
> $ sudo losetup --all --verbose
> /dev/loop0: [0802]:17982 (/host/ubuntu/disks/root.disk)
>
> $ sudo losetup --find --verbose
> Loop device is /dev/loop1
> /dev/loop1
>
>  [ /etc/fstab ]
> # /etc/fstab: static file system information.
>
> # Use 'blkid' to print the universally unique identifier for a
> # device; this may be used with UUID= as a more robust way to name devices
> # that works even if disks are added and removed. See fstab(5).
>
> # <file system>                 <mount point>   <type>  <options>
>          <dump>  <pass>
> proc                            /proc           proc
> nodev,noexec,nosuid     0       0
> /host/ubuntu/disks/root.disk    /               ext4
> loop,errors=remount-ro  0       1
> /host/ubuntu/disks/swap.disk    none            swap    loop,sw
>          0       0
> - EOF -
>
> [ /boot/grub/grub.cfg ]
> ...
> menuentry 'Ubuntu, mit Linux 3.8.0-rc4-next20130121-1-iniza-generic'
> --class ubuntu --class gnu-linux --class gnu --class os {
>         set gfxpayload=$linux_gfx_mode
>         insmod part_msdos
>         insmod ntfs
>         set root='(hd0,msdos2)'
>         search --no-floppy --fs-uuid --set=root 001AADA61AAD9964
>         loopback loop0 /ubuntu/disks/root.disk
>         set root=(loop0)
>         linux   /boot/vmlinuz-3.8.0-rc4-next20130121-1-iniza-generic
> root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>         initrd  /boot/initrd.img-3.8.0-rc4-next20130121-1-iniza-generic
> }
> ...
>

Here some more useful outputs:

$ LC_ALL=C df -h -T
Filesystem     Type      Size  Used Avail Use% Mounted on
rootfs         rootfs     17G   15G  1.5G  92% /
udev           devtmpfs  1.9G   12K  1.9G   1% /dev
tmpfs          tmpfs     770M  892K  769M   1% /run
/dev/sda2      fuseblk   444G   81G  364G  19% /host
/dev/loop0     ext4       17G   15G  1.5G  92% /
none           tmpfs     5.0M     0  5.0M   0% /run/lock
none           tmpfs     1.9G  260K  1.9G   1% /run/shm

$ sudo LC_ALL=C fdisk -l /dev/sda

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0xcb9885ab

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      206847      102400    7  HPFS/NTFS/exFAT
/dev/sda2          206848   931299327   465546240    7  HPFS/NTFS/exFAT
/dev/sda3       931299328   976773119    22736896   27  Hidden NTFS WinRE

I am still reflecting on any shitty userspace app is causing all the
trouble, but I have zero clue how to dig that...

- Sedat -

> Hope this helps you!
>
> Regards,
> - Sedat -
>
>>                                                                 Honza
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
