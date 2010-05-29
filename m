From: tytso@mit.edu
Subject: Re: [PATCH 2.6.27.y 2/3] ext4: Fix file fragmentation during large
 file write.
Date: Fri, 28 May 2010 21:06:57 -0400
Message-ID: <20100529010657.GM26177@thunk.org>
References: <4C001888.8020006@jaysonking.com>
 <4C001901.1070207@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: "Jayson R. King" <dev@jaysonking.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36616 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0E2BHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 21:07:09 -0400
Content-Disposition: inline
In-Reply-To: <4C001901.1070207@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 28, 2010 at 02:26:57PM -0500, Jayson R. King wrote:
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: Thu Oct 16 10:10:36 2008 -0400
> Subject: ext4: Fix file fragmentation during large file write.
> 
> commit 22208dedbd7626e5fc4339c417f8d24cc21f79d7 upstream.
> 
> The range_cyclic writeback mode uses the address_space writeback_index
> as the start index for writeback.  With delayed allocation we were
> updating writeback_index wrongly resulting in highly fragmented file.
> This patch reduces the number of extents reduced from 4000 to 27 for a
> 3GB file.

This isn't a critical bug fix either.  I don't really care a whole
lot, since I don't plan to support ext4 with all of these patches but
if you haven't been doing a full set of testing with these patches,
I'd be very concerned about whether ext4 would be stable after
applying this patch series.

What sort of testing _have_ you done?

						- Ted

