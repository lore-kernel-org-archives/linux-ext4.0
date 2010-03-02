From: tytso@mit.edu
Subject: Re: [PATCH 00/28] Ext4 patch queue for the 2.6.34 merge window.
Date: Tue, 2 Mar 2010 13:26:18 -0500
Message-ID: <20100302182618.GA6602@thunk.org>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jiayingz@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53126 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0CBS0T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:26:19 -0500
Content-Disposition: inline
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 02, 2010 at 01:18:17PM -0500, Theodore Ts'o wrote:
> This is what I have queued up to send to Linus for the 2.6.34 merge
> window.  It's in the ext4 patch queue and in the ext4 tree (everything
> between origin and next).  I'm currently doing final testing and plan to
> ship it to Linus in the next day or two.
> 
> If you think something is missing or should be dropped for this list, or
> see something wrong, please let me know ASAP.  Thanks!!
> 
>     	      	     	    	   - Ted
> 
> Theodore Ts'o (9):
>   ext4: mechanical change on dio get_block code in prepare for it to be
>     used by buffer write
>   ext4: use ext4_get_block_write in buffer write
>   ext4: Use direct_IO_no_locking in ext4 dio read.

This should be properly credited to Jiaying Zhang.  Oops.  I'll fix
this before pushing...

					- Ted
