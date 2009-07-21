From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd: Fail to load a journal if it is too short
Date: Tue, 21 Jul 2009 17:35:48 -0400
Message-ID: <20090721213548.GA6748@mit.edu>
References: <1248170659-11771-1-git-send-email-jack@suse.cz> <1248170659-11771-2-git-send-email-jack@suse.cz> <20090721091946.06bcdef8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41996 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZGVBI5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 21:08:57 -0400
Content-Disposition: inline
In-Reply-To: <20090721091946.06bcdef8.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 21, 2009 at 09:19:46AM -0700, Andrew Morton wrote:
> 
> It's odd that sb->s_first/s_maxlen are 32-bit and
> journal->j_first/j_last are unsigned long.
> 
> These things will only ever be 32-bit unless we change the journal
> superblock.

In general, if there is any use of "unsigned long" in fs/ext[34], it's
probably a bug.  This is because ulong is 32-bits on x86, and 64-bits
on x86_64, so it just wastes memory space on 64-bit platforms.  The
one exception to this is if the field in question is used by the
standard bitops functions, which only functions correctly on "unsigned
long".

						- Ted
