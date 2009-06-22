From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]JBD2/JBD: race condition while writing updates to
	journal
Date: Sun, 21 Jun 2009 20:09:15 -0400
Message-ID: <20090622000915.GA6464@mit.edu>
References: <4A3E5E2B.4020106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dingdinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44727 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZFVAJS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2009 20:09:18 -0400
Content-Disposition: inline
In-Reply-To: <4A3E5E2B.4020106@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2009 at 12:22:03AM +0800, dingdinghua wrote:
> 
> At committing phase, we call jbd2_journal_write_metadata_buffer to
> prepare log block's buffer_head, in this function, new_bh->b_data is set
> to b_frozen_data or bh_in->b_data. We call "jbd_unlock_bh_state(bh_in)"
> too early, since at this point , we haven't file bh_in to BJ_shadow list,
> and we may set new_bh->b_data to bh_in->b_data, at this time, another
> thread may call get write access of bh_in, modify bh_in->b_data and
> dirty it. So , if new_bh->b_data is set to bh_in->b_data, the committing
> transaction may flush the newly modified buffer content to disk,
> preserve work done in jbd2_journal_get_write_access is useless. jbd also
> has this problem.
> 
> here is the patch based on kernel version 2.6.30:

This patch is completely whitespace damaged.  Could you resend it
using a mail user agent that doesn't damage patches, please?    Thanks!!

      	     	  	     	     	    - Ted
