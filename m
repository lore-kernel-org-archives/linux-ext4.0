From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been remounted readonly
Date: Wed, 24 Feb 2010 19:01:27 +0300
Message-ID: <877hq2tyg8.fsf@openvz.org>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
	<baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
	<20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
	<baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
	<20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49570 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab0BXQBc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 11:01:32 -0500
In-Reply-To: <20100223135531.GA7699@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Tue, 23 Feb 2010 16:55:31 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Jan Kara <jack@suse.cz> writes:

>> The fact is that I've been able to reproduce the problem on LVM block
>> devices, and sd* block devices so it's definitely not a loop device
>> specific problem.
>> 
>> By the way, I tried several other things other than "echo s
>> >/proc/sysrq_trigger" I tried multiple sync followed with a one minute
>> "sleep",
>> 
>> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
>> changes" but doesn't stops them.
>   Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
> /dev/loop0, I cannot reproduce the problem (was running the script for
> something like an hour).
Theoretically some pages may exist after rw=>ro remount
because of generic race between write/sync, And they will be written
in by writepage if page already has buffers. This not happen in ext4
because. Each time it try to perform writepages it try to start_journal
and this result in EROFS.
The race bug will be closed some day but new one may appear again.

Let's be honest and change ext3 writepage like follows:
- check ROFS flag inside write page
- dump writepage's errors.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext3-add-sanity-checks-to-writeback.patch

>From a7cadf8017626cd80fcd8ea5a0e4deff4f63e02e Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 24 Feb 2010 18:17:58 +0300
Subject: [PATCH] ext3: add sanity checks to writeback

There is theoretical possibility to perform writepage on
RO superblock. Add explicit check for what case.

In fact writepage may fail by a number of reasons.
This is really rare case but sill may result in data loss.
At least we have to dump a error message.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 455e6e6..cf0e3aa 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1536,6 +1536,11 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		err = -EROFS;
+		goto out_fail;
+	}
+
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1546,7 +1551,8 @@ static int ext3_ordered_writepage(struct page *page,
 				       NULL, buffer_unmapped)) {
 			/* Provide NULL get_block() to catch bugs if buffers
 			 * weren't really mapped */
-			return block_write_full_page(page, NULL, wbc);
+			ret = block_write_full_page(page, NULL, wbc);
+			goto out;
 		}
 	}
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
@@ -1584,12 +1590,17 @@ static int ext3_ordered_writepage(struct page *page,
 	err = ext3_journal_stop(handle);
 	if (!ret)
 		ret = err;
+out:
+	if (ret)
+		ext3_msg(inode->i_sb, KERN_CRIT, "%s: failed "
+			"%ld pages, ino %lu; err %d\n", __func__,
+			wbc->nr_to_write, inode->i_ino, ret);
 	return ret;
 
 out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
-	return ret;
+	goto out;
 }
 
 static int ext3_writeback_writepage(struct page *page,
@@ -1603,12 +1614,18 @@ static int ext3_writeback_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		err = -EROFS;
+		goto out_fail;
+	}
+
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0,
 				      PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
 			/* Provide NULL get_block() to catch bugs if buffers
 			 * weren't really mapped */
-			return block_write_full_page(page, NULL, wbc);
+			ret = block_write_full_page(page, NULL, wbc);
+			goto out;
 		}
 	}
 
@@ -1626,12 +1643,17 @@ static int ext3_writeback_writepage(struct page *page,
 	err = ext3_journal_stop(handle);
 	if (!ret)
 		ret = err;
+out:
+	if (ret)
+		ext3_msg(inode->i_sb, KERN_CRIT, "%s: failed "
+			"%ld pages, ino %lu; err %d\n", __func__,
+			wbc->nr_to_write, inode->i_ino, ret);
 	return ret;
 
 out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
-	return ret;
+	goto out;
 }
 
 static int ext3_journalled_writepage(struct page *page,
@@ -1645,6 +1667,11 @@ static int ext3_journalled_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto no_write;
 
+	if (inode->i_sb->s_flags & MS_RDONLY) {
+		err = -EROFS;
+		goto no_write;
+	}
+
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1684,8 +1711,11 @@ static int ext3_journalled_writepage(struct page *page,
 	if (!ret)
 		ret = err;
 out:
+	if (ret)
+		ext3_msg(inode->i_sb, KERN_CRIT, "%s: failed "
+			"%ld pages, ino %lu; err %d\n", __func__,
+			wbc->nr_to_write, inode->i_ino, ret);
 	return ret;
--=-=-=--
