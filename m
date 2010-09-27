From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create permission flags
Date: Mon, 27 Sep 2010 15:14:00 +0200
Message-ID: <201009271514.00279.agruen@suse.de>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115423.530813c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab0I0NOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 09:14:03 -0400
In-Reply-To: <20100924115423.530813c3@tlielax.poochiereds.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 24 September 2010 17:54:23 Jeff Layton wrote:
> On Fri, 24 Sep 2010 18:18:11 +0530 
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > @@ -2415,7 +2418,7 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
> >  	if (!inode)
> >  		return -ENOENT;
> >  
> > -	error = may_create(dir, new_dentry);
> > +	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
> 
> 						^^^^ this is a little
> 						scary, but even if it's
> 						a directory, it'll get
> 						kicked out in a later
> 						check. Would it be
> 						clearer to move up the
> 						S_ISDIR() check in this
> 						function and then pass
> 						this in as false?

Ah, you mean this:

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2450,7 +2450,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (!inode)
 		return -ENOENT;
 
-	error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+	error = may_create(dir, new_dentry, 0);
 	if (error)
 		return error;
 
@@ -2464,8 +2466,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 		return -EPERM;
 	if (!dir->i_op->link)
 		return -EPERM;
-	if (S_ISDIR(inode->i_mode))
-		return -EPERM;
 
 	error = security_inode_link(old_dentry, dir, new_dentry);
 	if (error)

This is a clear improvement; I don't think it matters that user-space will
get -EPERM instead of -EXDEV when trying to hard-link a directory across
devices.

Thanks,
Andreas
