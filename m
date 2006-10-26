From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 03:30:30 -0600
Message-ID: <20061026093030.GL3509@schatzie.adilger.int>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org> <20061024230020.GZ3509@schatzie.adilger.int> <20061025145450.GF21082@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, David Chinner <dgc@sgi.com>,
	Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061025145450.GF21082@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 25, 2006  16:54 +0200, Jan Kara wrote:
> I've just not yet decided how to handle indirect
> blocks in case of relocation in the middle of the file. Should they be
> relocated or shouldn't they? Probably they should be relocated at least
> in case they are fully contained in relocated interval or maybe better
> said when all the blocks they reference to are also in the interval
> (this handles also the case of EOF). But still if you would like to
> relocate the file by parts this is not quite what you want (you won't be
> able to relocate indirect blocks in the boundary of intervals) :(.

I suspect that the natural choice for metadata blocks is to keep the
block which has the most metadata unchanged.  For example, if you are
doing a full-file relocation then you would naturally keep all of the
new {dt}indirect blocks.  If you are relocating a small chunk of the
file you would keep the old {dt}indirect blocks and just copy a few
block pointers over.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

