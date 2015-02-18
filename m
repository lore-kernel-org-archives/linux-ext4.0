From: "hch@lst.de" <hch@lst.de>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Date: Wed, 18 Feb 2015 22:59:22 +0100
Message-ID: <20150218215922.GA2285@lst.de>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org> <20150115124106.GF12739@quack.suse.cz> <100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com> <20150119141858.GF5662@quack.suse.cz> <20150217085200.GA23192@quack.suse.cz> <20150217133745.GG3364@wil.cx> <20150218104009.GB4614@quack.suse.cz> <20150218215523.GO12722@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@linux.intel.com>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"boaz@plexistor.com" <boaz@plexistor.com>,
	"hch@lst.de" <hch@lst.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43511 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbBRV71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2015 16:59:27 -0500
Content-Disposition: inline
In-Reply-To: <20150218215523.GO12722@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 19, 2015 at 08:55:23AM +1100, Dave Chinner wrote:
> And speaking of phony BHs, the pnfs block layout changes introduce
> an struct iomap and a "map_blocks" method to the export_ops in
> exportfs.h. This is the model what we should be using instead of
> phony BHs for block mapping/allocation operations...

I've got some WIP patches to move the direct I/O code over to that,
DAX would be another natural fit.
