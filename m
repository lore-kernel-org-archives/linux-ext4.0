From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell 88f5182)
Date: Tue, 11 May 2010 11:16:20 +0100
Message-ID: <20100511101620.GA18654@shareable.org>
References: <1273569821.21352.19.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@marvell.com>,
	Saeed Bishara <saeed@marvell.com>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:46994 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab0EKKQr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 May 2010 06:16:47 -0400
Content-Disposition: inline
In-Reply-To: <1273569821.21352.19.camel@pasglop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Benjamin Herrenschmidt wrote:
> On the other hand, it could also be a busticated marvell SATA driver :-)

I've seen similar ext3 corruption errors with an IDE on a Sigma
Designs EM8620 with ARM core.  It's completely unrelated :-) But the
fault was in the IDE driver doing cache flushes too late after
starting to set up DMA.  To diagnose it, we luckily found a
reproducible test case, then sprinkled full cache flushes at various
places to narrow it down, and eventually found that one full cache
flush in the driver itself sorted it out, which told us where the
fault was.  From there it was easy.

-- Jamie
