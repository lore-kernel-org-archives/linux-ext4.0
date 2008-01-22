From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Tue, 22 Jan 2008 00:00:50 -0700
Message-ID: <20080122070050.GM3180@webber.adilger.int>
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com>
 <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com>
 <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com>
 <3673.1200975438@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <3673.1200975438@turing-police.cc.vt.edu>
Content-disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 21, 2008  23:17 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 22 Jan 2008 14:38:30 +1100, David Chinner said:
> > Perhaps instead of swapping immediately, a SIGLOWMEM could be sent
> > to a processes that aren't masking the signal followed by a short
> > grace period to allow the processes to free up some memory before
> > swapping out pages from that process?
> 
> AIX had SIGDANGER some 15 years ago.  Admittedly, that was sent when
> the system was about to hit OOM, not when it was about to start swapping.

I'd tried to advocate SIGDANGER some years ago as well, but none of
the kernel maintainers were interested.  It definitely makes sense
to have some sort of mechanism like this.  At the time I first brought
it up it was in conjunction with Netscape using too much cache on some
system, but it would be just as useful for all kinds of other memory-
hungry applications.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

