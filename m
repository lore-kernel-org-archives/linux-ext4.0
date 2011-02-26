From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix ext4_da_block_invalidatepages() to
 handle page range properly
Date: Sat, 26 Feb 2011 13:54:19 -0500
Message-ID: <20110226185419.GF2924@thunk.org>
References: <1298064699-17987-1-git-send-email-curtw@google.com>
 <1298064699-17987-2-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51937 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab1BZSyV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Feb 2011 13:54:21 -0500
Content-Disposition: inline
In-Reply-To: <1298064699-17987-2-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 18, 2011 at 01:31:39PM -0800, Curt Wohlgemuth wrote:
> If ext4_da_block_invalidatepages() is called because of a
> failure from ext4_map_blocks() in mpage_da_map_and_submit(),
> it's supposed to clean up -- including unlock -- all the
> pages in the mpd structure.  But these values may not match
> up, even on a system in which block size == page size:
> 
>    mpd->b_blocknr != mpd->first_page
>    mpd->b_size != (mpd->next_page - mpd->first_page)
> 
> ext4_da_block_invalidatepages() has been using b_blocknr and
> b_size; this patch changes it to use first_page and
> next_page.
> 
> Tested:  I injected a small number (5%) of failures in
> ext4_map_blocks() in the case that the flags contain
> EXT4_GET_BLOCKS_DELALLOC_RESERVE, and ran fsstress on this
> kernel.  Without this patch, I got hung tasks every time.
> With this patch, I see no hangs in many runs of fsstress.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, added to the ext4 patch queue.

						- Ted
