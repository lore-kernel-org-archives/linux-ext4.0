From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 6/7 v2] ext4: lookup block mapping in extent status tree
Date: Fri, 18 Jan 2013 17:52:04 +0800
Message-ID: <20130118095204.GB20442@gmail.com>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-7-git-send-email-wenqing.lz@taobao.com>
 <20130118040006.GB13785@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33851 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab3ARJiZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 04:38:25 -0500
Received: by mail-pb0-f49.google.com with SMTP id un15so1942028pbc.22
        for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 01:38:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130118040006.GB13785@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 17, 2013 at 11:00:06PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 11, 2013 at 06:53:46PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After tracking all extent status, we already have a extent cache in memory.
> > Every time we want to lookup a block mapping, we can first try to lookup it in
> > extent status tree to avoid a potential disk I/O.
> > 
> > A new function called ext4_es_lookup_extent is defined to finish this work.
> > When we try to lookup a block mapping, we always call ext4_map_blocks and/or
> > ext4_da_map_blocks.  So in these functions we first try to lookup a block
> > mapping in extent status tree.
> > 
> > CC: Jan kara <jack@suse.cz>
> > CC: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> Once we apply this this patch, we should be able to remove the the
> single-entry extent cache in fs/ext4/extents.c ---
> ext4_ext_put_in_cache(), ext4_ext_put_gap_in_cache(),
> ext4_ext_in_cache() --- since the extent status tree makes this code
> redundant (and will do a better job).  This would be a good follow up,
> cleanup patch.

Fair enough.  The patch that tries to remove extent cache will be sent out
in next version.

Thanks,
                                                - Zheng
