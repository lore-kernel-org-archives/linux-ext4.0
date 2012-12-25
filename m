From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext3: set pointer = NULL, after kfree it
Date: Tue, 25 Dec 2012 13:51:55 -0500
Message-ID: <20121225185155.GE5318@thunk.org>
References: <50D7EEF6.4070005@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40297 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab2LYSwB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 13:52:01 -0500
Content-Disposition: inline
In-Reply-To: <50D7EEF6.4070005@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 24, 2012 at 01:58:14PM +0800, Chen Gang wrote:
> 
>   set s->base = NULL, after kfree it.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Was this to fix something flagged by some static code checker?  The
only caller of ext3_xattr_block_set() is ext3_xattr_set_handle(), and
s->base is stored on the stack, and as soon as ext3_xattr_block_set()
returns, the object will disappear.  So it seems pretty hard to see
how this could lead to a use-after-free bug.

    	       	       	 		- Ted
