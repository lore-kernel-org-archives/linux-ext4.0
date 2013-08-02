From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Make ext4_writepages() resilient to i_size changes
Date: Fri, 2 Aug 2013 21:15:37 +0200
Message-ID: <20130802191537.GA25558@quack.suse.cz>
References: <1375310532-17731-1-git-send-email-jack@suse.cz>
 <20130802142324.GA20484@quack.suse.cz>
 <20130802152624.GA1121@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649Ab3HBTPk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Aug 2013 15:15:40 -0400
Content-Disposition: inline
In-Reply-To: <20130802152624.GA1121@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-08-13 11:26:24, Dave Jones wrote:
> On Fri, Aug 02, 2013 at 04:23:24PM +0200, Jan Kara wrote:
>  > On Thu 01-08-13 00:42:12, Jan Kara wrote:
>  > > Inode size can arbitrarily change while writeback is in progress. This
>  > > can have various strange effects when we use one value of i_size for one
>  > > decision during writeback and another value of i_size for a different
>  > > decision during writeback. In particular a check for lblk < blocks in
>  > > mpage_map_and_submit_buffers() causes problems when i_size is reduced
>  > > while writeback is running because we can end up not using all blocks
>  > > we've allocated. Thus these blocks are leaked and also delalloc
>  > > accounting gets wrong manifesting as a warning like:
>  > > 
>  > > ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1
>  > > with only 0 reserved data blocks
>  > > 
>  > > The problem can happen only when blocksize < pagesize because the check
>  > > for size is performed only after the first iteration of the mapping
>  > > loop.
>  > > 
>  > > Fix the problem by removing the size check from the mapping loop. We
>  > > have an extent allocated so we have to use it all before checking for
>  > > i_size. We may call add_page_bufs_to_extent() unnecessarily but that
>  > > function won't do anything if passed block number is beyond file size.
>  > > 
>  > > Also to avoid future surprises like this sample inode size when
>  > > starting writeback in ext4_writepages() and then use this sampled size
>  > > throughout the writeback call stack.
>  >   Ted, please disregard this patch. It is buggy. I'll send a better fix
>  > soon.
>  
> I was about to post that I was seeing fsx failures on 1k filesystems
> on a kernel with this patch.
> 
> Is that the same thing you're seeing ?
  Likely, I saw fsstress failures with it. But fsx would likely fail as
well - the writing of tail page was hosed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
