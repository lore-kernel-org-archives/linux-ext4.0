From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Date: Thu, 28 Jun 2007 23:37:50 +0530
Message-ID: <20070628180750.GB1674@amitarora.in.ibm.com>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com> <20070625215625.GL5181@schatzie.adilger.int> <20070626120751.GC19870@amitarora.in.ibm.com> <20070626161400.GE6652@schatzie.adilger.int> <20070626192908.GC13324@amitarora.in.ibm.com> <20070627000456.GT31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	xfs@oss.sgi.com
To: David Chinner <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070627000456.GT31489@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 27, 2007 at 10:04:56AM +1000, David Chinner wrote:
> On Wed, Jun 27, 2007 at 12:59:08AM +0530, Amit K. Arora wrote:
> > On Tue, Jun 26, 2007 at 12:14:00PM -0400, Andreas Dilger wrote:
> > > On Jun 26, 2007  17:37 +0530, Amit K. Arora wrote:
> > > > I think, modifying ctime/mtime should be dependent on the other flags.
> > > > E.g., if we do not zero out data blocks on allocation/deallocation,
> > > > update only ctime. Otherwise, update ctime and mtime both.
> > > 
> > > I'm only being the advocate for requirements David Chinner has put
> > > forward due to existing behaviour in XFS.  This is one of the reasons
> > > why I think the "flags" mechanism we now have - we can encode the
> > > various different behaviours in any way we want and leave it to the
> > > caller.
> > 
> > I understand. May be we can confirm once more with David Chinner if this
> > is really required. Will it really be a compatibility issue if new XFS
> > preallocations (ie. via fallocate) update mtime/ctime?
> 
> It should be left up to the filesystem to decide. Only the
> filesystem knows whether something changed and the timestamp should
> or should not be updated.

Since Andreas had suggested FA_FL_NO_MTIME flag thinking it as a
requirement from XFS (whereas XFS does not need this flag), I don't think
we need to add this new flag.

Please let know if someone still feels FA_FL_NO_MTIME flag can be
useful.

--
Regards,
Amit Arora

