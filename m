From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V7 00/23] ext4: Add inline data support
Date: Mon, 10 Dec 2012 10:02:28 -0500
Message-ID: <20121210150228.GA28666@thunk.org>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
 <20121206173022.GE30273@thunk.org>
 <50C147A0.4070109@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37739 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2LJPCc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 10:02:32 -0500
Content-Disposition: inline
In-Reply-To: <50C147A0.4070109@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 07, 2012 at 09:34:24AM +0800, Tao Ma wrote:
> I think ext4_inode->xattr_sem should protect us? When we do xattr
> corresponding operation, we just do
> down_write/read(&EXT4_I(inode)->xattr_sem), so we should be fine with
> this type of operation. Am I missing something here?

We're not taking the xattr_sem in ext4_find_inline_data() before we
call ext4_xattr_ibody_find().  So I think we need something like this:

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 6b600b4..e96268d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -143,7 +143,9 @@ int ext4_find_inline_data(struct inode *inode)
 	if (error)
 		return error;
 
+	down_read(&EXT4_I(inode)->xattr_sem);
 	error = ext4_xattr_ibody_find(inode, &i, &is);
+	up_read(&EXT4_I(inode)->xattr_sem);
 	if (error)
 		goto out;
 


					- Ted
