From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
 ext4_forget()
Date: Sun, 15 Nov 2009 12:34:48 +0530
Message-ID: <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
References: <20091114232912.GF4221@mit.edu>
 <1258245059-17687-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57253 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZKOHEy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 02:04:54 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id nAF74rQl012252
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 12:34:53 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAF74qbM2642134
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 12:34:52 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nAF74pSA004398
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 12:34:52 +0530
Content-Disposition: inline
In-Reply-To: <1258245059-17687-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 14, 2009 at 07:30:59PM -0500, Theodore Ts'o wrote:
> When a directory gets unlinked, ext4_forget() is called on any buffer
> heads corresponding to its data blocks.  Data blocks from directories
> must be treated as metadata, so that they are revoked by
> jbd2_journal_revoke, and not just forgotten via ext4_journal_forget().
> 
> Thanks to Curt Wohlgemuth for pointing out potential problems in this
> area.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 13de1dd..639bb84 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -97,6 +97,10 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
>  		  bh, is_metadata, inode->i_mode,
>  		  test_opt(inode->i_sb, DATA_FLAGS));
> 
> +	/* Directory blocks must be treated as metadata */
> +	if (S_ISDIR(inode->i_mode))
> +		is_metadata = 1;
> +
>  	/* Never use the revoke function if we are doing full data
>  	 * journaling: there is no need to, and a V1 superblock won't
>  	 * support it.  Otherwise, only skip the revoke on un-journaled

I guess we need to make sure we call ext4_forget with correct is_metadata values. I
did the below patch. The xattr changes in the patch should be split as a separate one.
I am not sure why we do a get_bh there.

Another question i have is, do we actually supporting freeing directory blocks 
when we delete directory entries ? I remember reading we don't have support for that.
So may be Curt is not seeing the ext4_forget being called because he is trying delete
of directory entries. I guess he will have to do a rmdir directory to see the
directory blocks freed.

If you think the changes are correct i will send proper patches with s-o-b

-aneesh

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 715264b..74dcff8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2074,7 +2074,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		ext_debug("free last %u blocks starting %llu\n", num, start);
 		for (i = 0; i < num; i++) {
 			bh = sb_find_get_block(inode->i_sb, start + i);
-			ext4_forget(handle, 0, inode, bh, start + i);
+			ext4_forget(handle, metadata, inode, bh, start + i);
 		}
 		ext4_free_blocks(handle, inode, start, num, metadata);
 	} else if (from == le32_to_cpu(ex->ee_block)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2c8caa5..87232a5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -96,6 +96,13 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
+	/*
+	 * The caller should have set is_metadata properly. But
+	 * being extra careful here
+	 */
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+		is_metadata = 1;
+
 	/* Never use the revoke function if we are doing full data
 	 * journaling: there is no need to, and a V1 superblock won't
 	 * support it.  Otherwise, only skip the revoke on un-journaled
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index fed5b01..3c93a9a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -482,9 +482,8 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		ea_bdebug(bh, "refcount now=0; freeing");
 		if (ce)
 			mb_cache_entry_free(ce);
-		ext4_free_blocks(handle, inode, bh->b_blocknr, 1, 1);
-		get_bh(bh);
 		ext4_forget(handle, 1, inode, bh, bh->b_blocknr);
+		ext4_free_blocks(handle, inode, bh->b_blocknr, 1, 1);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
