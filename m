From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Mon, 25 Apr 2016 01:31:14 -0700
Message-ID: <20160425083114.GA27556@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
 <20160420205923.GA24797@infradead.org>
 <1461434916.3695.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "hch@infradead.org" <hch@infradead.org>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>,
	"axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>,
	"linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbcDYIbS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2016 04:31:18 -0400
Content-Disposition: inline
In-Reply-To: <1461434916.3695.7.camel@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
> direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM due
> to some allocation failing, and I thought we should return the original
> -EIO in such cases so that the application doesn't lose the information
> that the bad block is actually causing the error.

EINVAL is a concern here.  Not due to the right error reported, but
because it means your current scheme is fundamentally broken - we
need to support I/O at any alignment for DAX I/O, and not fail due to
alignbment concernes for a highly specific degraded case.

I think this whole series need to go back to the drawing board as I
don't think it can actually rely on using direct I/O as the EIO
fallback.

