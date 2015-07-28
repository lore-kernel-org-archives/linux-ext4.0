From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic/064 test failures on ext4 (4.2-rc*)
Date: Mon, 27 Jul 2015 23:09:13 -0400
Message-ID: <20150728030913.GC2851@thunk.org>
References: <20150727190957.GA1606@localhost.localdomain>
 <20150727215129.GH3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, namjae.jeon@samsung.com,
	a.sangwan@samsung.com, linux-ext4@vger.kernel.org,
	fstests@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150727215129.GH3902@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 28, 2015 at 07:51:29AM +1000, Dave Chinner wrote:
> The block layout outside the insert range should not be modified at
> all, so if inserting 100 holes results in more data extents that the
> expected 100, then there's something wrong before we start inserting
> holes.  e.g. maybe the source file had two extents rather than 1.
> Can you confirm that this is occurring?

Yes, that's what is going on.  If delayed allocation is disabled (as
it is in some configuration scenarios), ext4's block allocator doesn't
do as well, and in some cases it will pick a starting block number for
the file that ends up splitting the initial file across block groups'
meta data blocks.

> Really, the number of extents or holes at the intermediate stage
> doesn't matter. What matters is that after collapsing the holes back
> out of the file, then number of extents is identical to the original
> file (i.e. that fcollapse() undoes finsert() exactly).

Yup.

> So changing this code to use _within_tolerance to say that 100 >=
> num_extents >= 105 is ok would probably be better:
> 
> 	_within_tolerance "Extent count" $nextents 100 0 5%
> 
> This will output a standard pass/fail message rather than an exact
> count.  This allows some wiggle room for filesystem configurations
> that have unexpected non-contiguous baseline allocation behaviour to
> pass the test.

Works for me.

Thanks,

					- Ted
