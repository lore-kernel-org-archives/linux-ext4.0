From: Olaf Hering <olaf@aepfle.de>
Subject: ext3_dx_add_entry complains about Directory index full
Date: Wed, 4 Feb 2015 10:04:47 +0100
Message-ID: <20150204090447.GA20003@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:41130 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227AbbBDJEt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 04:04:49 -0500
Received: from probook.fritz.box ([2001:a60:1087:7e01:1ec1:deff:feb9:bb48])
	by smtp.strato.de (RZmta 37.2 AUTH)
	with ESMTPSA id t012fbr1494lVXZ
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-ext4@vger.kernel.org>;
	Wed, 4 Feb 2015 10:04:47 +0100 (CET)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


To reduce Jans load I send it here for advice:


Today I got these warnings for the backup partition:

[    0.000000] Linux version 3.18.5 (abuild@build23) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Mon Jan 19 09:08:56 UTC 2015

[102565.308869] kjournald starting.  Commit interval 5 seconds
[102565.315974] EXT3-fs (dm-5): using internal journal
[102565.315980] EXT3-fs (dm-5): mounted filesystem with ordered data mode
[104406.015708] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full!
[104406.239904] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full!
[104406.254162] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full!
[104406.270793] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full!
[104406.287443] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full!

According to google this indicates that the filesystem has more than 32k
subdirectories. According to wikipedia this limit can be avoided by
enabling the dir_index feature. According to dumpe2fs the feature is
enabled already. Does the warning above mean something else?

Jan suggested to create a debug image with "e2image -r /dev/dm-5 - |
xz > ext3-image.e2i.xz", but this creates more than 250G of private data.

I wonder if the math within the kernel is done correctly. If so I will move the
data to another drive and reformat the thing with another filesystem.
If however the math is wrong somewhere, I'm willing to keep it for a while
until the issue is understood.


# dumpe2fs -h /dev/dm-5                                                                                                                                                                                                                                                
dumpe2fs 1.41.14 (22-Dec-2010)
Filesystem volume name:   BACKUP_OLH_500G
Last mounted on:          /run/media/olaf/BACKUP_OLH_500G
Filesystem UUID:          f0d41610-a993-4b77-8845-f0f07e37f61d
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery sparse_super large_file
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              26214400
Block count:              419430400
Reserved block count:     419430
Free blocks:              75040285
Free inodes:              24328812
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         512
Inode blocks per group:   128
Filesystem created:       Tue Feb 12 18:24:13 2013
Last mount time:          Thu Jan 29 09:15:28 2015
Last write time:          Thu Jan 29 09:15:28 2015
Mount count:              161
Maximum mount count:      -1
Last checked:             Mon May 26 10:09:36 2014
Check interval:           0 (<none>)
Lifetime writes:          299 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      55aeb7a2-43ca-4104-ad21-56d7a523dc8f
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             32M
Journal length:           32768
Journal sequence:         0x000a2725
Journal start:            17366



The backup is done with rsnapshot, which uses hardlinks and rsync to create a
new subdir with just the changed files.

# for t in d f l ; do echo "type $t: `find /media/BACKUP_OLH_500G/ -xdev -type $t | wc -l`" ; done
type d: 1051396
type f: 20824894
type l: 6876

With the hack below I got this output:

[14161.626156] scsi 4:0:0:0: Direct-Access     ATA      ST3500418AS      CC45 PQ: 0 ANSI: 5
[14161.626671] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[14161.626762] sd 4:0:0:0: [sdb] Write Protect is off
[14161.626769] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[14161.626810] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[14161.628058] sd 4:0:0:0: Attached scsi generic sg1 type 0
[14161.651340]  sdb: sdb1
[14161.651978] sd 4:0:0:0: [sdb] Attached SCSI disk
[14176.784403] kjournald starting.  Commit interval 5 seconds
[14176.790307] EXT3-fs (dm-5): using internal journal
[14176.790316] EXT3-fs (dm-5): mounted filesystem with ordered data mode
[14596.410693] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full! /hourly.0 localhost/olh/maildir/olh-maildir Maildir/old/xen-devel.old/cur 1422000479.29469_1.probook.fritz.box:2,S
[15335.342389] EXT3-fs (dm-5): warning: ext3_dx_add_entry: Directory index full! /hourly.0 localhost/olh/maildir/olh-maildir Maildir/old/xen-devel.old/cur 1422000479.29469_1.probook.fritz.box:2,S


diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f197736..5022eda 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1525,11 +1525,20 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		struct dx_entry *entries2;
 		struct dx_node *node2;
 		struct buffer_head *bh2;
+		struct dentry *parents = dentry->d_parent;
+		struct dentry *parents2;
+		unsigned int i = 4;
 
 		if (levels && (dx_get_count(frames->entries) ==
 			       dx_get_limit(frames->entries))) {
+			while (parents && i > 0 && parents->d_parent)
+				i--, parents = parents->d_parent;
+			parents2 = parents;
+			i = 4;
+			while (parents2 && i > 0 && parents2->d_parent)
+				i--, parents2 = parents2->d_parent;
 			ext3_warning(sb, __func__,
-				     "Directory index full!");
+				     "Directory index full! %pd4 %pd4 %pd4 %pd", parents2, parents, dentry->d_parent, dentry);
 			err = -ENOSPC;
 			goto cleanup;
 		}


This does not dump the inode yet. I suspect it will point to other hardlinks of the dentry above.


Thanks for reading,

Olaf
