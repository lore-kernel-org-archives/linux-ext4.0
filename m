From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing device caches should be flushed
Date: Wed, 21 Jan 2009 22:35:46 +0000
Message-ID: <20090121223546.GK16133@shareable.org>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com> <20090121125537.GB3186@duck.suse.cz> <20090121220322.GM2392@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50729 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZAUWfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jan 2009 17:35:48 -0500
Content-Disposition: inline
In-Reply-To: <20090121220322.GM2392@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Joel Becker wrote:
> 	You make a fair point about journaling filesystems - except, of
> course, that they don't really use barriers; mount defaults or
> device-mapper often preclude them.  So people with 'incorrect' barrier
> configurations get no fsync() safety.

I think maybe it's fair enough that if barrier=no fsync() safety
doesn't use barriers either.  Barriers mean it's safe on power loss -
on most disks and some RAID controllers.  No barriers is still useful
- it's maybe safe on system crash but not power loss, with some
performance gained.  So it's fair that it can be an admin decision.

Maybe a separate generic mount option for fsync safety would be good
though.  Interestingly, Windows is documented as letting the
application choose (limited by the constraints of the hardware), and
so is MacOSX.  That makes sense too.

> 	Regarding "filesystems without a backing device", that's why I
> said "we have backing_dev_info".  We can tell what the backing device
> is; we should be able to determine that no flush is needed without
> modifying those filesystems.
> 
> >   Finally, I prefer maintainers of the filesystems themselves to decide
> > whether their filesystem needs flushing and thus knowingly impose this
> > performance penalty on them...
> 
> 	I understand what you're thinking here, but that way defaults to
> an unsafe fsync().  Thus you're causing broken behavior in the hopes
> that maintainers pay enough attention to fix the behavior.

In this area, because the symptom of broken behaviour rarely shows up,
and when it does you don't know this is the culprit, it won't get
fixed passively.  As Nick says, we've had other fsync() bugs for ages
too, and it's hard to test if it's really correct, yet it's quite
important.

-- Jamie
