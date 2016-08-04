From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Thu, 4 Aug 2016 12:46:02 -0600
Message-ID: <20160804184602.GA3128@linux.intel.com>
References: <1470331056-796-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, minchan@kernel.org, ngupta@vflare.org,
	vishal.l.verma@intel.com, axboe@kernel.dk,
	Christoph Hellwig <hch@infradead.org>
To: Mike Christie <mchristi@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470331056-796-1-git-send-email-mchristi@redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 04, 2016 at 12:17:36PM -0500, Mike Christie wrote:
> This fixes a regression from
> 4e1b2d52a80d79296a5d899d73249748dea71a53
> block, fs, drivers: remove REQ_OP compat defs and related code
> 
> The rw_page users were not converted to use bio/req ops. As a result
> bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
> be sent down as reads.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>

Was the intention for this to fix the xfs.mkfs hang I reported with
generic/361 + XFS?

I'm still able to reproduce that hang with this patch applied to the current
linux/master (c1ece76 (linux/master) Merge tag 'media/v4.8-5' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media)

Thanks,
- Ross
