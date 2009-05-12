From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Tue, 12 May 2009 17:04:46 -0400
Message-ID: <20090512210446.GD23773@mit.edu>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com> <4A086763.9090907@redhat.com> <20090511182050.GA3209@webber.adilger.int> <4A087202.4010601@redhat.com> <71a0d6ff0905120455x291d7280ybe8d1a562987fd1b@mail.gmail.com> <20090512121305.GL21518@mit.edu> <71a0d6ff0905120549h628146d8p3def31b09b79199a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Alexander Shishkin <alexander.shishckin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46060 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZELVEu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 17:04:50 -0400
Content-Disposition: inline
In-Reply-To: <71a0d6ff0905120549h628146d8p3def31b09b79199a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 12, 2009 at 03:49:30PM +0300, Alexander Shishkin wrote:
> 
> So, what Andreas explained yesterday also applies to the internal log
> case. I see. Would you say it's possible to prevent this, for instance
> somehow say, by means checksums as Andreas suggested?
> 

It's *possible*, but it's not a trivial amount of work; it requires
both kernel and userspace changes, though.

> It's an mmc and it (mkfs) runs almost two times faster without zeroing
> the journal. The only thing I'm worried about is the time that it
> takes for mke2fs -j to complete. I've done some caching trickery to
> unix_io.c which I'm going to post here separately, but most of the
> time seems to be taken by the journal.

But why do you care about the time it akes for mke2fs -j to complete?
How much time is it taking?  Normally mke2fs isn't one of those
programs which gets run all the time....

					- Ted
