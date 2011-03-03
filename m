From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext4: Fix a BUG in mb_mark_used during trim.
Date: Thu, 3 Mar 2011 10:38:56 -0500
Message-ID: <20110303153856.GA32087@infradead.org>
References: <alpine.LFD.2.00.1103031117210.8737@dhcp-27-109.brq.redhat.com>
 <1299160774-2337-1-git-send-email-tm@tao.ma>
 <20110303141109.GB16191@infradead.org>
 <4D6FB4CF.4040202@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CCPi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 10:38:56 -0500
Content-Disposition: inline
In-Reply-To: <4D6FB4CF.4040202@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 03, 2011 at 11:33:35PM +0800, Tao Ma wrote:
> Actually these numbers are related to the block size of a ext4 volume.
> To be more specific, with the above number, we have
> first_block + block_len > EXT4_BLOCKS_PER_GROUP while
> block_len < EXT4_BLOCKS_PER_GROUP.
> So do you think it is generic enough for a test case in xfstests
> since now this
> tool kit is also used to test xfs and btrfs?

xfstests also allows filesystem-specific tests.  Most of the specific
tests are for xfs, but there are few for udf right now as well.

