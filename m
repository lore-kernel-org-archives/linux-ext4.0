From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Thu, 26 May 2011 17:37:58 +0200
Message-ID: <20110526153758.GG5123@quack.suse.cz>
References: <4DDCAF18.8030809@gmail.com>
 <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com>
 <20110525081333.GB4427@quack.suse.cz>
 <20110526022251.GG9520@thunk.org>
 <E4B2E5DC-AC13-4AB9-870E-6F3584991396@dilger.ca>
 <20110526140558.GJ9520@thunk.org>
 <20110526144956.GB5123@quack.suse.cz>
 <20110526150846.GL9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1EZPiA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 11:38:00 -0400
Content-Disposition: inline
In-Reply-To: <20110526150846.GL9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 26-05-11 11:08:46, Ted Tso wrote:
> On Thu, May 26, 2011 at 04:49:56PM +0200, Jan Kara wrote:
> >   But if we just fail all transaction allocations with say 10% probability,
> > it should work as well, shouldn't it? We'd just retry those allocations
> > whose failure we cannot handle and eventually succeed. Or do I miss
> > something?
> 
> The reason why I only wanted to fail the transactions relating to the
> writeback path is because other failures will get reflected back to
> userspace, and would thus change the behavior of the stress test.  (If
> we used fsstress, it would cause fsstress to immediately stop and
> fail, for example.)
  Ah, I see. OK.

> That is the one thing that worries me a little about this patch series
> in general.  If we suddenly start failing open() or rename() or
> chmod() syscalls with ENOMEM in low memory situations, what of
> programs that aren't doing adequate error checking?  Sure, other file
> systems will do this, but the bulk of the users use ext3/ext4, and
> remember how much kvetching and complaining when xfs was the first
> file system to require user space applications to actually use fsync()
> if they wanted their files to be safe after a power failure.
  Yeah, I know and it's painful to fight these fights. But ultimately, I
belive, it results in better / faster code so that's a good thing.

> I worry that there are a lot of incompetently written editors out
> there that aren't doing error checking, or worse yet, package managers
> or other security-critical programs that aren't doing error checking,
> and which won't notice when an syscall fails in a low-memory
> situation, leading to either (a) user data loss (which the application
> programers will lay at the feet of the file system developers, don't
> doubt it), or (b) security holes.
  But OTOH it allows good applications to do something (if nothing at least
displaying a dialog with error) instead of just being stuck in the kernel
which is a good thing IMHO. So I believe it is a move in the right
direction (although I agree there will be probably people bitching about it
;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
