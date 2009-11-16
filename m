From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: Don't update the superblock in ext3_statfs()
Date: Mon, 16 Nov 2009 16:34:51 -0600
Message-ID: <4B01D38B.9000506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZKPWev (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 17:34:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit a71ce8c6c9bf269b192f352ea555217815cf027e updated ext3_statfs()
to update the on-disk superblock counters, but modified this buffer
directly without any journaling of the change.  This is one of the
accesses that was causing the crc errors in journal replay as seen in
kernel.org bugzilla #14354.

The modifications were originally to keep the sb "more" in sync,
so that a readonly fsck of the device didn't flag this as an
error (as often), but apparently e2fsprogs deals with this differently
now, anyway.

Based on Ted's patch for ext4, which was in turn based on my
work on that bug and another preliminary patch...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 427496c..ca3068f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2686,13 +2686,11 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
-	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));

