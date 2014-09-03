From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: pass allocation_request struct to
 ext4_(alloc,splice)_branch
Date: Wed, 3 Sep 2014 13:17:21 -0400
Message-ID: <20140903171721.GG2504@thunk.org>
References: <1409695549-18605-1-git-send-email-tytso@mit.edu>
 <1409695549-18605-2-git-send-email-tytso@mit.edu>
 <20140903162552.GD17066@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35500 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbaICRRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 13:17:25 -0400
Content-Disposition: inline
In-Reply-To: <20140903162552.GD17066@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 03, 2014 at 06:25:52PM +0200, Jan Kara wrote:
>   This seems to suggest ext4_new_meta_blocks() would be better off by
> taking allocation_request argument as well?

I thought about it, but the problem is that ext4_new_meta_blocks() is
called in many more places than ext4_alloc_branch().  So in this
patch, it was just a metter of moving some code from one function to
its (single) caller.

In the case of ext4_new_meta_blocks(), we would needing to replicate
that that code in four or five places, and we were passing in the
mb_flags field anyway, so it wasn't a case of needing to add yet
another argument to a function that had many more arguments to start
with.   So I decided it wasn't worth the effort.

Cheers,

						- Ted
