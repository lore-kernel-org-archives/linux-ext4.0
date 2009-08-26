From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 26 Aug 2009 16:00:45 -0600
Message-ID: <20090826220045.GG4197@webber.adilger.int>
References: <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com>
 <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int>
 <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int>
 <4A94287C.9060509@redhat.com> <20090825211132.GV17684@mit.edu>
 <20090826095035.GH5931@webber.adilger.int> <20090826131403.GN32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53411 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZHZWA4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 18:00:56 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7QM0rV5029610
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:00:53 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP0004007Q0EN00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 26 Aug 2009 15:00:53 -0700 (PDT)
In-reply-to: <20090826131403.GN32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 26, 2009  09:14 -0400, Theodore Ts'o wrote:
> On Wed, Aug 26, 2009 at 03:50:35AM -0600, Andreas Dilger wrote:
> > I'm not sure I understand about the "n.b." case.  If the filesystem
> > is running with !async_commit,barrier=0,"hdparm -W 0" (which is basically
> > ext3 with write cache off), it should still have the jbd code doing
> > an explicit wait for the data blocks (which should be guaranteed to
> > make it to disk, wcache being off) before even submitting the commit
> > block to the elevator?  It doesn't matter what order the transaction
> > blocks are written to disk, so long as the commit block is last.
> 
> Gack, sorry, I screwed that up.  What I should have written is this:
> 
> The safe configurations people could try benchmarking:
> 
>       !async_commit,barrier=1,"hdparm -W 1"	(currently the default)
>       !async_commit,barrier=0,"hdparm -W 0"
>       async_commit,barrier=1,"hdparm -W 1"
> 
> and the unsafe case in the nb should have been <async_commit,
> barrier=0, "hdparm -W 0">, since without the barrier, async_commit
> writes the commit block at the same time as the rest of the journal
> (data, metadata, and revoke) blocks, and so there is the chance the
> commit block could get reordered in front of the other journal blocks.

I'm still missing something.  With async_commit enabled, it doesn't
matter if the commit block is reordered, since the transaction checksum
will verify if all of the data + commit block are written for that
transaction, in case of a crash.  That is the whole point of async_commit.
If the commit block is on disk, but there are some transaction blocks
missing the checksum will (except in very rare coincidences) fail and the
transaction is skipped.  With "hdparm -W 0" we are guaranteed to only
have a single uncommitted transaction, except in the case of journal
corruption (i.e. disk error or software bug).

I can imagine with "async_commit,barrier=0,"hdparm -W 1" that having
multiple transactions begin checkpointing before they are fully
committed, which means the filesystem is modified in a non-recoverable
way.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

