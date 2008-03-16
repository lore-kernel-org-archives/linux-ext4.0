From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 14:39:12 +0300
Message-ID: <20080316113912.GA3118@dmon-lap.sw.ru>
References: <20080315160731.GA4186@dmon-lap.sw.ru> <20080315230544.GV3542@webber.adilger.int> <20080315235427.GA26939@webber.adilger.int> <20080316002300.GB26939@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/WwmFnJnmDyWGHa4"
Cc: linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:3381 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYCPLoC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2008 07:44:02 -0400
Content-Disposition: inline
In-Reply-To: <20080316002300.GB26939@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've added Jens because he may be also interesting in this topic.
On 08:23 Sun 16 Mar     , Andreas Dilger wrote:
> On Mar 16, 2008  07:54 +0800, Andreas Dilger wrote:
> > A call to  inode_setattr() can fail by trying a shrinking vmtruncate()
> > on a swapfile, which returns ETXTBUSY.  This was added after the
> > ext3_setattr() code was written.
> > 
> > We need to handle the IS_SWAPFILE() case properly.
> > Granted, it probably isn't a very common problem, but the IS_SWAPFILE()
> > check was added explicitly because of clueless users, so it must be hit
> > occasionally in real life.
> > 
> > It would seem that if you have a swapfile, try to truncate it to 0 (which
> > will fail with -ETXTBUSY) and then unmount the filesystem the size will
> > be truncated to 0.  It is also possible to directly write to a swapfile
> > and corrupt memory, or read from a swapfile and access potentially sensitive
> > information.
In fact i've triggered this issue while working on fast_loop device
implementation which was proposed by Jens (http://lkml.org/lkml/2008/1/9/50).
In fast_loop device use swapfile approach (submitting bio-s directly to
underlying block device). I think this idea will be included in mainstream
loop device sooner or later. But approach has several issues:
One of the most important is effective control mechanism over truncates for
lower file,  this issue was missed in Jens patch set.
This mechanism probably have to have following options.
#1: Shrink truncates must be denied.
#2: Expand truncates may be allowed. This is good because most of non plain 
disk image formats (qcow, vmdk, and etc) are growing while adding new data
blocks.
#3: Allow exclusive owner for file, for example only one user(loop_thread in
this case) may truncate file. Provide something similar to bd_claim feature.
without this feature on-line shrinking of disk image looks like this:

 mutex_lock(&inode->i_mutex);
 inode->i_flags &= ~S_SWAPFILE;
 mutex_unlock(&inode->i_mutex);

 /* Perform shrinking truncate. This is absolutely racy operation because
  * some one else also may perform truncate at this time*/
 do_truncate(inode, size); 

 mutex_lock(&inode->i_mutex);
 inode->i_flags |= S_SWAPFILE;
 mutex_unlock(&inode->i_mutex);


S_SWAPFILE inode option currently equals to #1, and #2. What's why i want
use this flag for fast_loop devices.

> 
> Dmitri, (or anyone)
> can you please give this patch a try.  It should be OK, but I'm hesitant
> to test it on my test box because I'm out of town and if it fails to
> reboot I can't fix it for a week.  It _should_ still be possible to chown,
> rename, ls, etc the swapfile, can you please verify that in addition
> to the simple test in my previous email.
> 
[snip]
> 
> 
> 
> --- linux-2.6.24/fs/namei.c.orig	2008-02-05 07:29:57.000000000 +0800
> +++ linux-2.6.24/fs/namei.c	2008-03-16 08:11:41.000000000 +0800
> @@ -233,6 +233,10 @@ int permission(struct inode *inode, int 
>  	if (nd)
>  		mnt = nd->mnt;
>  
> +	/* Don't allow direct read, write, or truncate on a swapfile */
Your patch disallow expand truncates (#2) which is definitely not good. 
In fact if file was opened before S_SWAPFILE flag was setted when it is
possible to directly read, write from file.
> +	if (IS_SWAPFILE(inode))
> +		return -ETXTBUSY;
> +
>  	if (mask & MAY_WRITE) {
>  		umode_t mode = inode->i_mode;

BTW it is impossible to disable swapfile with your patch 
[root@ts63 tmp]# swapoff  /vz/swap 
swapoff: /vz/swap: Text file busy

IMHO S_SWAPFILE flag must be checked in ext3_setattr, see patch attached:

--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="swap_flag.patch"

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..0f74beb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3032,6 +3032,10 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
 
+		if (IS_SWAPFILE(inode)) {
+			rc = -ETXTBSY;
+			goto err_out;
+		}
 		handle = ext3_journal_start(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);

--/WwmFnJnmDyWGHa4--
