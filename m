From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 13:58:10 -0400
Message-ID: <20080914175810.GB13074@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <20080914134859.GB21746@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55244 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbYINSCm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 14:02:42 -0400
Content-Disposition: inline
In-Reply-To: <20080914134859.GB21746@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 09:48:59AM -0400, Christoph Hellwig wrote:
> Let's make it clear, I've said to not add it unless we have users.  And
> What Anton brought up is exactly the reason for that - to support
> encrypted extents we actually need more information in the structure.
> That's why we need to have this broad and sometimes a little slow
> discussion on fsdevel instead of just rushing in some flag for future
> use that won't make any sense in the end.

You're incorrect here.  Encrypted extents does not require any
additional information in the structure.  Compressed extents are a bit
more useful if we allow the the filesystem to return the amount of
space used on the storage device, but as Anton has pointed out, it's
not strictly required for ntfs (although it would be more useful for
cramfs).  But that being said, the fundamental question here is
whether we should try to plan for future users of the data structure,
and reserve space now for the, or not.  Your approach of saying Nein!
Nein!  Nein! for every single feature where we don't have
implementation pretty much guarantees that we will need to expand the
structure later to make room for these extra fields, and then we'll
need to define a new ioctl and have similar complexity to the stat
system call to support multiple userspace interfaces.  If we try to
anticipate new users in advance, then there is at least a *chance*
we'll get it right up front.

The big problem here is that if we try for a generic interface, we
*will* end up stalling for every as some people ask for new features,
and other people (like you) push back on it.  And in the mean time, we
make no progress.

I'd like to break through the logjam, *somehow*.  I can see three
possible paths:

	* We reserve space for likely features that could likely be
          used by real life filesystems that exist today.  

	* We don't, and accept the fact that later on we will need to
	  revise the interface, with the resulting hair that this
	  will mean to the kernel.

	* I push an ext4-specific ioctl to Linus.

I don't particularly care *which* one we choose, but I'd like for us
to make a choice, and then move forward, instead of spinning endlessly.

And no, I haven't made anything up.  I'm leaving names out because the
accusation was really out of line, and really unfair, so I want to
spare the embarassment of the accuser and the accused, but ask Andrew
Morton for confirmation if you want.  This has gotten beyond
ridiculous, and I'd really like us to make a decision, and move *on*.

   	  	      	   		 	    - Ted
