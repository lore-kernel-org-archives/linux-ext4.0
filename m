From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [ext4:dev 47/50] fs/ext4/extents.c:4949 ext4_ext_punch_hole()
 warn: inconsistent returns mutex:&inode->i_mutex: locked (4813,4815)
 unlocked (4806,4949)
Date: Mon, 1 Oct 2012 11:22:14 +0800
Message-ID: <20121001032214.GA14999@localhost>
References: <20121001025047.GB12711@localhost>
 <87mx06vq3w.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2JADWT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Sep 2012 23:22:19 -0400
Content-Disposition: inline
In-Reply-To: <87mx06vq3w.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 01, 2012 at 07:16:35AM +0400, Dmitry Monakhov wrote:
> On Mon, 1 Oct 2012 10:50:47 +0800, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Dmitry,
> > 
> > FYI, there are new smatch warnings show up in
> > 
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> > head:   07043757c1a4018a04aded14deb1f28269a4b2ad
> > commit: c6a59106b4106d13dc824a388c5572ddd65a0779 [47/50] ext4: punch_hole should wait for DIO writers
> > 
> >   arch/x86/include/asm/jump_label.h:25 arch_static_branch() info: ignoring unreachable code.
> > + fs/ext4/extents.c:4949 ext4_ext_punch_hole() warn: inconsistent returns mutex:&inode->i_mutex: locked (4813,4815) unlocked (4806,4949)
> Yes, that is correct, my bad. Sorry, patch attached
> BTW  What tool(compile option) you use to catch this issue?

Dmitry, I'm running smatch, a very powerful tool, written and maintained by Dan Carpenter.

http://smatch.sourceforge.net/

Thanks,
Fengguang

> > 
> > vim +4949 fs/ext4/extents.c
> > 
> > c6a59106 (Dmitry Monakhov   2012-09-29  4808) 
> > c6a59106 (Dmitry Monakhov   2012-09-29  4809) 	mutex_lock(&inode->i_mutex);
> > c6a59106 (Dmitry Monakhov   2012-09-29  4810) 	/* Need recheck file flags under mutex */
> > c6a59106 (Dmitry Monakhov   2012-09-29  4811) 	/* It's not possible punch hole on append only file */
> > c6a59106 (Dmitry Monakhov   2012-09-29  4812) 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > c6a59106 (Dmitry Monakhov   2012-09-29  4813) 		return -EPERM;
>                                                                ^^^^^^^^^^^^^^^^
> > c6a59106 (Dmitry Monakhov   2012-09-29  4814) 	if (IS_SWAPFILE(inode))
> > c6a59106 (Dmitry Monakhov   2012-09-29  4815) 		return -ETXTBSY;
>                                                                ^^^^^^^^^^^^^^^^^^
> > c6a59106 (Dmitry Monakhov   2012-09-29  4816) 
> > 2be4751b (Allison Henderson 2011-09-03  4817) 	/* No need to punch hole beyond i_size */
> > 2be4751b (Allison Henderson 2011-09-03  4818) 	if (offset >= inode->i_size)
> > c6a59106 (Dmitry Monakhov   2012-09-29  4819) 		goto out_mutex;
> > 2be4751b (Allison Henderson 2011-09-03  4820) 

> >From 6cf5cfc5db6c792c76c68bdbc765b733b5ad5488 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Mon, 1 Oct 2012 07:09:49 +0400
> Subject: [PATCH] ext4: ext4_ext_punch_hole put i_mutex on error
> 
> Fix mistypo introduced in 'ext4: punch_hole should wait for DIO writers' patch.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f02ffce..0a720d4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4811,10 +4811,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	mutex_lock(&inode->i_mutex);
>  	/* Need recheck file flags under mutex */
>  	/* It's not possible punch hole on append only file */
> -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -		return -EPERM;
> -	if (IS_SWAPFILE(inode))
> -		return -ETXTBSY;
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
> +		err = -EPERM;
> +		goto out_mutex;
> +	}
> +	if (IS_SWAPFILE(inode)) {
> +		err = -ETXTBSY;
> +		goto out_mutex;
> +	}
>  
>  	/* No need to punch hole beyond i_size */
>  	if (offset >= inode->i_size)
> -- 
> 1.7.7.6
> 

