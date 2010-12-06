From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: Set barrier=0 when block device does not advertise
 flush support
Date: Mon, 6 Dec 2010 08:39:24 -0500
Message-ID: <20101206133924.GB9235@infradead.org>
References: <20101203001659.GI18195@tux1.beaverton.ibm.com>
 <20101203070950.GA19071@infradead.org>
 <20101203091445.GK18195@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0LFNj1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Dec 2010 08:39:27 -0500
Content-Disposition: inline
In-Reply-To: <20101203091445.GK18195@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

barrier=0 really means losemydata=1.  The plan I discussed with Jens was
to allow to disable the flush and fua semantics in the block layer, so
we'll have one new tunable for that, which is documented to causes these
issues.  

> picks the safe option by default.  However, I'd prefer /proc/mounts not
> misrepresent the status of flush support, to the best of ext4's knowledge.

That's bullshit.  The barrier option has traditionally meant that we
sent barrier requests, and now means thatwe send flush+fua requests.
There's no reason for a warning and option mislabling just because you
got the most efficient implementation of it.

