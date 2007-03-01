From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 23:09:30 +0000
Message-ID: <1172790570.11165.62.camel@kleikamp.austin.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com>
	 <20070301142537.b5950cd7.akpm@linux-foundation.org>
	 <1172789056.11165.42.camel@kleikamp.austin.ibm.com>
	 <20070301145949.3efac328.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070301145949.3efac328.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-03-01 at 14:59 -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 22:44:16 +0000
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
> > > On Fri, 2 Mar 2007 00:04:45 +0530
> > > "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > 
> > > > +asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len)
> > > > +{
> > > > +	struct file *file;
> > > > +	struct inode *inode;
> > > > +	long ret = -EINVAL;
> > > > +	file = fget(fd);
> > > > +	if (!file)
> > > > +		goto out;
> > > > +	inode = file->f_path.dentry->d_inode;
> > > > +	if (inode->i_op && inode->i_op->fallocate)
> > > > +		ret = inode->i_op->fallocate(inode, offset, len);
> > > > +	else
> > > > +		ret = -ENOTTY;
> > > > +	fput(file);
> > > > +out:
> > > > +        return ret;
> > > > +}
> > > 
> > 
> > > ENOTTY is a bit unconventional - we often use EINVAL for this sort of
> > > thing.  But EINVAL has other meanings for posix_fallocate() and isn't
> > > really appropriate here anyway.  So I'm not sure what would be better...
> > 
> > Would EINVAL (or whatever) make it back to the caller of
> > posix_fallocate(), or would glibc fall back to its current
> > implementation?
> > 
> > Forgive me if I haven't put enough thought into it, but would it be
> > useful to create a generic_fallocate() that writes zeroed pages for any
> > non-existent pages in the range?  I don't know how glibc currently
> > implements posix_fallocate(), but maybe the kernel could do it more
> > efficiently, even in generic code.  Maybe we don't care, since the major
> > file systems can probably do something better in their own code.
> 
> Given that glibc already implements fallocate for all filesystems, it will
> need to continue to do so for filesystems which don't implement this
> syscall - otherwise applications would start breaking.

I didn't make it clear, but my point was to call generic_fallocate if
the file system did not define i_op->allocate().

if (inode->i_op && inode->i_op->fallocate)
	ret = inode->i_op->fallocate(inode, offset, len);
else
	ret = generic_fallocate(inode, offset, len);

I'm not sure it's worth the effort, but I thought I'd throw the idea out
there.

-- 
David Kleikamp
IBM Linux Technology Center

