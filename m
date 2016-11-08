From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] dax: Introduce IOMAP_FAULT flag
Date: Wed, 9 Nov 2016 10:21:14 +1100
Message-ID: <20161108232114.GR28177@dastard>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478603297-11793-8-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 08, 2016 at 12:08:13PM +0100, Jan Kara wrote:
> Introduce a flag telling iomap operations whether they are handling a
> fault or other IO. That may influence behavior wrt inode size and
> similar things.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
