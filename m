From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart V2
Date: Wed, 26 May 2010 15:51:24 +0400
Message-ID: <87pr0ilw3n.fsf_-_@openvz.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org> <87632ckqcy.fsf@openvz.org>
	<20100525214447.GA14530@thunk.org> <87hblvqb6c.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47390 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0EZLv3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 07:51:29 -0400
Received: by fxm5 with SMTP id 5so4302998fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 04:51:27 -0700 (PDT)
In-Reply-To: <87hblvqb6c.fsf@openvz.org> (Dmitry Monakhov's message of "Wed,
	26 May 2010 13:12:11 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> tytso@mit.edu writes:
>
>> On Tue, May 25, 2010 at 06:28:29PM +0400, Dmitry Monakhov wrote:
>>> tytso@mit.edu writes:
>>> 
>>> > On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
>>> >> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>>> >>  out:
>>> >>  	ext4_ext_drop_refs(path);
>>> >>  	kfree(path);
>>> >> +	if (err == EAGAIN) {
>>> >
>>> > Surely this should be "err == -EAGAIN", no?  I'm curious how this
>>> > patch worked for with this typo....
>>> As usually it fix one thing, and broke another :(.
>>> So in case of alloc/truncate restart truncate will be aborted,
>>> so i_size != i_disk_size which must be caught by fsck (my test run
>>> it every time) but this never happens which is very strange.
> Ohh i ment to say blocks beyond i_disk_size due to aborted truncate.
>> What test case are you using?  And does it require a system crash to
>> show up, or are you seeing an fsck problem after the test completes
>> and you unmount the file system?
> crash is not required.
> I use proposed xfsqa tests from the bug, may be i've changed some 
> numbers, but core idea stays the same.
> mount /dev/sdb1 /mnt
> fsstress ..... &
> sleep 300; killall -9 fsstress
> umount /mnt
> fsck -f /dev/sdb1
> After you have spotted the mistypo i've add explicit fault injection 
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -98,9 +98,15 @@ static int ext4_ext_truncate_extend_restart(handle_t
>>> > *handle,                                            int needed)
>  {
>         int err;
> +       static int fault = 0;
>
>         if (!ext4_handle_valid(handle))
>                 return 0;
> +       if (inode->i_size % 1234 == 0 && fault++ % 2) {
> +               printk("EXT4 TRUNC fault inject inode:%ld\n",inode->i_ino);
> +               dump_stack();
> +               return -EAGAIN;
> +       }
>
> And i've got complain from fsck about incorrect i_size which should be
> increased due to block beyond i_disk_size as expected.
> And when i've fixed the mistypo i've had different complain due to
> bitmap  difference.
This is more than just a bad luck, seems what my brain wasn't enabled
yesterday and at the time i wrote the patch.
I've added 'again' label but forgot to reinitialize "i" variable to zero
again :( . Sorry for wasting you time for this sort of foolishness.
Now it is pass all my tests:
1) fsstress -p100
2) fsstress -p100 with fault injection from journal_restart.
See correct version attached. 

--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-restart-ext4_ext_remove_space-after-transaction.patch

>From da147cf458b2b68486b063725afa2d2a2f8d6e2e Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Wed, 26 May 2010 15:37:03 +0400
Subject: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart v2

If i_data_sem was internally dropped due to transaction restart, it is
necessary to restart path look-up because extents tree was possibly
modified by ext4_get_block().

https://bugzilla.kernel.org/show_bug.cgi?id=15827

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3b63837..36e6a32 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1162,6 +1162,7 @@ enum {
 	EXT4_STATE_DA_ALLOC_CLOSE,	/* Alloc DA blks on close */
 	EXT4_STATE_EXT_MIGRATE,		/* Inode is migrating */
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
+	EXT4_STATE_EXT_TRUNC,		/* truncate is in progress, modified under i_data_sem */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field)					\
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c7c304f..3321f57 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -107,11 +107,8 @@ static int ext4_ext_truncate_extend_restart(handle_t *handle,
 	if (err <= 0)
 		return err;
 	err = ext4_truncate_restart_trans(handle, inode, needed);
-	/*
-	 * We have dropped i_data_sem so someone might have cached again
-	 * an extent we are going to truncate.
-	 */
-	ext4_ext_invalidate_cache(inode);
+	if (!err && !ext4_test_inode_state(inode, EXT4_STATE_EXT_TRUNC))
+		err = -EAGAIN;
 
 	return err;
 }
@@ -2359,7 +2356,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	int depth = ext_depth(inode);
 	struct ext4_ext_path *path;
 	handle_t *handle;
-	int i = 0, err = 0;
+	int i, err = 0;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2368,12 +2365,16 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
+again:
 	ext4_ext_invalidate_cache(inode);
 
 	/*
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
+	i = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_EXT_TRUNC);
+	depth = ext_depth(inode);
 	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
@@ -2478,6 +2479,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	if (err == -EAGAIN) {
+		err = 0;
+		goto again;
+	}
+	ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC);
 	ext4_journal_stop(handle);
 
 	return err;
@@ -3327,6 +3333,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	ext_debug("blocks %u/%u requested for inode %lu\n",
 		  map->m_lblk, map->m_len, inode->i_ino);
 
+	if (unlikely((flags & EXT4_GET_BLOCKS_CREATE)) &&
+		ext4_test_inode_state(inode, EXT4_STATE_EXT_TRUNC))
+		ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC);
 	/* check in cache */
 	cache_type = ext4_ext_in_cache(inode, map->m_lblk, &newex);
 	if (cache_type) {
-- 
1.6.6.1


--=-=-=--
