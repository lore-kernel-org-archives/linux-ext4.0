From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: ext4 blocks up
Date: Mon, 02 Jul 2012 15:15:16 +0300
Message-ID: <1341231316.2979.11.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9CgaDcNNbM57iruUOIds"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-9CgaDcNNbM57iruUOIds
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

first of all I want to remind you about the sync_supers changes which
you said you'd make sure get properly reviewed and tested for v3.5. But
I am getting worried about missing also 3.5.

I wanted to re-send the patch-set, but I cannot test it because ext4
blocks when I test it with xfstests.

The HEAD of xfstests I use is:
7d14795 xfstests: introduce 286 for SEEK_DATA/SEEK_HOLE copy test

I run xfstests with "check -g auto" command. My environment is:

export TEST_DIR=3D/mnt/xfstests-disk-1
export TEST_DEV=3D/dev/vdb
export SCRATCH_MNT=3D/mnt/xfstests-disk-2
export SCRATCH_DEV=3D/dev/vdc
export FSTYP=3Dext4

The disks are not very big, df says:

/dev/vdb         4181968   192780   3779476   5% /mnt/xfstests-disk-1
/dev/vdc        12539816   486160  11424512   5% /mnt/xfstests-disk-2

Is this a known issue? Please, let me know if you need more information.
I can also try some patches for you.

I've just tested 3.5-rc5 in my kvm machine. Below is what dmesg gives
me:

[    2.541716] EXT4-fs (vda1): re-mounted. Opts: (null)
[    3.230435] systemd-fsck[508]: home: clean, 316114/2097152 files, 295960=
3/8388608 blocks
[    3.296292] hrtimer: interrupt took 2148140 ns
[    3.369675] EXT4-fs (vda2): mounted filesystem with ordered data mode. O=
pts: (null)
[    3.604614] /usr/sbin/crond[559]: (CRON) INFO (Syslog will be used inste=
ad of sendmail.): No such file or directory
[    3.638686] /usr/sbin/crond[559]: (CRON) INFO (running with inotify supp=
ort)
[   50.659283] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: (null)
[   50.687492] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: (null)
[   52.098169] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   52.272963] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   56.323779] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   56.771414] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   57.459560] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   58.176195] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   59.117647] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   60.686415] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   61.116057] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   62.321826] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   69.970617] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   70.315529] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   70.344068] EXT4-fs (vdb): re-mounted. Opts: data=3Dordered
[   71.086640] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   71.632241] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   71.840146] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   72.229582] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   73.526206] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   78.180546] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   78.518143] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   78.693992] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   80.758908] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   81.629718] EXT4-fs (vdb): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[   83.278788] EXT4-fs (vdc): mounted filesystem with ordered data mode. Op=
ts: acl,user_xattr
[  240.379170] INFO: task flush-253:32:1336 blocked for more than 120 secon=
ds.
[  240.379402] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.379605] flush-253:32    D ffff8803118d8508     0  1336      2 0x0000=
0000
[  240.379608]  ffff88030f93dae0 0000000000000046 ffff88030f93da80 ffffffff=
810bbb5d
[  240.379612]  ffff880312b13f80 ffff88030f93dfd8 ffff88030f93dfd8 ffff8803=
0f93dfd8
[  240.379615]  ffff88031458df40 ffff880312b13f80 ffff88030f93db70 ffff8803=
0c198800
[  240.379618] Call Trace:
[  240.379632]  [<ffffffff810bbb5d>] ? trace_hardirqs_on+0xd/0x10
[  240.379641]  [<ffffffff81628029>] schedule+0x29/0x70
[  240.379650]  [<ffffffff81236e85>] ext4_force_commit+0x85/0xc0
[  240.379656]  [<ffffffff8107fcc0>] ? __init_waitqueue_head+0x60/0x60
[  240.379660]  [<ffffffff81214805>] ext4_write_inode+0x75/0x110
[  240.379667]  [<ffffffff811bcba1>] __writeback_single_inode+0x161/0x1a0
[  240.379670]  [<ffffffff811becdf>] writeback_sb_inodes+0x24f/0x440
[  240.379672]  [<ffffffff811bf094>] wb_writeback+0xf4/0x370
[  240.379677]  [<ffffffff81062647>] ? local_bh_enable_ip+0x97/0x100
[  240.379680]  [<ffffffff810bbb5d>] ? trace_hardirqs_on+0xd/0x10
[  240.379683]  [<ffffffff811c0ae2>] wb_do_writeback+0xc2/0x200
[  240.379685]  [<ffffffff8106b02e>] ? del_timer+0x8e/0x140
[  240.379688]  [<ffffffff811c0ca4>] bdi_writeback_thread+0x84/0x2d0
[  240.379692]  [<ffffffff811c0c20>] ? wb_do_writeback+0x200/0x200
[  240.379695]  [<ffffffff8107f19e>] kthread+0xae/0xc0
[  240.379699]  [<ffffffff81633374>] kernel_thread_helper+0x4/0x10
[  240.379702]  [<ffffffff81629c70>] ? retint_restore_args+0x13/0x13
[  240.379704]  [<ffffffff8107f0f0>] ? __init_kthread_worker+0x70/0x70
[  240.379706]  [<ffffffff81633370>] ? gs_change+0x13/0x13
[  240.379708] no locks held by flush-253:32/1336.
[  240.379710] INFO: task ext4lazyinit:14878 blocked for more than 120 seco=
nds.
[  240.379899] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.380129] ext4lazyinit    D 0000000000000000     0 14878      2 0x0000=
0000
[  240.380132]  ffff8803140dfd10 0000000000000046 ffff8803140dfcb0 ffffffff=
810bbb5d
[  240.380135]  ffff880312523f80 ffff8803140dffd8 ffff8803140dffd8 ffff8803=
140dffd8
[  240.380138]  ffffffff81c13420 ffff880312523f80 ffff8803140dfd00 ffff8803=
0c19a000
[  240.380141] Call Trace:
[  240.380144]  [<ffffffff810bbb5d>] ? trace_hardirqs_on+0xd/0x10
[  240.380147]  [<ffffffff81628029>] schedule+0x29/0x70
[  240.380149]  [<ffffffff812360c5>] ext4_journal_start_sb+0x1c5/0x200
[  240.380152]  [<ffffffff81210ddb>] ? ext4_init_inode_table+0xab/0x350
[  240.380154]  [<ffffffff8107fcc0>] ? __init_waitqueue_head+0x60/0x60
[  240.380156]  [<ffffffff81210ddb>] ext4_init_inode_table+0xab/0x350
[  240.380159]  [<ffffffff816260f0>] ? mutex_lock_nested+0x290/0x360
[  240.380162]  [<ffffffff8122558b>] ? ext4_lazyinit_thread+0x5b/0x2f0
[  240.380165]  [<ffffffff81225640>] ext4_lazyinit_thread+0x110/0x2f0
[  240.380167]  [<ffffffff81225530>] ? ext4_unregister_li_request+0x70/0x70
[  240.380169]  [<ffffffff8107f19e>] kthread+0xae/0xc0
[  240.380172]  [<ffffffff81633374>] kernel_thread_helper+0x4/0x10
[  240.380174]  [<ffffffff81629c70>] ? retint_restore_args+0x13/0x13
[  240.380176]  [<ffffffff8107f0f0>] ? __init_kthread_worker+0x70/0x70
[  240.380178]  [<ffffffff81633370>] ? gs_change+0x13/0x13
[  240.380180] 1 lock held by ext4lazyinit/14878:
[  240.380181]  #0:  (&eli->li_list_mtx){+.+...}, at: [<ffffffff8122558b>] =
ext4_lazyinit_thread+0x5b/0x2f0
[  240.380191] INFO: task fsstress:15250 blocked for more than 120 seconds.
[  240.380429] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.380718] fsstress        D ffff880308e05880     0 15250  15249 0x0000=
0000
[  240.380721]  ffff8803107ddc18 0000000000000046 ffff8803107ddbb8 ffffffff=
810bbb5d
[  240.380724]  ffff8803125adf40 ffff8803107ddfd8 ffff8803107ddfd8 ffff8803=
107ddfd8
[  240.380727]  ffff88031458df40 ffff8803125adf40 ffff880300000000 ffff8803=
12be6140
[  240.380730] Call Trace:
[  240.380734]  [<ffffffff810bbb5d>] ? trace_hardirqs_on+0xd/0x10
[  240.380737]  [<ffffffff81628029>] schedule+0x29/0x70
[  240.380744]  [<ffffffff81133b55>] __generic_file_aio_write+0xb5/0x440
[  240.380747]  [<ffffffff8107fcc0>] ? __init_waitqueue_head+0x60/0x60
[  240.380749]  [<ffffffff81133f54>] generic_file_aio_write+0x74/0xe0
[  240.380753]  [<ffffffff811a0da5>] ? putname+0x35/0x50
[  240.380755]  [<ffffffff8120df27>] ext4_file_write+0xc7/0x270
[  240.380759]  [<ffffffff81195072>] do_sync_write+0xd2/0x110
[  240.380762]  [<ffffffff81084bb3>] ? up_read+0x23/0x40
[  240.380767]  [<ffffffff81284a5c>] ? security_file_permission+0x2c/0xb0
[  240.380770]  [<ffffffff81195611>] ? rw_verify_area+0x61/0xf0
[  240.380772]  [<ffffffff81195973>] vfs_write+0xb3/0x180
[  240.380774]  [<ffffffff81195c9a>] sys_write+0x4a/0x90
[  240.380777]  [<ffffffff81631f29>] system_call_fastpath+0x16/0x1b
[  240.380778] 1 lock held by fsstress/15250:
[  240.380779]  #0:  (&sb->s_type->i_mutex_key#12){+.+...}, at: [<ffffffff8=
1133f38>] generic_file_aio_write+0x58/0xe0
[  240.380785] INFO: task fsstress:15251 blocked for more than 120 seconds.
[  240.380966] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.381194] fsstress        D ffff8803125a8000     0 15251  15249 0x0000=
0000
[  240.381197]  ffff880310651c38 0000000000000046 ffff8803125a86d8 00000000=
00000046
[  240.381202]  ffff8803125a8000 ffff880310651fd8 ffff880310651fd8 ffff8803=
10651fd8
[  240.381205]  ffffffff81c13420 ffff8803125a8000 ffff880310651c98 7fffffff=
ffffffff
[  240.381208] Call Trace:
[  240.381212]  [<ffffffff81628029>] schedule+0x29/0x70
[  240.381214]  [<ffffffff81625975>] schedule_timeout+0x305/0x380
[  240.381217]  [<ffffffff810bb906>] ? mark_held_locks+0x86/0x140
[  240.381219]  [<ffffffff81629430>] ? _raw_spin_unlock_irq+0x30/0x50
[  240.381222]  [<ffffffff810bbac5>] ? trace_hardirqs_on_caller+0x105/0x190
[  240.381224]  [<ffffffff81627ed2>] wait_for_common+0x122/0x170
[  240.381228]  [<ffffffff81092d90>] ? try_to_wake_up+0x2f0/0x2f0
[  240.381231]  [<ffffffff811c4630>] ? __sync_filesystem+0x90/0x90
[  240.381234]  [<ffffffff811c4630>] ? __sync_filesystem+0x90/0x90
[  240.381236]  [<ffffffff81627ffd>] wait_for_completion+0x1d/0x20
[  240.381238]  [<ffffffff811bd1ae>] sync_inodes_sb+0x12e/0x280
[  240.381241]  [<ffffffff811c4630>] ? __sync_filesystem+0x90/0x90
[  240.381244]  [<ffffffff811c4628>] __sync_filesystem+0x88/0x90
[  240.381246]  [<ffffffff811c464f>] sync_one_sb+0x1f/0x30
[  240.381252]  [<ffffffff81198cf1>] iterate_supers+0xf1/0x100
[  240.381256]  [<ffffffff811c4717>] sys_sync+0x47/0x70
[  240.381260]  [<ffffffff81631f29>] system_call_fastpath+0x16/0x1b
[  240.381263] 1 lock held by fsstress/15251:
[  240.381264]  #0:  (&type->s_umount_key#19){+++++.}, at: [<ffffffff81198c=
88>] iterate_supers+0x88/0x100
[  240.381276] INFO: task xfs_io:15270 blocked for more than 120 seconds.
[  240.381527] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[  240.381724] xfs_io          D 0000000000000002     0 15270  15266 0x0000=
0000
[  240.381727]  ffff8803123b3d68 0000000000000046 0000000000000000 ffff8803=
12ab9fc0
[  240.381730]  ffff880312ab9fc0 ffff8803123b3fd8 ffff8803123b3fd8 ffff8803=
123b3fd8
[  240.381733]  ffff88031458df40 ffff880312ab9fc0 ffff88030c198870 ffff8803=
12ab9fc0
[  240.381736] Call Trace:
[  240.381740]  [<ffffffff81628029>] schedule+0x29/0x70
[  240.381742]  [<ffffffff81628d75>] rwsem_down_failed_common+0xb5/0x150
[  240.381744]  [<ffffffff81628e23>] rwsem_down_write_failed+0x13/0x20
[  240.381751]  [<ffffffff812ed303>] call_rwsem_down_write_failed+0x13/0x20
[  240.381754]  [<ffffffff816271f5>] ? down_write+0x65/0x70
[  240.381757]  [<ffffffff81197ab8>] ? thaw_super+0x28/0xd0
[  240.381759]  [<ffffffff81197ab8>] thaw_super+0x28/0xd0
[  240.381761]  [<ffffffff811a0da5>] ? putname+0x35/0x50
[  240.381765]  [<ffffffff811a7f1c>] do_vfs_ioctl+0x36c/0x560
[  240.381767]  [<ffffffff810bbb5d>] ? trace_hardirqs_on+0xd/0x10
[  240.381769]  [<ffffffff81629c55>] ? retint_swapgs+0x13/0x1b
[  240.381772]  [<ffffffff811a81a1>] sys_ioctl+0x91/0xa0
[  240.381774]  [<ffffffff81631f29>] system_call_fastpath+0x16/0x1b
[  240.381776] 1 lock held by xfs_io/15270:
[  240.381776]  #0:  (&type->s_umount_key#19){+++++.}, at: [<ffffffff81197a=
b8>] thaw_super+0x28/0xd0

--=20
Best Regards,
Artem Bityutskiy

--=-9CgaDcNNbM57iruUOIds
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8ZDUAAoJECmIfjd9wqK030AP/RtohO1QMaXSyqm6IN6A7sWB
Nv63hIXPaKEXDRCoLVoz0l36fNh9+OEsbQKeOlo39viIl2438Gbb+quNdI/zHu/M
irGUKVmcRBFowRp0fOYuBnxVO9d+9kXVoYzmRgundzOsMU2Wz7BVvDd8DVdmNMmg
0D2S7hlE8MmOBZCbsk2N6kQfis1oBdKnM5T8B8wP3uCBLwYeliEdbAzHEkMBSMYL
Apex2Vigx0AnsvAUyFIsjNMJk19Wh5wrYf0nRBvs69sQIed69B8Q75W+BN3Wh8BJ
MqiCT2xR4mhCUD9UyoUmZEULf88AFcmh1KVJBNGFXAxIjuYJ9v6Ci+PWwl8XPGrE
FQUL9i+oGO9xzJtksJ4AE/yf2uDKGnngBxyqekR5DCoJQ4jqpUKS6nmfa8zLmxaK
vOAFqB/7PtVSpZjfbz6y406w05vJ5m7wOQm//oSg9H7Q8EHiAdmKEjuFKIJ00xmI
QNkvbD3vmBKmuLx0K/YEDbYa2EhytV5mRYN2pErDotpCGrRtfjNQJkzxZoZGkvAI
EpD5Id5bySOuIbKmO1oA7VI08vb3LIsDk5UU+CGjNjd6g2ffY1O9S7RqK9ofCBge
gW2Ou5PaPflUfdYJ0tBYhwz2JVVtJ5bYaFrEvCWM4Qpyn7UnOsJPch9tbx4cP1lg
jmdYeCykYgJSaP/ItNnM
=x0zU
-----END PGP SIGNATURE-----

--=-9CgaDcNNbM57iruUOIds--
