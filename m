From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Sun, 1 May 2016 10:28:54 -0700
Message-ID: <20160501172854.GA19601@infradead.org>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <57238DFC.6010108@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbcEAR27 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 May 2016 13:28:59 -0400
Content-Disposition: inline
In-Reply-To: <57238DFC.6010108@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2016 at 12:38:20PM -0400, Waiman Long wrote:
> From my testing, it looked like that parallel overwrites to the same file in
> an ext4 filesystem on DAX can happen in parallel even if their range
> overlaps. It was mainly because the code will drop the i_mutex before the
> write. That means the overlapped blocks can get garbage. I think this is a
> problem, but I am not expert in the ext4 filesystem to say for sure. I would
> like to know your thought on that.

That's another issue with dax I/O pretending to be direct I/O..  Because
it isn't we'll need to synchronize it like buffered I/O and not like
direct I/O in all file systems.
