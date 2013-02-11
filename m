From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/10 v5] ext4: convert unwritten extents from extent
 status tree in end_io
Date: Sun, 10 Feb 2013 20:52:41 -0500
Message-ID: <20130211015241.GA13161@thunk.org>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-10-git-send-email-wenqing.lz@taobao.com>
 <20130210084511.GB14075@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Zheng Liu <wenqing.lz@taobao.com>, Jan kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47811 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3BKBwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2013 20:52:47 -0500
Content-Disposition: inline
In-Reply-To: <20130210084511.GB14075@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 10, 2013 at 04:45:11PM +0800, Zheng Liu wrote:
> 
> This chunk is missing in your 'dev' branch of ext4.  If we call
> ext4_map_blocks here, unwritten extent in disk will never be converted
> because ext4_map_blocks first tries to lookup extent status tree and the
> unwriten extent in this tree has been converted in end_io callback
> function.  It always looks up a written extent in cache, and return
> immdiately.  Please check it again.

Thanks for catching this!  I missed the the patch hunk getting
rejected because I had been distracted with the patch hunk rejection
caused by the fact that we've since dropped the function
ext4_end_io_buffer_write().

I've fixed this up and pushed an updated git "dev" branch.

     	   	       	      	 	 - Ted
