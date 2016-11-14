From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/11] ext4: Avoid split extents for DAX writes
Date: Mon, 14 Nov 2016 09:54:19 +0100
Message-ID: <20161114085419.GC2524@quack2.suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-7-git-send-email-jack@suse.cz>
 <20161111202547.GA1569@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161111202547.GA1569@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 11-11-16 13:25:47, Ross Zwisler wrote:
> On Tue, Nov 08, 2016 at 12:08:12PM +0100, Jan Kara wrote:
> > Currently mapping of blocks for DAX writes happen with
> > EXT4_GET_BLOCKS_PRE_IO flag set. That has a result that each
> > ext4_map_blocks() call creates a separate written extent, although it
> > could be merged to the neighboring extents in the extent tree.  The
> > reason for using this flag is that in case the extent is unwritten, we
> > need to convert it to written one and zero it out. However this "convert
> > mapped range to written" operation is already implemented by
> > ext4_map_blocks() for the case of data writes into unwritten extent. So
> > just use flags for that mode of operation, simplify the code, and avoid
> > unnecessary split extents.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> The code that this patch modifies was just introduced in the previous patch.
> Is there a reason to keep both patches, or would it be cleaner just to squash
> them and have one patch that introduces the code as you intend for it to end
> up?

Well, the previous patch just mostly moved the block allocation logic from
dedicated DAX get_block function into iomap_begin(). This patch changes the
block allocation logic so I prefer to keep them separate - mostly for the
sake of documenting the change how allocation of blocks for DAX works in the
changelog.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
