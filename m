From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/7 v2] ext4: lookup block mapping in extent status tree
Date: Thu, 17 Jan 2013 23:00:06 -0500
Message-ID: <20130118040006.GB13785@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-7-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44112 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3AREAM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2013 23:00:12 -0500
Content-Disposition: inline
In-Reply-To: <1357901627-3068-7-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:53:46PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After tracking all extent status, we already have a extent cache in memory.
> Every time we want to lookup a block mapping, we can first try to lookup it in
> extent status tree to avoid a potential disk I/O.
> 
> A new function called ext4_es_lookup_extent is defined to finish this work.
> When we try to lookup a block mapping, we always call ext4_map_blocks and/or
> ext4_da_map_blocks.  So in these functions we first try to lookup a block
> mapping in extent status tree.
> 
> CC: Jan kara <jack@suse.cz>
> CC: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Once we apply this this patch, we should be able to remove the the
single-entry extent cache in fs/ext4/extents.c ---
ext4_ext_put_in_cache(), ext4_ext_put_gap_in_cache(),
ext4_ext_in_cache() --- since the extent status tree makes this code
redundant (and will do a better job).  This would be a good follow up,
cleanup patch.

	       	       	 	- Ted
