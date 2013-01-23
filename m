From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/7 v2] ext4: refine extent status tree
Date: Tue, 22 Jan 2013 23:20:54 -0500
Message-ID: <20130123042054.GC21696@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44950 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3AWEVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 23:21:00 -0500
Content-Disposition: inline
In-Reply-To: <1357901627-3068-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:53:41PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This patch tries to refine the extent status tree.  A prefix 'es_' is added to
> make code clearly.

I suggest the following commit description:

    ext4: refine extent status tree
    
    This commit refines the extent status tree code.
    
    1) A prefix 'es_' is added to to the extent status tree structure
    members.
    
    2) Refactored es_remove_extent() so that __es_remove_extent() can be
    used by es_insert_extent() to remove the old extent entry(-ies) before
    inserting a new one.
    
    3)  Update and clarified comments.

> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 564d981..0662369 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> + * Step2:
> + * In this step all extent status is tracked by extent status tree.
> + * Thus, we can first try to lookup a block mapping in this tree before
> + * find it in extent tree.  Unwritten extent conversion also can be
> + * improved.  Currently this conversion need to be done in a workqueue
> + * because this conversion can not be done in end_io function due to it
> + * needs to take i_data_sem locking in a irq context.  After looking block
> + * mapping in extent status tree, we can first convert unwritten extent in
> + * extent status tree, call aio_comlete() and inode_dio_done() in end_io
> + * function, and don't need to be worried about expose a stale data.

Grammar nit:  The last line should read:

"don't need to be worried about exposing stale data"

						- Ted
