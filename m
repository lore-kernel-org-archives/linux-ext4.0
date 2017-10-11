From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/19 v3] dax, ext4, xfs: Synchronous page faults
Date: Thu, 12 Oct 2017 09:43:31 +1100
Message-ID: <20171011224331.GB3666@dastard>
References: <20171011200603.27442-1-jack@suse.cz>
 <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4g6tjyUy_zxVVze+C+xZiT89qa1GiSoVjhH3G-6r3eXDA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 11, 2017 at 02:18:06PM -0700, Dan Williams wrote:
> On Wed, Oct 11, 2017 at 1:05 PM, Jan Kara <jack@suse.cz> wrote:
> > Anyway, here are the patches and AFAICT the series is pretty much complete
> > so we can start thinking how to merge this. Changes to ext4 / XFS are pretty
> > minimal so either tree is fine I guess. Comments are welcome.
> 
> I'd like to propose taking this through the nvdimm tree. Some of these
> changes make the MAP_DIRECT support for ext4 easier, so I'd like to
> rebase that support on top and carry both.

This functionality needs to be exercised and stressed by fstests
in some way before it gets merged.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
