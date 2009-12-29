From: HaiBo Liu <haiboliu6@gmail.com>
Subject: a ext2 =?utf-8?b?cmVhZF9sb2Nr?= question
Date: Tue, 29 Dec 2009 14:53:31 +0000 (UTC)
Message-ID: <loom.20091229T152431-950@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42587 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbZL2PAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Dec 2009 10:00:13 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NPdYM-0004yI-Ct
	for linux-ext4@vger.kernel.org; Tue, 29 Dec 2009 16:00:06 +0100
Received: from 47.216.60.58.broad.sz.gd.dynamic.163data.com.cn ([47.216.60.58.broad.sz.gd.dynamic.163data.com.cn])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 16:00:06 +0100
Received: from haiboliu6 by 47.216.60.58.broad.sz.gd.dynamic.163data.com.cn with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 16:00:06 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,All.
I am a newer to linux kernel.I have a question about the ext2_get_branch.

static Indirect *ext2_get_branch(struct inode *inode,
				 int depth,
				 int *offsets,
				 Indirect chain[4],
				 int *err)
{
	struct super_block *sb = inode->i_sb;
	Indirect *p = chain;
	struct buffer_head *bh;

	*err = 0;
	/* i_data is not going away, no lock needed */
	add_chain (chain, NULL, EXT2_I(inode)->i_data + *offsets);
	if (!p->key)
		goto no_block;
	while (--depth) {
		bh = sb_bread(sb, le32_to_cpu(p->key));
		if (!bh)
			goto failure;
		read_lock(&EXT2_I(inode)->i_meta_lock);
		if (!verify_chain(chain, p))
			goto changed;
		add_chain(++p, bh, (__le32*)bh->b_data + *++offsets);
		read_unlock(&EXT2_I(inode)->i_meta_lock);
		if (!p->key)
			goto no_block;
	}
	return NULL;

changed:
	read_unlock(&EXT2_I(inode)->i_meta_lock);
	brelse(bh);
	*err = -EAGAIN;
	goto no_block;
failure:
	*err = -EIO;
no_block:
	return p;
}

Can it be changed like this?:

static Indirect *ext2_get_branch(struct inode *inode,
				 int depth,
				 int *offsets,
				 Indirect chain[4],
				 int *err)
{
	struct super_block *sb = inode->i_sb;
	Indirect *p = chain;
	struct buffer_head *bh;

	*err = 0;
	/* i_data is not going away, no lock needed */
	add_chain (chain, NULL, EXT2_I(inode)->i_data + *offsets);
	if (!p->key)
		goto no_block;
	while (--depth) {
		bh = sb_bread(sb, le32_to_cpu(p->key));
		if (!bh)
			goto failure;
-		read_lock(&EXT2_I(inode)->i_meta_lock);
		if (!verify_chain(chain, p))
			goto changed;
		add_chain(++p, bh, (__le32*)bh->b_data + *++offsets);
-		read_unlock(&EXT2_I(inode)->i_meta_lock);
		if (!p->key)
			goto no_block;
	}
+      read_lock(&EXT2_I(inode)->i_meta_lock);	
+      if (!verify_chain(chain, p))
+		goto changed;
+	add_chain(++p, bh, (__le32*)bh->b_data + *++offsets);
	return NULL;

changed:
-	read_unlock(&EXT2_I(inode)->i_meta_lock);
	brelse(bh);
	*err = -EAGAIN;
	goto no_block;
failure:
	*err = -EIO;
no_block:
	return p;
}

I think in the while loop it doesn't need read_lock.When verify_chain() is doing
the verify , a writer change the content,the verity_chain will find the change
or at last the change will be found out of the while loop.


