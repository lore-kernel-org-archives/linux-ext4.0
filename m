From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Mon, 2 May 2011 09:22:04 -0400
Message-ID: <20110502132204.GA7708@infradead.org>
References: <20110401140856.GA5311@quack.suse.cz>
 <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Surbhi Palande <surbhi.palande@ubuntu.com>,
	Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab1EBNWK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 09:22:10 -0400
Content-Disposition: inline
In-Reply-To: <20110502131619.GC5855@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 03:16:19PM +0200, Jan Kara wrote:
> Dave, Christoph, any opinions on this?

The busyloop in xfs_quiesce_attr which waits for all active transactions
to finish is supposed to fix this issue.

Note that XFS traditionally expects a two stage freeze process where
we first freeze new VFS-level writes, then flush the caches and then
stop transactions, wait for them to finish and do the remainder of
the freeze process, but I really messed that process up when moving
the sequence to generic code.  Funnily enough it seems to work
neverless.

