From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7 v2] ext4: track all extent status in extent status
 tree
Date: Tue, 22 Jan 2013 23:31:16 -0500
Message-ID: <20130123043116.GD21696@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-6-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44957 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab3AWEbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 23:31:23 -0500
Content-Disposition: inline
In-Reply-To: <1357901627-3068-6-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:53:45PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 

Please line-wrap the commit description to 72 columns.  (This way the
output of "git log" will look nice even on 80 column terminal windows)".

> After record phycisal block and status, extent status tree is able to track the

"By recording the physical block and status, ...."

> status of every extents.  When we call _map_blocks functions to lookup an extent
> or create a new written/unwritten/delayed extent, this extent will be inserted
> into extent status tree.
> 
> We don't load all extents from disk in alloc_inode() because it costs too much
> memory, and, when open/close a file very frequently, it will takes too much time

"...and if a file is opened and closed frequently"..."

> to load all extent information.  So currently when we create/lookup an extent,
> this extent will be inserted into extent status tree.  Hence, the status in
> extent status tree might be not completely.

"Hence, the extent status tree may not comprehensively contain all of
the extents found in the file."

						- Ted
