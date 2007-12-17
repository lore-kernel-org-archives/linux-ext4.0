From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 17 Dec 2007 15:48:47 -0500
Message-ID: <20071217204847.GE7070@thunk.org>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20071217172301.GL6979@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46952 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbXLQUsv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2007 15:48:51 -0500
Content-Disposition: inline
In-Reply-To: <20071217172301.GL6979@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2007 at 06:23:01PM +0100, Jan Kara wrote:
> > Theodore Ts'o (20):
> >   Fix errors in test_ss.c so it can be an example application and
> >       test case
> >   libext2fs: Fix a corner case bug in ext2fs_unlink
>   Not that it would matter much but I think this was actually my fix ;).

Yep, sorry.  You are listed as the first Signed-off-by: in the patch
header.  When the patches is in a form that can't be automatically
sucked in via "git am" (including appropriately formatted patch
comments), I end up applying the patch by hand, and I do try to
remember to manually set the Author field, but sometimes I forget.

       	   	     				- Ted
