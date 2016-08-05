From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Fri, 5 Aug 2016 00:53:35 -0700
Message-ID: <20160805075335.GA20445@infradead.org>
References: <201608050158.hllBWy4G%fengguang.wu@intel.com>
 <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
 <20160805021854.GV12670@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, kbuild test robot <lkp@intel.com>,
	Mike Christie <mchristi@redhat.com>, kbuild-all@01.org,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	minchan@kernel.org, ngupta@vflare.org, vishal.l.verma@intel.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbcHEHxj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2016 03:53:39 -0400
Content-Disposition: inline
In-Reply-To: <20160805021854.GV12670@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 05, 2016 at 12:18:55PM +1000, Dave Chinner wrote:
> Give this is being spread all over the kernel way outside the block
> layer and IO path, shouldn't this have some kind of namespace
> component to the name? i.e "req_op_is_write()"?

The READ/WRITE #defines alias to the request ops, so this helper is
rather global as well.  Not that I like it, but it will take a while
to clean that up, including making various things __bitwise annotated
enums to get proper sparse type checking.
