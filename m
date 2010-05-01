From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH] Prevent creation of files larger than RLIMIT_FSIZE
	using fallocate
Date: Sat, 1 May 2010 12:34:26 +0530
Message-ID: <20100501070426.GA9562@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de> <201004291014.07194.knikanth@suse.de> <20100430143319.d51d6d77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coly.li@suse.de, Nick Piggin <npiggin@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eelis <opensuse.org@contacts.eelis.net>,
	Amit Arora <aarora@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nikanth Karthikesan <knikanth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55110 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab0EAHEg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 May 2010 03:04:36 -0400
Content-Disposition: inline
In-Reply-To: <20100430143319.d51d6d77.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 30, 2010 at 02:33:19PM -0700, Andrew Morton wrote:
> 
> (Amit Arora <aarora@in.ibm.com> wrote fallocate.  cc added)

Thanks for adding me to CC.
 
> On Thu, 29 Apr 2010 10:14:06 +0530
> Nikanth Karthikesan <knikanth@suse.de> wrote:
> 
> > Here is an updated patch that takes the i_mutex and calls inode_newsize_ok()
> > only for regular files.
> 
> err, no.  It's taking i_lock where it meant to take i_mutex.
> 
> > Thanks
> > Nikanth
> > 
> > +	if (S_ISREG(inode->i_mode)) {
> > +		spin_lock(&inode->i_lock);
> > +		ret = inode_newsize_ok(inode, (offset + len));
> > +		spin_unlock(&inode->i_lock);
> > +		if (ret)
> > +			return ret;
> > +	} else if (S_ISDIR(inode->i_mode)) {
> > +		/*
> > +		 * Let individual file system decide if it supports
> > +		 * preallocation for directories or not.
> > +		 */
> > +		if (offset > inode->i_sb->s_maxbytes)
> > +			return -EFBIG;
> > +	} else
> > +		return -ENODEV;
> > +
> >  	if (!inode->i_op->fallocate)
> >  		return -EOPNOTSUPP;
> 
> Also, there doesn't seem to be much point in doing
> 
> 	mutex_lock(i_mutex);
> 	if (some_condition)
> 		bale out
> 	mutex_unlock(i_mutex);
> 
> 	<stuff>
> 
> because `some_condition' can now become true before or during the
> execution of `stuff'.
> 
> IOW, it's racy.

Agreed. How about doing this check in the filesystem specific fallocate
inode routines instead ? For example, in ext4 we could do :

diff -Nuarp linux-2.6.org/fs/ext4/extents.c linux-2.6.new/fs/ext4/extents.c
--- linux-2.6.org/fs/ext4/extents.c	2010-05-01 12:16:07.000000000 +0530
+++ linux-2.6.new/fs/ext4/extents.c	2010-05-01 12:17:37.000000000 +0530
@@ -3672,6 +3672,11 @@ long ext4_fallocate(struct inode *inode,
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+	ret = inode_newsize_ok(inode, (offset + len));
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
+	}
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		block = block + ret;


Similarly for ocfs2, btrfs and xfs..

--
Regards,
Amit Arora
