From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 3/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Thu, 4 Sep 2014 11:54:36 -0400
Message-ID: <20140904155436.GG4047@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
 <20140902024350.GS8974@thunk.org>
 <20140904130448.GB13193@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37968 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaIDPyo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Sep 2014 11:54:44 -0400
Content-Disposition: inline
In-Reply-To: <20140904130448.GB13193@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 04, 2014 at 09:04:48PM +0800, Zheng Liu wrote:
> > I thought the reason why we have the EXT4_GET_BLOCKS_NO_PUT_HOLE flag
> > is because in ext4_da_map_blocks(), if there is a hole, we will be
> > immediately following it up with a call to ext4_es_insert_extent() to
> > fill in the hole with the EXTENT_STATUS_DELAYED flag.  The only time
> > we don't is if we run into an ENOSPC error.
> > 
> > Am I missing something?
> 
> Yes, you are right.  The purpose is used to do the work like you said
> above.  As the commit log described this flag brings a huge number of
> cache misses when an empty file is written.  

Right, and I was trying to figure out why that was happening, because
it looked like in the normal case we would immediately fill in the
hole afterwards.  I was goign to try doing some tracing to understand
why this was resulting a huge number of cache misses, but I haven't
had time to do that investigation yet.  Can you sketch out the
scenario where this was leading to so many cache misses?

Thanks,

					- Ted
