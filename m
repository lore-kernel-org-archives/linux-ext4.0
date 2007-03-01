From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 14:25:37 -0800
Message-ID: <20070301142537.b5950cd7.akpm@linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2 Mar 2007 00:04:45 +0530
"Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> This is to give a heads up on few patches that we will be soon coming up
> with. These patches implement a new system call sys_fallocate() and a
> new inode operation "fallocate", for persistent preallocation. The new
> system call, as Andrew suggested, will look like:
> 
>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);

It is intended that glibc use this same syscall for both posix_fallocate()
and posix_fallocate64().

I'd agree with Eric on the "command" flag extension.

That new argument might need to come after "fd" - ARM has funny requirements on
syscall arg padding and layout.

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

Please always put a blank line between the variable definitions and the
first statement.

Please always use hard tabs, not bunch-of-spaces.  This seems to happening
rather a lot in the ext4 patches.  It's a trivial thing, but also trivial
to fix.  A grep across the diffs is needed.

ENOTTY is a bit unconventional - we often use EINVAL for this sort of
thing.  But EINVAL has other meanings for posix_fallocate() and isn't
really appropriate here anyway.  So I'm not sure what would be better...

