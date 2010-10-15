From: Christoph Hellwig <hch@lst.de>
Subject: Re: Performance testing of various barrier reduction patches [was: Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Sat, 16 Oct 2010 01:40:41 +0200
Message-ID: <20101015234041.GB1035@lst.de>
References: <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <4CAF937C.4020500@redhat.com> <20101011202020.GF25624@tux1.beaverton.ibm.com> <20101012141455.GA27572@lst.de> <20101015233904.GG25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101015233904.GG25624@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 15, 2010 at 04:39:04PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 12, 2010 at 04:14:55PM +0200, Christoph Hellwig wrote:
> > I still think adding code to every filesystem to optimize for a rather
> > stupid use case is not a good idea.  I dropped out a bit from the
> > thread in the middle, but what was the real use case for lots of
> > concurrent fsyncs on the same inode again?
> 
> The use case I'm looking at is concurrent fsyncs on /different/ inodes,
> actually.  We have _n_ different processes, each writing (and fsyncing) its own
> separate file on the same filesystem.
> 
> iirc, ext4_sync_file is called with the inode mutex held, which prevents
> concurrent fsyncs on the same inode.

Indeed.  Although we could drop it at least for the cache flush
call.  We already do this for block devices.
