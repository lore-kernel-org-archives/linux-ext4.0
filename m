From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/5] ext4: add new ioctl EXT4_IOC_PRECACHE_EXTENTS
Date: Thu, 18 Jul 2013 09:19:41 +0800
Message-ID: <20130718011940.GA8785@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <1373987883-4466-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:65006 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab3GRBB5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jul 2013 21:01:57 -0400
Received: by mail-pd0-f170.google.com with SMTP id x11so2441751pdj.15
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jul 2013 18:01:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373987883-4466-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:18:03AM -0400, Theodore Ts'o wrote:
> Add a new ioctl which forces the all of the extents in an inode to be
> cached in the extent_status tree.  This is critically important when
> using AIO to a preallocated file, since if we need to read in blocks
> from the extent tree, the io_submit(2) system call becomes
> synchronous, and the AIO is no longer "A", which is bad.
> 
> In addition, for most files which have an external leaf tree block,
> the cost of caching the information in the extent status tree will be
> less than caching the entire 4k block in the buffer cache.  So it is
> generally a win to keep the extent information cached.
> ---
[...]
> @@ -1069,10 +1072,16 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
>  	struct rb_node *node;
>  	struct extent_status *es;
>  	int nr_shrunk = 0;
> +	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
> +	                              DEFAULT_RATELIMIT_BURST);
>  
>  	if (ei->i_es_lru_nr == 0)
>  		return 0;
>  
> +	if (ext4_test_inode_state(inode, EXT4_STATE_EXT_PRECACHED) &&
> +	    __ratelimit(&_rs))
> +		ext4_warning(inode->i_sb, "forced shrink of precached extents");

If I understand correctly, we don't want to reclaim from an inode with
EXT4_STATE_EXT_PRECACHED flag when __ratelimit() returns 0, right?  So
I propose the following code:

        if (ext4_test_inode_state(inode, EXT4_STATE_EXT_PRECACHED) {
                if (!__ratelimit(&_rs))
                        return 0;
                ext4_warning(inode->i_sb, "forced shrink of precached extents");
        }

                                                - Zheng

> +
>  	node = rb_first(&tree->root);
>  	while (node != NULL) {
>  		es = rb_entry(node, struct extent_status, rb_node);
