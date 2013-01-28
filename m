From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: correct the number of blocks that has been deallocated in
 ext4_free_hole_blocks
Date: Mon, 28 Jan 2013 09:22:37 -0500
Message-ID: <20130128142237.GA387@thunk.org>
References: <1359344667-12068-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45845 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1OWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:22:41 -0500
Content-Disposition: inline
In-Reply-To: <1359344667-12068-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 27, 2013 at 05:44:27PM -0000, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit fixes a bug in ext4_free_hole_blocks that iff the number of
> hole blocks is equal to EXT4_NDIR_BLOCKS and the first block of the hole
> is a direct block, the number of deallocated blocks is wrong.

Thanks!  I've merged this into the indirect punch hole patch, which is
in the dev branch and queued in the ext4 patch queue.

	     	    	      	  	   - Ted
