From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd: Fail to load a journal if it is too short
Date: Wed, 22 Jul 2009 11:52:21 +0200
Message-ID: <20090722095221.GB19072@duck.suse.cz>
References: <1248170659-11771-1-git-send-email-jack@suse.cz> <1248170659-11771-2-git-send-email-jack@suse.cz> <20090721091946.06bcdef8.akpm@linux-foundation.org> <20090721213548.GA6748@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZGVJwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2009 05:52:22 -0400
Content-Disposition: inline
In-Reply-To: <20090721213548.GA6748@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 21-07-09 17:35:48, Theodore Tso wrote:
> On Tue, Jul 21, 2009 at 09:19:46AM -0700, Andrew Morton wrote:
> > 
> > It's odd that sb->s_first/s_maxlen are 32-bit and
> > journal->j_first/j_last are unsigned long.
> > 
> > These things will only ever be 32-bit unless we change the journal
> > superblock.
> 
> In general, if there is any use of "unsigned long" in fs/ext[34], it's
> probably a bug.  This is because ulong is 32-bits on x86, and 64-bits
> on x86_64, so it just wastes memory space on 64-bit platforms.  The
> one exception to this is if the field in question is used by the
> standard bitops functions, which only functions correctly on "unsigned
> long".
  That's a good point. I'll write a cleanup patch at least for the obvious
offenders.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
