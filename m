From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Tue, 12 May 2009 08:13:06 -0400
Message-ID: <20090512121305.GL21518@mit.edu>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com> <4A086763.9090907@redhat.com> <20090511182050.GA3209@webber.adilger.int> <4A087202.4010601@redhat.com> <71a0d6ff0905120455x291d7280ybe8d1a562987fd1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Alexander Shishkin <alexander.shishckin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60164 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZELMNL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 08:13:11 -0400
Content-Disposition: inline
In-Reply-To: <71a0d6ff0905120455x291d7280ybe8d1a562987fd1b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 12, 2009 at 02:55:10PM +0300, Alexander Shishkin wrote:
> On 11 May 2009 21:44, Eric Sandeen <sandeen@redhat.com> wrote:
> > Andreas Dilger wrote:
> >
> >> The reason that the journal is zeroed is because there is some chance
> >> that old (valid at the time) transaction headers and commit blocks might
> >> be in the journal and could accidentally be "recovered" and cause bad
> >> corruption of the filesystem.
> >
> > But I guess the question is, why isn't a normal internal log zeroed?
> >
> > If I'm reading it right only external logs get this treatment, and I
> > think that's what generated the original question from Alexander.
> 
> My concern was basically if it is safe to skip zeroing for internal journal.

Strictly speaking, no.  Most of the time you'll get lucky.  The place
where you will get into trouble will be is if there is leftover
uninitialized garbage (particularly if you are reformatting an
existing ext3/4 filesystem) that looks like a journal log block, with
the correct journal transaction number, *and* the system crashes
before the journal has been completely written through at least once.

What precisely is your concern?  Normally the journal isn't that big,
and it's a contiguous write --- so it doesn't take that long.  Are you
worried about the time it takes, or trying to avoid some writes to an
SSD, or some other concern?  If we know it's an SSD, where reads are
fast, and writes are slow, I suppose we could scan the disk looking
for potentially dangerous blocks and zero them manually.  It's really
not clear it's worth the effort though.

						- Ted
