From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [V2] e2fsck: fix error in computing blocks of the ending group
Date: Fri, 16 Sep 2011 09:29:46 -0400
Message-ID: <20110916132946.GB6710@thunk.org>
References: <4E28FA31.7090405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34883 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab1IPN3t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 09:29:49 -0400
Content-Disposition: inline
In-Reply-To: <4E28FA31.7090405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 06:18:57PM -0000, Eric Sandeen wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> If the blocks of a filesystem is a multiple of blocks_per_group,
> blocks of the ending group is computed wrongly.  Use the
> new ext2fs_group_blocks_count() helper instead.
> 
> Eric Sandeen: Converted to use new blocks per group helper
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks applied to the next branch.  Apologies for the delay.

       	       	      	   	    	      - Ted
