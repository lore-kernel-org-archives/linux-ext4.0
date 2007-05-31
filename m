From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 0/2] i_version update
Date: Thu, 31 May 2007 10:33:44 +1000
Message-ID: <20070531003344.GD85884050@sgi.com>
References: <46570DFB.3080101@bull.net> <20070530002100.GV85884050@sgi.com> <1180567978.3794.28.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1180567978.3794.28.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 30, 2007 at 04:32:57PM -0700, Mingming Cao wrote:
> On Wed, 2007-05-30 at 10:21 +1000, David Chinner wrote:
> > On Fri, May 25, 2007 at 06:25:31PM +0200, Jean noel Cordenner wrote:
> > > Hi,
> > > 
> > > This is an update of the i_version patch.
> > > The i_version field is a 64bit counter that is set on every inode
> > > creation and that is incremented every time the inode data is modified
> > > (similarly to the "ctime" time-stamp).
> > 
> > My understanding (please correct me if I'm wrong) is that the
> > requirements are much more rigourous than simply incrementing an in
> > memory counter on every change.  i.e. the this counter has to
> > survive server crashes intact so clients never see the counter go
> > backwards. That means version number changes need to be journalled
> > along with the operation that caused the change of the version
> > number.
> > 
> Yeah, the i_version is the in memeory counter. From the patch it looks
> like the counter is being updated inside ext4_mark_iloc_dirty(), so it
> is being journalled and being flush to on-disk ext4 inode structure
> immediately (On-disk ext4 inode structure is being modified/expanded to
> store the counter in the first patch). 

Ok, that catches most things (I missed that), but the version number still
needs to change on file data changes, right? So if we are overwriting the
file, we're calling __mark_inode_dirty(I_DIRTY_PAGES) which means you don't
get the callout and so the version number doesn't change or get logged. In
that case, the version number is not doing what it needs to do, right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
