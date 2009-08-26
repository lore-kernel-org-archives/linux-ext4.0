From: Jan Kara <jack@suse.cz>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 26 Aug 2009 18:02:31 +0200
Message-ID: <20090826160231.GA28867@atrey.karlin.mff.cuni.cz>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int> <20090825001554.GN17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48719 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZHZQCa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 12:02:30 -0400
Content-Disposition: inline
In-Reply-To: <20090825001554.GN17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Aug 24, 2009 at 05:43:36PM -0600, Andreas Dilger wrote:
> > Without transaction checksums waiting on all of the blocks together
> > is NOT safe.  If the commit record is on disk, but the rest of the
> > transaction's blocks are not then during replay it may cause garbage
> > to be written from the journal into the filesystem metadata.
> 
> Yes, I *said* that we can only wait on all of the blocks together with
> the commit record when doing journal checksums.  Sorry if I didn't
> make that clear enough.
  I suppose we talk about the case when write caches are turned off and
we use barrier=0 (because case barrier=1 does not really care about when
we wait for the blocks from the correctness POV - at least according to
Documentation/block/barrier.txt). In that case, you have to wait for
*data* blocks before writing the commit block because you have no
checksumming of those...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
