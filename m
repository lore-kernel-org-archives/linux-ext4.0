From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: linux-next: Tree for Aug 7 [ call-trace on suspend: ext4 | pm
 related ? ]
Date: Thu, 8 Aug 2013 11:17:53 +0200
Message-ID: <CA+icZUXr=YqR8q_f+u1_etKORyRLs7jJM-7hQ5LxioyRkDOo9g@mail.gmail.com>
References: <CA+icZUW990rWKdQmppjkGTJzFBtTnW-tb0dRu2AbTYB8KSDN4w@mail.gmail.com>
	<2146168.3J7W6RtiZr@vostro.rjw.lan>
	<CAMbhsRSaJWUL2yBnEJ83TCjMJRSZNP0-XM3-mVYf7FuPtUYnUQ@mail.gmail.com>
	<CA+icZUVCBdFARueFRzAWT6Ax19s83ds5LFvqpQ-tOO96-ZhStA@mail.gmail.com>
	<CAMbhsRT6eki+oY4D-iRJz2iqS+N3YBmnC0eP4bMN69cbgj=UsQ@mail.gmail.com>
	<CA+icZUVqGpB9pgzO+Ou=k2jNQFMdjQvxxiuvZCcY4+-BZJDgdw@mail.gmail.com>
	<CAMbhsRSP_YmaFaZ8mrXJdXjWYaXfhQHwuFL5q=QxVxDvQpygWQ@mail.gmail.com>
	<CA+icZUUff_ffAVaUxgMyvNwVX4yDaUeOJLFyiAuWDaraJD4VhQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b45105e084fad04e36c22b3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.sourceforge.net
To: Colin Cross <ccross@android.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+icZUUff_ffAVaUxgMyvNwVX4yDaUeOJLFyiAuWDaraJD4VhQ@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--047d7b45105e084fad04e36c22b3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2013 at 10:46 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Aug 8, 2013 at 3:12 AM, Colin Cross <ccross@android.com> wrote:
>> On Wed, Aug 7, 2013 at 6:01 PM, Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>>> On Thu, Aug 8, 2013 at 1:34 AM, Colin Cross <ccross@android.com> wrote:
>>>> On Wed, Aug 7, 2013 at 4:15 PM, Sedat Dilek <sedat.dilek@gmail.com> wr=
ote:
>>>>> On Thu, Aug 8, 2013 at 12:58 AM, Colin Cross <ccross@android.com> wro=
te:
>>>>>> Can you try add a call to show_state_filter(TASK_UNINTERRUPTIBLE) in
>>>>>> the error path of try_to_freeze_tasks(), where it prints the "refusi=
ng
>>>>>> to freeze" message?  It will print the stack trace of every thread
>>>>>> since they are all in the freezer, so the output will be very long.
>>>>>>
>>>>>
>>>>> If you provide a patch, I will give it a try.
>>>>
>>>> Try the attached patch.
>>>
>>> This time I do not see ext4 related messages.
>>>
>>> - Sedat -
>>
>> Can you describe your filesystem setup?  It looks like you have an
>> ntfs fuse filesystem and a loopback ext4 mount?  Is the file backing
>> the loopback ext4 filesystem located on the ntfs filesystem?
>>
>
> [ CC fuse folks ]
>
> This is a Ubuntu/precise AMD64 installed in a WUBI environment (rootfs
> is an image on my Win7-partition and thus uses fuse/ntfs/loop).
>
> $ cat /etc/fstab
> # /etc/fstab: static file system information.
>
> # Use 'blkid' to print the universally unique identifier for a
> # device; this may be used with UUID=3D as a more robust way to name devi=
ces
> # that works even if disks are added and removed. See fstab(5).
>
> # <file system>                 <mount point>   <type>  <options>
>          <dump>  <pass>
> proc                            /proc           proc
> nodev,noexec,nosuid     0       0
> /host/ubuntu/disks/root.disk    /               ext4
> loop,errors=3Dremount-ro  0       1
> /host/ubuntu/disks/swap.disk    none            swap    loop,sw
>          0       0
>
> $ df -T
> Dateisystem    Typ      1K-Bl=C3=B6cke   Benutzt Verf=C3=BCgbar Verw% Ein=
geh=C3=A4ngt auf
> rootfs         rootfs    17753424  11598008   5230540   69% / <---
> 18GiB file-image
> udev           devtmpfs   1969240         4   1969236    1% /dev
> tmpfs          tmpfs       789036       884    788152    1% /run
> /dev/sda2      fuseblk  465546236 107358584 358187652   24% /host <--- Wi=
n7-OS
> /dev/loop0     ext4      17753424  11598008   5230540   69% /
> none           tmpfs         5120         0      5120    0% /run/lock
> none           tmpfs      1972588       200   1972388    1% /run/shm
>
> $ sudo LC_ALL=3DC fdisk -l /dev/sda
>
> Disk /dev/sda: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0xcb9885ab
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *        2048      206847      102400    7  HPFS/NTFS/exFAT
> /dev/sda2          206848   931299327   465546240    7  HPFS/NTFS/exFAT
> /dev/sda3       931299328   976773119    22736896   27  Hidden NTFS WinRE
>
> [ /etc/grub.d/40_custom ]
> ...
> menuentry "Ubuntu/precise AMD64, WUBI-system with Ubuntu-kernel"
> --class ubuntu --class gnu-linux --class gnu --class os {
>         insmod part_msdos
>         insmod ntfs
>         set root=3D'(hd0,msdos2)'
>         search --no-floppy --fs-uuid --set=3Droot 001AADA61AAD9964
>         loopback loop0 /ubuntu/disks/root.disk
>         set root=3D(loop0)
>         linux /vmlinuz root=3DUUID=3D001AADA61AAD9964
> loop=3D/ubuntu/disks/root.disk ro
>         initrd /initrd.img
> }
> ...
>
> So, no "native" Linux installation here.
>
> - Sedat -
>
> [1] https://wiki.ubuntu.com/WubiGuide
>
>> This looks like the interesting part, the process backing the fuse
>> filesystem is frozen (through the normal freeze path, not any of my
>> new freeze points), and the loop0 processes are blocked on it.  It
>> doesn't seem related to my patches.
>>
>> [  125.336205] mount.ntfs      D ffffffff81811820     0   303      1 0x0=
0000004
>> [  125.336209]  ffff8800d3e95d18 0000000000000002 0000000037a6b000
>> ffff8800d57a66b8
>> [  125.336212]  ffff8801185286c0 ffff8800d3e95fd8 ffff8800d3e95fd8
>> ffff8800d3e95fd8
>> [  125.336214]  ffffffff81c144a0 ffff8801185286c0 ffff8800d3e95d08
>> ffff8801185286c0
>> [  125.336217] Call Trace:
>> [  125.336225]  [<ffffffff816e81b9>] schedule+0x29/0x70
>> [  125.336230]  [<ffffffff810ba663>] __refrigerator+0x43/0xe0
>> [  125.336234]  [<ffffffff81078e19>] get_signal_to_deliver+0x5b9/0x600
>> [  125.336238]  [<ffffffff812c4b98>] ? fuse_dev_read+0x68/0x80
>> [  125.336242]  [<ffffffff810133b8>] do_signal+0x58/0x8f0
>> [  125.336246]  [<ffffffff8110906c>] ? acct_account_cputime+0x1c/0x20
>> [  125.336249]  [<ffffffff8137a90d>] ? do_raw_spin_unlock+0x5d/0xb0
>> [  125.336252]  [<ffffffff816e968e>] ? _raw_spin_unlock+0xe/0x10
>> [  125.336255]  [<ffffffff8109d00d>] ? vtime_account_user+0x6d/0x80
>> [  125.336258]  [<ffffffff81013cd8>] do_notify_resume+0x88/0xc0
>> [  125.336261]  [<ffffffff816f26da>] int_signal+0x12/0x17
>> [  125.336263] loop0           D ffffffff81811820     0   310      2 0x0=
0000000
>> [  125.336265]  ffff8800d573d968 0000000000000002 0000000000000000
>> ffff8800d57aeb80
>> [  125.336268]  ffff880118bda740 ffff8800d573dfd8 ffff8800d573dfd8
>> ffff8800d573dfd8
>> [  125.336270]  ffff880119f98340 ffff880118bda740 ffff8800d573d968
>> ffff88011fad5118
>> [  125.336273] Call Trace:
>> [  125.336278]  [<ffffffff811443a0>] ? __lock_page+0x70/0x70
>> [  125.336280]  [<ffffffff816e81b9>] schedule+0x29/0x70
>> [  125.336283]  [<ffffffff816e828f>] io_schedule+0x8f/0xd0
>> [  125.336286]  [<ffffffff811443ae>] sleep_on_page+0xe/0x20
>> [  125.336288]  [<ffffffff816e49ed>] __wait_on_bit_lock+0x5d/0xc0
>> [  125.336291]  [<ffffffff81144397>] __lock_page+0x67/0x70
>> [  125.336294]  [<ffffffff8108a0e0>] ? wake_atomic_t_function+0x40/0x40
>> [  125.336298]  [<ffffffff811da79f>] __generic_file_splice_read+0x59f/0x=
5d0
>> [  125.336302]  [<ffffffff813656d8>] ? cpumask_next_and+0x38/0x50
>> [  125.336305]  [<ffffffff810a3b33>] ? update_sd_lb_stats+0x123/0x610
>> [  125.336309]  [<ffffffff81048143>] ? x2apic_send_IPI_mask+0x13/0x20
>> [  125.336312]  [<ffffffff8104029b>] ? native_smp_send_reschedule+0x4b/0=
x60
>> [  125.336315]  [<ffffffff810964b6>] ? resched_task+0x76/0x80
>> [  125.336318]  [<ffffffff811d8c80>] ? page_cache_pipe_buf_release+0x30/=
0x30
>> [  125.336321]  [<ffffffff811da80e>] generic_file_splice_read+0x3e/0x80
>> [  125.336324]  [<ffffffff811d8f6b>] do_splice_to+0x7b/0xa0
>> [  125.336326]  [<ffffffff811d91f7>] splice_direct_to_actor+0xa7/0x1c0
>> [  125.336330]  [<ffffffff81495780>] ? loop_thread+0x2a0/0x2a0
>> [  125.336333]  [<ffffffff81495292>] do_bio_filebacked+0xf2/0x340
>> [  125.336336]  [<ffffffff8137a79c>] ? do_raw_spin_lock+0x4c/0x120
>> [  125.336339]  [<ffffffff814955c5>] loop_thread+0xe5/0x2a0
>> [  125.336341]  [<ffffffff8108a060>] ? __init_waitqueue_head+0x40/0x40
>> [  125.336344]  [<ffffffff814954e0>] ? do_bio_filebacked+0x340/0x340
>> [  125.336346]  [<ffffffff81089848>] kthread+0xd8/0xe0
>> [  125.336348]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
>> [  125.336351]  [<ffffffff816f236c>] ret_from_fork+0x7c/0xb0
>> [  125.336353]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
>> [  125.336354] jbd2/loop0-8    D 0000000000000000     0   312      2 0x0=
0000000
>> [  125.336357]  ffff8800d56c7b08 0000000000000002 ffff8800d56c7ab8
>> ffffffff8137a90d
>> [  125.336359]  ffff880037ba4240 ffff8800d56c7fd8 ffff8800d56c7fd8
>> ffff8800d56c7fd8
>> [  125.336362]  ffff88010d33e5c0 ffff880037ba4240 ffff8800d56c7b08
>> ffff88011fad5118
>> [  125.336364] Call Trace:
>> [  125.336367]  [<ffffffff8137a90d>] ? do_raw_spin_unlock+0x5d/0xb0
>> [  125.336369]  [<ffffffff811ddcb0>] ? __wait_on_buffer+0x30/0x30
>> [  125.336371]  [<ffffffff816e81b9>] schedule+0x29/0x70
>> [  125.336374]  [<ffffffff816e828f>] io_schedule+0x8f/0xd0
>> [  125.336376]  [<ffffffff811ddcbe>] sleep_on_buffer+0xe/0x20
>> [  125.336378]  [<ffffffff816e4c22>] __wait_on_bit+0x62/0x90
>> [  125.336380]  [<ffffffff811ddcb0>] ? __wait_on_buffer+0x30/0x30
>> [  125.336382]  [<ffffffff816e4ccc>] out_of_line_wait_on_bit+0x7c/0x90
>> [  125.336384]  [<ffffffff8108a0e0>] ? wake_atomic_t_function+0x40/0x40
>> [  125.336386]  [<ffffffff811ddcae>] __wait_on_buffer+0x2e/0x30
>> [  125.336390]  [<ffffffff812a02c1>]
>> jbd2_journal_commit_transaction+0x1051/0x1c60
>> [  125.336393]  [<ffffffff810a460b>] ? load_balance+0x14b/0x870
>> [  125.336397]  [<ffffffff816e97e4>] ? _raw_spin_lock_irqsave+0x24/0x30
>> [  125.336399]  [<ffffffff8107328f>] ? try_to_del_timer_sync+0x4f/0x70
>> [  125.336402]  [<ffffffff812a5a7b>] kjournald2+0x11b/0x350
>> [  125.336405]  [<ffffffff816e72e5>] ? __schedule+0x3e5/0x850
>> [  125.336407]  [<ffffffff8108a060>] ? __init_waitqueue_head+0x40/0x40
>> [  125.336410]  [<ffffffff812a5960>] ? jbd2_journal_clear_features+0x90/=
0x90
>> [  125.336412]  [<ffffffff81089848>] kthread+0xd8/0xe0
>> [  125.336414]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
>> [  125.336416]  [<ffffffff816f236c>] ret_from_fork+0x7c/0xb0
>> [  125.336418]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0

My 1st suspend try with next-20130808 shows same isssue (w/o your "hack" pa=
tch):

[   98.026982] PM: Syncing filesystems ... done.
[   98.321181] PM: Preparing system for mem sleep
[   98.321736] Freezing user space processes ...
[  118.320817] Freezing of tasks failed after 20.003 seconds (1 tasks
refusing to freeze, wq_busy=3D0):
[  118.320838] apt-check       D 0000000000000000     0  2636   2456 0x0000=
0004
[  118.320841]  ffff880109631c98 0000000000000002 0000000000000000
ffff88005c044280
[  118.320845]  ffff88005c1d4640 ffff880109631fd8 ffff880109631fd8
ffff880109631fd8
[  118.320847]  ffff880119f440c0 ffff88005c1d4640 ffff880109631c98
ffff88011fa15118
[  118.320850] Call Trace:
[  118.320859]  [<ffffffff81144500>] ? sleep_on_page+0x20/0x20
[  118.320863]  [<ffffffff816e8889>] schedule+0x29/0x70
[  118.320865]  [<ffffffff816e895f>] io_schedule+0x8f/0xd0
[  118.320868]  [<ffffffff8114450e>] sleep_on_page_killable+0xe/0x40
[  118.320871]  [<ffffffff816e50bd>] __wait_on_bit_lock+0x5d/0xc0
[  118.320874]  [<ffffffff81144467>] __lock_page_killable+0x67/0x70
[  118.320877]  [<ffffffff8108a110>] ? wake_atomic_t_function+0x40/0x40
[  118.320880]  [<ffffffff8114738e>] generic_file_aio_read+0x47e/0x720
[  118.320883]  [<ffffffff811ac3aa>] do_sync_read+0x5a/0x90
[  118.320885]  [<ffffffff811ad444>] vfs_read+0xb4/0x180
[  118.320887]  [<ffffffff811ad6c2>] SyS_read+0x52/0xa0
[  118.320891]  [<ffffffff816f2cef>] tracesys+0xe1/0xe6
[  118.320892]
[  118.320893] Restarting tasks ... done.

I walked trough my scripts-dir... is run_pm-test.sh an appropriate
test-case/use-case?

- Sedat -

--047d7b45105e084fad04e36c22b3
Content-Type: application/x-sh; name="run_pm-test.sh"
Content-Disposition: attachment; filename="run_pm-test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk3r52kq0

IyEvYmluL2Jhc2gKCiMjIyBOT1RFOiBSdW4gYXMgcm9vdAoKIyMjIEhFTFAKIyBbMV0gaHR0cDov
L2dpdC5rZXJuZWwub3JnLz9wPWxpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0O2E9
YmxvYjtmPURvY3VtZW50YXRpb24vcG93ZXIvYmFzaWMtcG0tZGVidWdnaW5nLnR4dAojIFsyXSBo
dHRwOi8vZ2l0Lmtlcm5lbC5vcmcvP3A9bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5n
aXQ7YT1ibG9iO2Y9RG9jdW1lbnRhdGlvbi9wb3dlci9mcmVlemluZy1vZi10YXNrcy50eHQKCiMj
IyBQUkVSRVE6IEtlcm5lbCBERUJVRyBvcHRpb25zCiMgKyBDT05GSUdfUE1fREVCVUc9eQojICsg
Q09ORklHX0VYVDRfREVCVUc9eQojICsgQ09ORklHX0pCRDJfREVCVUc9eQoKZXhwb3J0IExBTkc9
QwpleHBvcnQgTENfQUxMPUMKCiMjIyBEZWZhdWx0IHZhbHVlIG9mIGh1bmdfdGFza190aW1lb3V0
X3NlY3MgaXMgMTIwIFtzZWNzXQpTRUNTPSIwIgoKIyMjIFBvc3NpYmxlIHR5cGVzOiBub25lIGNv
cmUgcHJvY2Vzc29ycyBwbGF0Zm9ybSBkZXZpY2VzIGZyZWV6ZXIKUE1fVEVTVF9UWVBFPSJmcmVl
emVyIgoKIyMjIENvdW50ZXIgYW5kIGxvb3BzCkNPVU5URVI9IjAiCkxPT1BTPSIxMCIKCmVjaG8g
IiRTRUNTIiA+IC9wcm9jL3N5cy9rZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcwplY2hvICJo
dW5nX3Rhc2tfdGltZW91dF9zZWNzIFtzZWNzXSBpcyBub3cgLi4uIgpjYXQgL3Byb2Mvc3lzL2tl
cm5lbC9odW5nX3Rhc2tfdGltZW91dF9zZWNzCgplY2hvICIkUE1fVEVTVF9UWVBFIiA+IC9zeXMv
cG93ZXIvcG1fdGVzdAplY2hvICJwbS10ZXN0IHR5cGUgW3N0cmluZ10gaXMgbm93IC4uLiIKY2F0
IC9zeXMvcG93ZXIvcG1fdGVzdAoKZWNobyAicG1fdGVzdC8kUE1fVEVTVF9UWVBFOiBSdW5uaW5n
IC4uLiIKd2hpbGUgWyAkQ09VTlRFUiAtbHQgJExPT1BTIF07IGRvCiAgICBlY2hvIFsgUnVubmlu
ZyAuLi4gJENPVU5URVIgXQogICAgZWNobyBtZW0gPiAvc3lzL3Bvd2VyL3N0YXRlICYmIHNsZWVw
IDEKICAgIGVjaG8gWyBEb25lIC4uLi4uLiAkQ09VTlRFUiBdCiAgICBsZXQgQ09VTlRFUj1DT1VO
VEVSKzEKZG9uZQplY2hvICJwbV90ZXN0LyRQTV9URVNUX1RZUEU6IEVORC4iCg==
--047d7b45105e084fad04e36c22b3--
