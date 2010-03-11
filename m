From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 13:54:42 -0600
Message-ID: <4B994A82.8010204@redhat.com>
References: <4B991C81.5040506@redhat.com> <20100311194032.GI1497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0CKTyv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 14:54:51 -0500
In-Reply-To: <20100311194032.GI1497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Thu, Mar 11, 2010 at 10:38:25AM -0600, Eric Sandeen wrote:
>> Jan suggests that we not surprise users by having delalloc enabled when ext3
>> is mounted with the ext4 driver.  However there are other behavior differences
>> as well, mballoc behavior comes to mind at least.  What about the 32000 subdir
>> limit?  
> 
> The block allocator behaviour does change, but not in user-visible
> fashion.  And there have been times in the past when we've messed with
> the ext3's allocation algorithms (Mingming's reservation windows being
> the most recent example), and that falls pretty squarely into a
> non-user visible (aside from a performance increase) change.
> 
> Breaking the subdir limit requires a feature flag (DIR_NLINK) so it's
> not something that would be seen when mounting an ext3-compatible file
> system using ext4.
> 
> The reason why disabling delalloc by default when using ext4 to
> emulate ext3 may make sense is because it does have a potentially
> controversial impact with respect to applications which don't fsync()
> but which assumes that data blocks will magically be sync'ed to disk
> after five seconds.  I disagree with that assumption, but the number
> of clueless application writers and users who have come to depend on
> it outnumber us by a fairly wide margin.
> 
>> I guess my point here is I think we have completely crossed the line of a
>> coherent story of what ext4 is and how it's supported and tested; things are
>> feeling so tuning-knob-option-happy and full of caveats that our matrix looks
>> infinite from where I stand.
>>
>> This option won't be enabled on fedora or rhel, (and I don't mean to single out 
>> this particular commit, it just got me started on this train of thought)
>> but I just wanted to air a general concern that ext4 not try to be 10,000 different 
>> things to all people, and focus on something testable, documentable, and supportable.
>>
>> For myself and the distros I work on, I strongly prefer to limit things to:
>>
>> a) filesystems mkfs'd and mounted as ext4
>> b) ext3 filesystems migrated according to a very specific set of steps
>>
>> All these other sub-cases and what-ifs and except-unless behaviors really
>> muddy the water, IMHO.
> 
> I think it's completely fair that Red Hat picks a subset of features
> to concentrate their testing and support on.  And I am very
> sympathetic to the concerns of our exploding test matrix if we want to
> have complete coverage.

Just to be clear, I -certainly- don't mean to say that if Red Hat doesn't
want it, upstream shouldn't work on it... but I have these concerns with
my upstream hat on, as much as with my red one.

> At the same time, there is some benefit in growing our community by
> support some other alternatives, which might not be that useful in the
> general case, or for an enterprise distro.  So as we don't contaminate
> core code, and we can keep the code vaguely maintainable, a certain
> amount of flexibility and options is good.

As long as it doesn't contaminate the "core" then sure, but the more twisty
paths we have, the less likely any of them will be maintainable.  :)

I just think that before adding more knobs, we need to take a long hard
look at what it does to the big picture.  When documenting ext4 upstream,
how many "if ... else if ... else if" clauses do we need?

Just something to think about.

> I do think that it was highly reassuring to some key users of our
> userbase because we supported the use case of people who wanted to be
> able to use unmigrated ext2/3 file systems with the ability go back to
> ext2/3 afterwards.  And the fact that in general e2fsck is more strict
> about file system consistency issues than the kernel, and e2fsck shows
> a clean file system after mounting an unmodified ext2/3 file system
> does reassure me.  (And I will perform, from time to time, XFSQA tests
> using an ext2-compatible file system mounted using ext4).  So that's
> why I was pretty comfortable with the CONFIG_EXT4_USE_FOR_EXT23 option.
> 
> And hey, users who used it quickly found a problem how we calculated
> indirect-mapped metablock reservations much more quickly than if we
> didn't have this option --- and this bug is one that would have
> eventually hit your "migrated ext3 file systems" case, except much
> more rarely, so the end result was a more robust file system.  
> 
> So at least in this case, I think it was actually a net benefit.

Agreed, but I'd say we got lucky this time in that respect ;)

Thanks,
-Eric

> Regards,
> 
> 					- Ted

