From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
Date: Tue, 30 Aug 2011 17:39:44 +0200
Message-ID: <20110830153944.GF16202@quack.suse.cz>
References: <CAFNq8R7dt03bXJUe4gVcZOGRSqJ7uPJHTFeXoaGTu2pKuNBCfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Li Haifeng <omycle@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1H3Pjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 11:39:46 -0400
Content-Disposition: inline
In-Reply-To: <CAFNq8R7dt03bXJUe4gVcZOGRSqJ7uPJHTFeXoaGTu2pKuNBCfw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-08-11 20:11:28, Li Haifeng wrote:
> I am sorry, the last patch "fix the outdated comment in
> ext2_nfs_get_inode()" has some " whitespace errors detected". So
> correct it and remake it.
> 
> I will be more careful later.
  Hmm, your patch still has mangled whitespaces and wrapped long lines.
Please make sure your mailer doesn't do it or use git send-email to send
patches. Also the subject line misses "ext2:" in the beginning (after
[PATCH]). Finally, I've further changed the text in the comment because
"And" does not really make sense in that context to me. The patch I now
carry in my tree is below.

								Honza

>From 8e871fa6a2db8ec615614e547d95de21f9045a52 Mon Sep 17 00:00:00 2001
From: Li Haifeng <omycle@gmail.com>
Date: Tue, 30 Aug 2011 17:32:50 +0200
Subject: [PATCH] ext2: fix the outdated comment in ext2_nfs_get_inode()

Signed-off-by: Li Haifeng <omycle@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 174782f..adf3cde 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -327,10 +327,10 @@ static struct inode *ext2_nfs_get_inode(struct super_block *sb,
 	if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
 		return ERR_PTR(-ESTALE);
 
-	/* iget isn't really right if the inode is currently unallocated!!
-	 * ext2_read_inode currently does appropriate checks, but
-	 * it might be "neater" to call ext2_get_inode first and check
-	 * if the inode is valid.....
+	/*
+	 * ext2_iget isn't quite right if the inode is currently unallocated!
+	 * However ext2_iget currently does appropriate checks to handle stale
+	 * inodes so everything is OK.
 	 */
 	inode = ext2_iget(sb, ino);
 	if (IS_ERR(inode))
-- 
1.7.1
