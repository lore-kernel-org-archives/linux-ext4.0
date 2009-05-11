From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 11:43:23 -0700
Message-ID: <20090511184323.GA16885@linux.intel.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090511081216.GK4694@kernel.dk> <20090511084121.GB29082@mit.edu> <1242062325.9647.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1242062325.9647.4.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 01:18:45PM -0400, Chris Mason wrote:
> For both btrfs and lvm, the filesystem is going to maintain free block
> information based on logical block numbers.  The generic trim layer
> should probably be based on a logical address that is stored per-bdi.
> 
> Then the bdi will need a callback to turn the logical address based trim
> extent into physical extents on N number of physical device.
> 
> The tricky part is how will the FS decide a given block is actually
> reusable.  We'll need a call back into the FS that indicates trim is
> complete on a given logical extent.

Actually, that's the exact opposite of what you want.  You want to try
to reuse blocks that are scheduled for trimming so that we never have to
send the command at all.
