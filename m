From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v3] ext4: Make ext4_block_in_group() much more
 efficient
Date: Sun, 31 Mar 2013 21:24:03 -0400
Message-ID: <20130401012403.GA3494@thunk.org>
References: <1364398541-4114-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57598 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3DABYG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 21:24:06 -0400
Content-Disposition: inline
In-Reply-To: <1364398541-4114-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 04:35:40PM +0100, Lukas Czerner wrote:
> Currently in when getting the block group number for a particular block
> in ext4_block_in_group() we're using ext4_get_group_no_and_offset()
> which uses do_div() to get the block group and the remainer which is
> offset within the group.
> 
> We don't need all of that in ext4_block_in_group() as we only need to
> figure out the group number.
> 
> This commit changes ext4_block_in_group() to calculate group number
> directly. This shows as a big improvement with regards to cpu
> utilization. Measuring fallocate -l 15T on fresh file system with perf
> showed that 23% of cpu time was spend in the
> ext4_get_group_no_and_offset(). With this change it completely
> disappears from the list only bumping the occurrence of
> ext4_init_block_bitmap() which is the biggest user of
> ext4_block_in_group() by 4%. As the result of this change on my system
> the fallocate call was approx. 10% faster.
> 
> However since there is '-g' option in mkfs which allow us setting
> different groups size (mostly for developers) I've introduced new per
> file system flag whether we have a standard block group size or not. The
> flag is used to determine whether we can use the bit shift optimization
> or not.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
