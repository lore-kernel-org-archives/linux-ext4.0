From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: allocate transaction from special cache
Date: Mon, 13 Feb 2012 17:10:20 -0500
Message-ID: <20120213221020.GB21641@thunk.org>
References: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Manish Katiyar <mkatiyar@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36546 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab2BMWKZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:10:25 -0500
Content-Disposition: inline
In-Reply-To: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 13, 2011 at 07:21:29PM +0800, Yongqiang Yang wrote:
> transaction_t is 136 byes under 32-bit systems. If we allocate
> it from general cache, it comsumes 256 bytes.  So let jbd2 allocate
> it from special cache to reduce memory consumption.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied with a modified description:

    jbd2: allocate transaction from separate slab cache
    
    There is normally only a handful of these active at any one time, but
    putting them in a separate slab cache makes debugging memory
    corruption problems easier.  Manish Katiyar also wanted this make it
    easier to test memory failure scenarios in the jbd2 layer.

    	      	   	  	  	       - Ted
