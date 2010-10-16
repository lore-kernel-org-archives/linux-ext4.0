From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Fri, 15 Oct 2010 17:02:08 -0700
Message-ID: <20101016000208.GH25624@tux1.beaverton.ibm.com>
References: <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <4CAF937C.4020500@redhat.com> <20101011202020.GF25624@tux1.beaverton.ibm.com> <20101012141455.GA27572@lst.de> <20101015233904.GG25624@tux1.beaverton.ibm.com> <20101015234041.GB1035@lst.de>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51754 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0JPACS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Oct 2010 20:02:18 -0400
Content-Disposition: inline
In-Reply-To: <20101015234041.GB1035@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 16, 2010 at 01:40:41AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 15, 2010 at 04:39:04PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 12, 2010 at 04:14:55PM +0200, Christoph Hellwig wrote:
> > > I still think adding code to every filesystem to optimize for a rather
> > > stupid use case is not a good idea.  I dropped out a bit from the
> > > thread in the middle, but what was the real use case for lots of
> > > concurrent fsyncs on the same inode again?
> > 
> > The use case I'm looking at is concurrent fsyncs on /different/ inodes,
> > actually.  We have _n_ different processes, each writing (and fsyncing) its own
> > separate file on the same filesystem.
> > 
> > iirc, ext4_sync_file is called with the inode mutex held, which prevents
> > concurrent fsyncs on the same inode.
> 
> Indeed.  Although we could drop it at least for the cache flush
> call.  We already do this for block devices.

<nod>

Unfortunately, the patch immediately triggers the BUG at
drivers/scsi/scsi_lib.c:1064:
 /*
  * BLOCK_PC requests may transfer data, in which case they must
  * a bio attached to them.  Or they might contain a SCSI command
  * that does not transfer data, in which case they may optionally
  * submit a request without an attached bio.
  */
 if (req->bio) {
         int ret;

         BUG_ON(!req->nr_phys_segments);

--D
