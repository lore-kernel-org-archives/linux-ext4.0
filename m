From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: Unifying XFS_IOC_SWAPEXT and EXT4_IOC_MOV_EXT (was Re: [PATCH 2/3]
	xfs: Add support IOC_MOV_DATA ioctl)
Date: Wed, 24 Sep 2014 16:53:49 +0900
Message-ID: <000001cfd7cc$ad447a00$07cd6e00$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Dave Chinner' <david@fromorbit.com>, 'Theodore Ts'o' <tytso@mit.edu>,
	'Dmitry Monakhov' <dmonakhov@openvz.org>,
	'Christoph Hellwig' <hch@infradead.org>,
	'linux-ext4' <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, 'Luk?? Czerner' <lczerner@redhat.com>,
	'Brian Foster' <bfoster@redhat.com>,
	'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
Content-language: ko
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org


> 
> FWIW, what we ideally need for these sorts of defrag programs is
> per-file freezing. i.e. we freeze the file to be defragged, then do
> the copy in userspace, swap/move the copied range and then unfreeze
> it once complete.  That guarantees that the file is not modified in
> any way while userspace is doing the defrag...
I am trying to unify xfs_swap extent and ext4 move extent so that both of these 
could be called via new ioctl mov_data. Both ioctl have different interface
because  both xfs and ext4 have different way of avoiding change in source file
while defrag is running. XFS uses xfs_bstat_t while ext4 performs copying of
data within kernel space after taking mutex lock.
To make them use same approach, we should use something like file sealing as
suggessted by you.
First of all, I am trying to find proper way of sealing file as suggested by
you. I am considering to use S_IMMUTABLE flag set to avoid file modification
during defrag. I am thinking of first syncing  dirty pages, then truncating
page cache pages of inode and lastly setting immutable flag of inode.
This will block further attempts of modifying the file by opening new file
pointer but already open file pointer can still change it.
Although immutable file mean file can not be modified, there is no immutable
check condition in write path and mmap path.
I am wondering it is just missing to add immutable check condition or there
is other reason I am not aware.

Thanks!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
