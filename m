From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: let ext4_free_blocks handle multiblock
 correctly
Date: Wed, 28 Dec 2011 12:23:49 -0500
Message-ID: <20111228172349.GC12370@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47208 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1L1RXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 12:23:53 -0500
Content-Disposition: inline
In-Reply-To: <1321344474-14707-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 04:07:52PM +0800, Yongqiang Yang wrote:
> We should not pass buffer whiose block number is not block + i.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

This fixes a big in PATCH 2/5; see the comments for that patch.

     	     	    	       	   - Ted
