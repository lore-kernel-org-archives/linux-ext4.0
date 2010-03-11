From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
	filesystem
Date: Thu, 11 Mar 2010 07:06:23 -0500
Message-ID: <20100311120623.GC4706@infradead.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org> <1267727677-11956-2-git-send-email-dmonakhov@openvz.org> <1267727677-11956-3-git-send-email-dmonakhov@openvz.org> <1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab0CKMGY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 07:06:24 -0500
Content-Disposition: inline
In-Reply-To: <1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 09:34:35PM +0300, Dmitry Monakhov wrote:
>   Project id is stored on disk inside xattr usually inside ibody.
>   Xattr is used only as a data storage, It has not user visible xattr
>   interface.
> 
> * User interface
>   Project id is accessible via generic xattr interface "system.project_id"
> 
> TODO: implement e2libfs support for project_id.

I think you'd be much better off storing it inide the inode core itself.
E.g. you could ue the never used fragment address in the ext2/3/4 disk
inode.

> +#ifdef CONFIG_QUOTA
> +	qid[PRJQUOTA] = new_prjid;
> +	ret = inode->i_sb->dq_op->transfer(inode, qid, 1 << PRJQUOTA);
> +	if (ret)
> +		return ret;
> +#endif

This needs to be updated to use dquot_transfer directly.

