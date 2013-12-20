From: Abbas Raza <abbas_raza@mentor.com>
Subject: [PATCH 2/2] ext4: handle mount failures more gracefully
Date: Sat, 21 Dec 2013 03:59:17 +0500
Message-ID: <1387580357-28440-2-git-send-email-abbas_raza@mentor.com>
References: <1387580357-28440-1-git-send-email-abbas_raza@mentor.com>
Cc: Abbas Raza <Abbas_Raza@mentor.com>, Theodore Ts'o <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1387580357-28440-1-git-send-email-abbas_raza@mentor.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Abbas Raza <Abbas_Raza@mentor.com>

ext4 code throws WARNINGs if a mounted card having ext4 filesystem is
ejected without unmounting first and inserted again. This happens because
ext4 procfs entries for this card doesn't get cleaned when it is ejected
this way.

Steps to reproduce this problem:
1) card having ext4 filesystem is already mounted:
root@mx6q:~# mount
/dev/mmcblk0p1 on /media/sd-mmcblk0p1 type ext4 (rw,relatime,data=ordered)

2) cd <mount point>
root@mx6q:~# cd /media/sd-mmcblk0p1/
root@mx6q:/media/sd-mmcblk0p1#
root@mx6q:/media/sd-mmcblk0p1# ls /proc/fs/ext4/
mmcblk0p1
root@mx6q:/media/sd-mmcblk0p1#

3) Remove card:
root@mx6q:/media/sd-mmcblk0p1#
[  165.167264] mmc1: card efa2 removed

4) Proc entries for the removed card are still present:
root@mx6q:/media/sd-mmcblk0p1# ls /proc/fs/ext4/
mmcblk0p1

5) Re-insert card (mount will fail with a following warnings):
root@mx6q:/media/sd-mmcblk0p1#
[   74.987270] mmc1: new SDHC card at address efa2
[   74.992426] mmcblk0: mmc1:efa2 SD04G 3.69 GiB
[   75.003689]  mmcblk0: p1
[   75.590601] ------------[ cut here ]------------
[   75.595296] WARNING: at fs/proc/generic.c:573 proc_register+0xe8/0x138()
[   75.602013] proc_dir_entry 'ext4/mmcblk0p1' already registered
[   75.607882] Modules linked in: ip_tables x_tables
[   75.662964] Backtrace:
[   75.665500] [<80011734>] (dump_backtrace+0x0/0x10c) from [<803a2eb8>] (dump_stack+0x18/0x1c)
[   75.674005]  r6:80488400 r5:0000023d r4:ac637c60 r3:80508444
[   75.679779] [<803a2ea0>] (dump_stack+0x0/0x1c) from [<80022908>] (warn_slowpath_common+0x54/0x6c)
[   75.688885] [<800228b4>] (warn_slowpath_common+0x0/0x6c) from [<800229c4>] (warn_slowpath_fmt+0x38/0x40)
[   75.698596]  r8:a9968b59 r7:a816b200 r6:00000000 r5:ac1a1c80 r4:a9968b00
r3:00000009
[   75.706615] [<8002298c>] (warn_slowpath_fmt+0x0/0x40) from [<8013b03c>] (proc_register+0xe8/0x138)
[   75.715783]  r3:ac1a1cd9 r2:80488466
[   75.719437] [<8013af54>] (proc_register+0x0/0x138) from [<8013b264>] (proc_mkdir_mode+0x40/0x60)
[   75.728411]  r8:805bac20 r7:ac721800 r6:ac722000 r5:00000000 r4:a9968b00
[   75.735284] [<8013b224>] (proc_mkdir_mode+0x0/0x60) from [<8013b29c>] (proc_mkdir+0x18/0x1c)
[   75.743825]  r4:0000007f
[   75.746399] [<8013b284>] (proc_mkdir+0x0/0x1c) from [<8016f038>] (ext4_fill_super+0xe1c/0x2788)
[   75.755193] [<8016e21c>] (ext4_fill_super+0x0/0x2788) from [<800eae6c>] (mount_bdev+0x124/0x1a0)
[   75.764082] [<800ead48>] (mount_bdev+0x0/0x1a0) from [<8015e740>] (ext4_mount+0x1c/0x28)
[   75.772263] [<8015e724>] (ext4_mount+0x0/0x28) from [<800eb728>] (mount_fs+0x1c/0xc0)
[   75.780160] [<800eb70c>] (mount_fs+0x0/0xc0) from [<80102498>] (vfs_kern_mount+0x54/0xc8)
[   75.788409]  r6:00000000 r5:ac3886c0 r4:acbd4b40
[   75.793102] [<80102444>] (vfs_kern_mount+0x0/0xc8) from [<801045e8>] (do_mount+0x71c/0x834)
[   75.801557]  r8:ac636000 r7:8051f3dc r6:805322c0 r5:ac3886c0 r4:00000020
r3:00000000
[   75.809528] [<80103ecc>] (do_mount+0x0/0x834) from [<8010478c>] (sys_mount+0x8c/0xc0)
[   75.817446] [<80104700>] (sys_mount+0x0/0xc0) from [<8000d860>] (ret_fast_syscall+0x0/0x30)
[   75.825883]  r7:00000015 r6:005956c0 r5:00200000 r4:00000000
[   75.831606] ---[ end trace 041836e4555827df ]---
[   75.839421] ------------[ cut here ]------------
[   75.844096] WARNING: at fs/proc/generic.c:573 proc_register+0xe8/0x138()
[   75.850810] proc_dir_entry 'jbd2/mmcblk0p1-8' already registered
...
[   76.118095] ------------[ cut here ]------------
[   76.122776] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0x9c/0xbc()
[   76.129140] sysfs: cannot create duplicate filename '/fs/ext4/mmcblk0p1'
...
[   76.410445] ------------[ cut here ]------------
[   76.415124] WARNING: at lib/kobject.c:196 kobject_add_internal+0x15c/0x1cc()
[   76.422214] kobject_add_internal failed for mmcblk0p1 with -EEXIST, don't try to register things with the same name in the same directory.
...
[   76.661850] ---[ end trace 041836e4555827e2 ]---
[   76.666572] EXT4-fs (mmcblk0p1): mount failed

With this patch:

5) Re-insert card (mount will fail with following message):
root@mx6q:/media/sd-mmcblk0p1#
root@mx6q:/media/sd-mmcblk0p1# [  171.392220] mmc1: new SDHC card at address efa2
[  171.398608] mmcblk0: mmc1:efa2 SD04G 3.69 GiB
[  171.410501]  mmcblk0: p1
[  171.990337] EXT4-fs (mmcblk0p1): could'nt mount because mount point is busy and /proc/ext4/mmcblk0p1 is already present

6) Free mount point and proc entries for the card will vanish
root@mx6q:/media/sd-mmcblk0p1# cd ..
root@mx6q:/media# ls /proc/fs/ext4/

7) Re-insert card and it will mount successfully:
root@mx6q:/media# [  194.317263] mmc1: card efa2 removed

root@mx6q:/media# [  199.512198] mmc1: new SDHC card at address efa2
[  199.518254] mmcblk0: mmc1:efa2 SD04G 3.69 GiB
[  199.527939]  mmcblk0: p1
[  200.101131] EXT4-fs (mmcblk0p1): recovery complete
[  200.105985] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null)

root@mx6q:/media# ls /proc/fs/ext4/
mmcblk0p1

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Abbas Raza <Abbas_Raza@mentor.com>
---
 fs/ext4/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b83f75d..edb5613 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3708,8 +3708,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	if (ext4_proc_root)
+	if (ext4_proc_root) {
+		if (proc_lookup_subdir_by_name(ext4_proc_root,
+					sb->s_id) == 0) {
+			ext4_msg(sb, KERN_ERR, "could'nt mount because"
+				" mount point is busy and /proc/%s/%s is"
+				" already present",
+					ext4_proc_root->name, sb->s_id);
+			goto failed_mount;
+		}
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
+	}
 
 	if (sbi->s_proc)
 		proc_create_data("options", S_IRUGO, sbi->s_proc,
-- 
1.8.3.2

