From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use s_inodes_per_block directly in
 __ext4_get_inode_loc.
Date: Sun, 8 May 2011 21:56:57 -0400
Message-ID: <20110509015657.GE4138@thunk.org>
References: <1301326873-9551-1-git-send-email-tm@tao.ma>
 <1301326873-9551-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48567 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1EIB47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 21:56:59 -0400
Content-Disposition: inline
In-Reply-To: <1301326873-9551-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 11:41:13PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In __ext4_get_inode_loc, we calculate inodes_per_block every time
> by EXT4_BLOCK_SIZE(sb) / EXT4_INODE_SIZE(sb). AFAICS, this function
> is really a hot path for ext4, so we'd better use s_inodes_per_block
> directly instead of calculating every time.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks.

						- Ted
