From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Mon, 24 Jan 2011 15:16:03 -0500
Message-ID: <20110124201603.GA5131@thunk.org>
References: <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org>
 <4D3A2EC6.3020700@shiftmail.org>
 <20110122013415.GN3043@thunk.org>
 <4D3B03FA.4040604@shiftmail.org>
 <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
 <4D3B66AB.6030102@shiftmail.org>
 <20110123051718.GA3237@thunk.org>
 <4D3C76BE.3090908@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47198 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXUQM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Jan 2011 15:16:12 -0500
Content-Disposition: inline
In-Reply-To: <4D3C76BE.3090908@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 23, 2011 at 07:43:10PM +0100, torn5 wrote:
> I thought it was possible via the completion notifications from the disk.
> AFAIK if a disk is in NCQ mode it will return completion for a
> command only when the write was really delivered to the platters.
> While in non-NCQ mode the disk immediately returns completion and
> caches the write. Is this correct?

No, that's not correct.  The completion notification from the disk is
merely that the DMA has completed.  It does not mean that the data has
hit the platters.  This is true in both NCQ and non-NCQ mode.

You can disable the write cache (which is what I think you're thinking
about), but the performance hit is pretty significant on standard
HDD's.

						- Ted
