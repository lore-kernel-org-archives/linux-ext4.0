From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 10:50:59 -0400
Message-ID: <20090511145059.GD6277@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu> <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com> <20090511142740.GC6277@mit.edu> <4A08365F.5040805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A08365F.5040805@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 10:29:51AM -0400, Ric Wheeler wrote:
>
> The key is not at the FS layer - this is an issue for people who RAID 
> these beasts together and want to actually check that the bits are what 
> they should be (say doing a checksum validity check for a stripe).
>

Good point, yes I can see why they need that.  In that case, the
storage device can't just silently truncate a TRIM request; it would
have to expose to the OS its alignment requirements.  The risk though
is that more they try push this compleixity into the OS, the higher
the risk that the OS will simply decide not to take advantage of the
functionality.  Of course, there is the question why anyone would want
to build a software-raid device on top of a thin-provisioned hardware
storage unit.  :-)

						- Ted
