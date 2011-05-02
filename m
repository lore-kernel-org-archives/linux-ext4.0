From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to
 a deadlock
Date: Mon, 2 May 2011 09:24:49 -0400
Message-ID: <20110502132449.GB7708@infradead.org>
References: <20110406054005.GD31057@dastard>
 <20110406061856.GC23285@quack.suse.cz>
 <20110406112135.GE31057@dastard>
 <4DBE746F.3090707@ubuntu.com>
 <20110502105629.GA4556@quack.suse.cz>
 <4DBE9537.4050708@ubuntu.com>
 <20110502122055.GB5855@quack.suse.cz>
 <4DBEA3DF.1060306@ubuntu.com>
 <20110502131619.GC5855@quack.suse.cz>
 <4DBEB025.90704@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Surbhi Palande <surbhi.palande@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab1EBNYy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 09:24:54 -0400
Content-Disposition: inline
In-Reply-To: <4DBEB025.90704@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 02, 2011 at 04:22:45PM +0300, Surbhi Palande wrote:
> This has another advantage, that it rightfully does not let you
> update the access time when the F.S is frozen (touch_atime called
> from a read path when the F.S is frozen) Otherwise we also need to
> fix this path.

In most filesystens atime updates aren't transactional.  They just
get written into inode->i_atime, and at some later point when the
VFS tries to clean the inode it gets writtent back, either through
a transaction or not.

