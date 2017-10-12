From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 16/19] ext4: Support for synchronous DAX faults
Date: Thu, 12 Oct 2017 15:42:57 +0200
Message-ID: <20171012134257.GF29293@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-17-jack@suse.cz>
 <CAPcyv4h4VdGJ0zV6cOFOs6=ufo49WDgSUbmmL2cmDVdc1edraw@mail.gmail.com>
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
In-Reply-To: <CAPcyv4h4VdGJ0zV6cOFOs6=ufo49WDgSUbmmL2cmDVdc1edraw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 11-10-17 15:23:21, Dan Williams wrote:
> On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> > We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin()
> 
> I assume this a stale changelog from a previous version and should be
> VM_FAULT_NEEDDSYNC?

Yeah, stale changelog. It should be IOMAP_F_DIRTY. Thanks for catching
this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
