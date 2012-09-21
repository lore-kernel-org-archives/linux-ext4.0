From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Fri, 21 Sep 2012 19:59:12 -0400
Message-ID: <20120921235912.GA27207@thunk.org>
References: <1348111390-23083-1-git-send-email-tytso@mit.edu>
 <505CE635.6060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51975 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2IUX7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 19:59:20 -0400
Content-Disposition: inline
In-Reply-To: <505CE635.6060101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 21, 2012 at 05:12:05PM -0500, Eric Sandeen wrote:
> > -	if (free_blocks < 2 * dirty_blocks)
> > -		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
> > +	if ((free_blocks < 2 * dirty_blocks) && writeback_in_progress(sb->s_bdi))
> > +		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
> 
> Looks to me like this inverts the logic.
> 
> We used to write back if idle, now we fire it off if it's already underway.
> 
> Shouldn't it be:
> 
> +	if ((free_blocks < 2 * dirty_blocks) && !writeback_in_progress(sb->s_bdi))
> +		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);

Oops, nice catch.  Thanks for the review!!

I've added the missing '!' to the patch.

     	   					- Ted
