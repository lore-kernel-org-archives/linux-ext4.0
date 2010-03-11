From: tytso@mit.edu
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 14:40:32 -0500
Message-ID: <20100311194032.GI1497@thunk.org>
References: <4B991C81.5040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53133 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933862Ab0CKTke (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 14:40:34 -0500
Content-Disposition: inline
In-Reply-To: <4B991C81.5040506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 11, 2010 at 10:38:25AM -0600, Eric Sandeen wrote:
> Jan suggests that we not surprise users by having delalloc enabled when ext3
> is mounted with the ext4 driver.  However there are other behavior differences
> as well, mballoc behavior comes to mind at least.  What about the 32000 subdir
> limit?  

The block allocator behaviour does change, but not in user-visible
fashion.  And there have been times in the past when we've messed with
the ext3's allocation algorithms (Mingming's reservation windows being
the most recent example), and that falls pretty squarely into a
non-user visible (aside from a performance increase) change.

Breaking the subdir limit requires a feature flag (DIR_NLINK) so it's
not something that would be seen when mounting an ext3-compatible file
system using ext4.

The reason why disabling delalloc by default when using ext4 to
emulate ext3 may make sense is because it does have a potentially
controversial impact with respect to applications which don't fsync()
but which assumes that data blocks will magically be sync'ed to disk
after five seconds.  I disagree with that assumption, but the number
of clueless application writers and users who have come to depend on
it outnumber us by a fairly wide margin.

> I guess my point here is I think we have completely crossed the line of a
> coherent story of what ext4 is and how it's supported and tested; things are
> feeling so tuning-knob-option-happy and full of caveats that our matrix looks
> infinite from where I stand.
> 
> This option won't be enabled on fedora or rhel, (and I don't mean to single out 
> this particular commit, it just got me started on this train of thought)
> but I just wanted to air a general concern that ext4 not try to be 10,000 different 
> things to all people, and focus on something testable, documentable, and supportable.
> 
> For myself and the distros I work on, I strongly prefer to limit things to:
> 
> a) filesystems mkfs'd and mounted as ext4
> b) ext3 filesystems migrated according to a very specific set of steps
> 
> All these other sub-cases and what-ifs and except-unless behaviors really
> muddy the water, IMHO.

I think it's completely fair that Red Hat picks a subset of features
to concentrate their testing and support on.  And I am very
sympathetic to the concerns of our exploding test matrix if we want to
have complete coverage.

At the same time, there is some benefit in growing our community by
support some other alternatives, which might not be that useful in the
general case, or for an enterprise distro.  So as we don't contaminate
core code, and we can keep the code vaguely maintainable, a certain
amount of flexibility and options is good.

I do think that it was highly reassuring to some key users of our
userbase because we supported the use case of people who wanted to be
able to use unmigrated ext2/3 file systems with the ability go back to
ext2/3 afterwards.  And the fact that in general e2fsck is more strict
about file system consistency issues than the kernel, and e2fsck shows
a clean file system after mounting an unmodified ext2/3 file system
does reassure me.  (And I will perform, from time to time, XFSQA tests
using an ext2-compatible file system mounted using ext4).  So that's
why I was pretty comfortable with the CONFIG_EXT4_USE_FOR_EXT23 option.

And hey, users who used it quickly found a problem how we calculated
indirect-mapped metablock reservations much more quickly than if we
didn't have this option --- and this bug is one that would have
eventually hit your "migrated ext3 file systems" case, except much
more rarely, so the end result was a more robust file system.  

So at least in this case, I think it was actually a net benefit.

Regards,

					- Ted
