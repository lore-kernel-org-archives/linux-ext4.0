From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 23:36:28 +0000
Message-ID: <20070301233628.GA31072@infradead.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42826 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250AbXCAXge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2007 18:36:34 -0500
Content-Disposition: inline
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 02, 2007 at 12:04:45AM +0530, Amit K. Arora wrote:
> This is to give a heads up on few patches that we will be soon coming up
> with. These patches implement a new system call sys_fallocate() and a
> new inode operation "fallocate", for persistent preallocation. The new
> system call, as Andrew suggested, will look like:
> 
>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> 
> As we are developing and testing the required patches, we decided to
> post a preliminary patch and get inputs from the community to give it
> a right direction and shape. First, a little description on the feature.

Thanks a lot, this has been long overdue.

Please don't forget to Cc the XFS list to keep developers of the only
Linux filesystem supporting persistant allocations for a long time :)

Various people will beat you up for the above syscall as lots of
architectures really want 64bit arguments aligned in a proper way,
e.g. you at least need a pad after 'int fd'.  Then again I already
have suggestions for filling up that slot with useful information:

 - you really want a whence argument as to lseek, as it makes a lot
   of sense for applications to allocate from the end of the file
   or the current file positions.  The existing XFS ioctl already
   has this, and it's trivial to support this in any preallocation
   implementation I could imagine.
 - we should think about having a flag value for which kind of preallocation
   we want.  XFS currently has two:

	ALLOCSP which updates the inode size and physically zeroes blocks
	RESVSP which does not update inode size but creates and unwritten
	       extent

   the current posix_fallocate semantics are somewhere in the middle, as
   it requires and update to the inode size, but does not specify at
   all what happens if you read from the newly allocated space.
   And yes, as and heads up to developers implementing this feature
   on new filesystems: don't just return new blocks, that's a gapping
   security hole :)

> +asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
> +{
> +	struct file *file;
> +	struct inode *inode;
> +	long ret = -EINVAL;
> +	file = fget(fd);
> +	if (!file)
> +		goto out;
> +	inode = file->f_path.dentry->d_inode;
> +	if (inode->i_op && inode->i_op->fallocate)
> +		ret = inode->i_op->fallocate(inode, offset, len);
> +	else
> +		ret = -ENOTTY;
> +	fput(file);
> +out:
> +        return ret;
> +}

This should use fget_light, and I'm sure the code could be written
in a slightly more readable:

asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
{
	struct file *file = fget(fd);
	 ret = -EINVAL;

	if (file)
		struct inode *inode = file->f_path.dentry->d_inode;
		if (inode->i_op && inode->i_op->fallocate)
			ret = inode->i_op->fallocate(inode, offset, len);
		else
			ret = -ENOTTY;
		fput(file);
	}

	return ret;
}

p.s. you reference ext4_fallocate in the patch but don't actually
introduce it, it definitively won't compile as-is :)
