From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 22:44:16 +0000
Message-ID: <1172789056.11165.42.camel@kleikamp.austin.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com>
	 <20070301142537.b5950cd7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36611 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161043AbXCAWoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2007 17:44:19 -0500
In-Reply-To: <20070301142537.b5950cd7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
> On Fri, 2 Mar 2007 00:04:45 +0530
> "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> > +asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
> > +{
> > +	struct file *file;
> > +	struct inode *inode;
> > +	long ret = -EINVAL;
> > +	file = fget(fd);
> > +	if (!file)
> > +		goto out;
> > +	inode = file->f_path.dentry->d_inode;
> > +	if (inode->i_op && inode->i_op->fallocate)
> > +		ret = inode->i_op->fallocate(inode, offset, len);
> > +	else
> > +		ret = -ENOTTY;
> > +	fput(file);
> > +out:
> > +        return ret;
> > +}
> 

> ENOTTY is a bit unconventional - we often use EINVAL for this sort of
> thing.  But EINVAL has other meanings for posix_fallocate() and isn't
> really appropriate here anyway.  So I'm not sure what would be better...

Would EINVAL (or whatever) make it back to the caller of
posix_fallocate(), or would glibc fall back to its current
implementation?

Forgive me if I haven't put enough thought into it, but would it be
useful to create a generic_fallocate() that writes zeroed pages for any
non-existent pages in the range?  I don't know how glibc currently
implements posix_fallocate(), but maybe the kernel could do it more
efficiently, even in generic code.  Maybe we don't care, since the major
file systems can probably do something better in their own code.
-- 
David Kleikamp
IBM Linux Technology Center
