From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 4/4] ext4: fix incorrect block reservation on quota
 transfer.
Date: Mon, 07 Dec 2009 17:02:17 -0800
Message-ID: <1260234137.4206.148.camel@mingming-laptop>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
	 <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
	 <1259132261-16785-3-git-send-email-dmonakhov@openvz.org>
	 <1259132261-16785-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:45746 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935731AbZLHBCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 20:02:34 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nB80xlfD032072
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 17:59:47 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB812JlX173588
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 18:02:20 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB812JMT022531
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 18:02:19 -0700
In-Reply-To: <1259132261-16785-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-11-25 at 09:57 +0300, Dmitry Monakhov wrote:
> Inside ->setattr() call both ATTR_UID and ATTR_GID may be valid
> This means that we may end-up with transferring all quotas. Add
> we have to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in
> case of QUOTA_INIT_BLOCKS.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Seems correct to me. It looks like ext3 need similar fix, mind to send a
ext3 patch as well?

Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 211722b..d42e954 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5439,7 +5439,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  		/* (user+group)*(old+new) structure, inode write (sb,
>  		 * inode block, ? - but truncate inode update has it) */
>  		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> -					EXT4_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
> +					EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
>  		if (IS_ERR(handle)) {
>  			error = PTR_ERR(handle);
>  			goto err_out;


