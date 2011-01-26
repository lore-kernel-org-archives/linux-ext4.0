From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount
 options
Date: Wed, 26 Jan 2011 10:36:32 +0100
Message-ID: <20110126093632.GB12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110126072329.GK27190@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Tue, Jan 25, 2011 at 11:23:29PM -0800, Darrick J. Wong wrote:
> As part of migrating the FLUSH/FUA knob to the block layer, remove the support
> code for the barrier-related mount options and remove the conditionals around
> flushes in favor of always issuing the flush.  The block layer will handle
> gracefully the situation where a FLUSH or FUA request is issued to a device
> that doesn't support it.  Modify the option parsing code to print a warning if
> someone tries to use the old mount option.
> 
> Note: The nobarrier bit in the default mount flags is now useless.

The option is something which users are already quite familiar with.
I think we'll just have to carry this around.  What we can do, tho, is
moving the actual control mechanism to block layer -
ie. blkdev_skip_flush() or something like that which ignores flush
requests for the current exclusive opener.

Thanks.

-- 
tejun
