From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext3: Always set dx_node's fake_dirent explicitly.
Date: Fri, 04 Mar 2011 16:04:08 -0600
Message-ID: <4D7161D8.8010509@redhat.com>
References: <4D71615D.30306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Lachlan McIlroy <lmcilroy@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1CDWEM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Mar 2011 17:04:12 -0500
In-Reply-To: <4D71615D.30306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(crossport of 1f7bebb9e911d870fa8f997ddff838e82b5715ea
by Andreas Schlick <schlick@lavabit.com>)

When ext3_dx_add_entry() has to split an index node, it has to ensure that
name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
won't recognise it as an intermediate htree node and consider the htree to
be corrupted.
    
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(V2: fix subject and commit and formatting)

While it's a simple one liner, this took me forever to (re-)find.

kill_ext3_now++;

That is all. ;)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index b27ba71..75c968e 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1540,8 +1540,8 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
+		memset(&node2->fake, 0, sizeof(struct fake_dirent));
 		node2->fake.rec_len = ext3_rec_len_to_disk(sb->s_blocksize);
-		node2->fake.inode = 0;
 		BUFFER_TRACE(frame->bh, "get_write_access");
 		err = ext3_journal_get_write_access(handle, frame->bh);
 		if (err)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

