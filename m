From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Wed, 6 Apr 2011 09:44:28 -0400
Message-ID: <20110406134428.GA17705@infradead.org>
References: <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
 <20110331234050.GD2904@dastard>
 <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110406112135.GE31057@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 06, 2011 at 09:21:35PM +1000, Dave Chinner wrote:
> Sure, but the question must be asked - why is ext3/4 even starting a
> transaction on a clean filesystem during sync? A frozen filesystem,
> by definition, is a clean filesytem, and therefore sync calls of any
> kind should not be trying to write to the FS or start transactions.
> XFS does this just fine, so I'd consider such behaviour on a frozen
> filesystem a bug in ext3/4...

XFS does have one special case for this.  When writing the dummy log
record at the end of the freeze process we use _xfs_alloc_trans to
bypass the frozen filesystem check as we have to write out this record
when the filesystem already is frozen.  But that's after the main
sync with its normal transactions.

