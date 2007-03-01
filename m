From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 15:23:19 -0500
Message-ID: <45E73637.1000508@garzik.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amit K. Arora wrote:
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
>  
> Persistent preallocation is a file system feature using which an
> application (say, relational database servers) can explicitly
> preallocate blocks to a particular file. This feature can be used to
> reserve space for a file to get mainly the following benefits:
> 1> contiguity - less defragmentation and thus faster access speed, and
> 2> guarantee for a minimum space availibility (depending on how many
> blocks were preallocated) for the file, even if the filesystem becomes
> full.
> 
> XFS already has an implementation for this, using an ioctl interface. And,
> ext4 is now coming up with this feature. In coming time we may see a few
> more file systems implementing this. Thus, it makes sense to have a more
> standard interface for this, like this new system call.
> 
> Here is the initial and incomplete version of the patch, which can be
> used for the discussion, till we come up with a set of more complete
> patches.
> 
> ---
>  arch/i386/kernel/syscall_table.S |    1 +
>  fs/ext4/file.c                   |    1 +
>  fs/open.c                        |   18 ++++++++++++++++++
>  include/asm-i386/unistd.h        |    3 ++-
>  include/linux/fs.h               |    1 +
>  include/linux/syscalls.h         |    1 +
>  6 files changed, 24 insertions(+), 1 deletion(-)

I certainly agree that we want something like this.

posix_fallocate() is the glibc interface we want to be compatible with 
(which your definition is, AFAICS).

	Jeff



