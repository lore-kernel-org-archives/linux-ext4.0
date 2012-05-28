From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
Date: Mon, 28 May 2012 14:24:38 -0400
Message-ID: <20120528182438.GL19152@thunk.org>
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Haogang Chen <haogangchen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46040 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1SYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 14:24:42 -0400
Content-Disposition: inline
In-Reply-To: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2012 at 05:41:24PM -0500, Haogang Chen wrote:
> In alloc_flex_gd(), when flexbg_size is large, kmalloc size would
> overflow and flex_gd->groups would point to a buffer smaller than
> expected, causing OOB accesses when it is used.
> 
> Note that in ext4_resize_fs(), flexbg_size is calculated using
> sbi->s_log_groups_per_flex, which is read from the disk and only bounded
> to [1, 31]. The patch returns NULL for too large flexbg_size.
> 
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>

Thanks, applied.  Apologies for missing this during the last cycle.

		  	    		     - Ted
