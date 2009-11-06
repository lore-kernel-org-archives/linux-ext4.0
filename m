From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext4: journal superblock modifications in ext4_statfs()
Date: Fri, 06 Nov 2009 16:33:13 -0600
Message-ID: <4AF4A429.7090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbZKFWdK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 17:33:10 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA6MXGRR031089
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 17:33:16 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nA6MXCxS009895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 17:33:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit a71ce8c6c9bf269b192f352ea555217815cf027e updated
ext4_statfs() to update the on-disk superblock counters,
but modified this buffer directly without any journaling of
the change.  This is one of the accesses that was causing 
the crc errors in journal replay as seen in kernel.org 
bugzilla #14354.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 08370ae..b02daf6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3605,6 +3605,8 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	u64 fsid;
+	handle_t *handle;
+	int err = 0;
 
 	if (test_opt(sb, MINIX_DF)) {
 		sbi->s_overhead_last = 0;
@@ -3650,20 +3652,33 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
 		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
-	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 
-	return 0;
+	handle = ext4_journal_start_sb(sb, 1);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out;
+	}
+	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
+	if (err)
+		goto journal_stop;
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
+	ext4_free_blocks_count_set(es, buf->f_bfree);
+	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
+
+journal_stop:
+	ext4_journal_stop(handle);
+out:
+	return err;
 }
 
 /* Helper function for writing quotas on sync - we need to start transaction

