From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Mon, 30 Apr 2007 21:39:06 -0700
Message-ID: <1177994346.3362.5.camel@entropy>
References: <20070412110550.GM5967@schatzie.adilger.int>
	 <20070416112252.GJ48531920@melbourne.sgi.com>
	 <20070419002139.GK5967@schatzie.adilger.int>
	 <20070419015426.GM48531920@melbourne.sgi.com>
	 <20070430224401.GX5967@schatzie.adilger.int>
	 <20070501042254.GD77450368@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        hch@infradead.org
To: David Chinner <dgc@sgi.com>
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <20070501042254.GD77450368@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-05-01 at 14:22 +1000, David Chinner wrote:
> On Mon, Apr 30, 2007 at 04:44:01PM -0600, Andreas Dilger wrote:
> > On Apr 19, 2007  11:54 +1000, David Chinner wrote:
> > > > struct fiemap {
> > > > 	__u64 fm_start;		/* logical start offset of mapping (in/out) */
> > > > 	__u64 fm_len;		/* logical length of mapping (in/out) */
> > > > 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
> > > > 	__u32 fm_extent_count;	/* number of extents in fm_extents (in/out) */
> > > > 	__u64 fm_unused;
> > > > 	struct fiemap_extent fm_extents[0];
> > > > }
> > > > 
> > > > /* flags for the fiemap request */
> > > > #define FIEMAP_FLAG_SYNC	0x00000001	/* flush delalloc data to disk*/
> > > > #define FIEMAP_FLAG_HSM_READ	0x00000002	/* retrieve data from HSM */
> > > > #define FIEMAP_FLAG_INCOMPAT    0xff000000	/* must understand these flags*/
> > > 
> > > No flags in the INCOMPAT range - shouldn't it be 0x3 at this point?
> > 
> > This is actually for future use.  Any flags that are added into this range
> > must be understood by both sides or it should be considered an error.  Flags
> > outside the FIEMAP_FLAG_INCOMPAT do not necessarily need to be supported.
> > If it turns out that 8 bits is too small a range for INCOMPAT flags, then
> > we can make 0x01000000 an incompat flag that means e.g. 0x00ff0000 are also
> > incompat flags also.
> 
> Ah, ok. So it's not really a set of "compatibility" flags,
> it's more a "compulsory" set. Under those terms, i don't really
> see why this is necessary - either the filesystem will understand
> the flags or it will return EINVAL or ignore them...
> 
> > I'm assuming that all flags that will be in the original FIEMAP proposal
> > will be understood by the implementations.  Most filesystems can safely
> > ignore FLAG_HSM_READ, for example, since they don't support HSM, and for
> > that matter FLAG_SYNC is probably moot for most filesystems also because
> > they do block allocation at preprw time.
> 
> Exactly my point - so why do we really need to encode a compulsory set
> of flags in the API? 
> 

Because flags have meaning, independent of whether or not the filesystem
understands them. And if the filesystem chooses to ignore critically
important flags (instead of returning EINVAL), bad things may happen.

So, either the filesystem will understand the flag
or iff the unknown flag is in the incompat set, it will return EINVAL
or else the unknown flag will be safely ignored.

-- 
Nicholas Miell <nmiell@comcast.net>
