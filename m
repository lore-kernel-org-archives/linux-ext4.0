From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Fri, 5 Aug 2016 00:57:56 -0700
Message-ID: <20160805075756.GA28577@infradead.org>
References: <1470331056-796-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, minchan@kernel.org, ngupta@vflare.org,
	vishal.l.verma@intel.com, axboe@kernel.dk
To: Mike Christie <mchristi@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbcHEH55 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2016 03:57:57 -0400
Content-Disposition: inline
In-Reply-To: <1470331056-796-1-git-send-email-mchristi@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> The rw_page users were not converted to use bio/req ops. As a result
> bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
> be sent down as reads.

Can we just get rid of REQ_OP_WRITE enum for the ->rw_page interface
and pass a 'bool write'?  If not I'd prefer to avoid using op_is_write
as much as possible - it's a confusing interface if we really want
to do a switch on read vs write vs invalid.
