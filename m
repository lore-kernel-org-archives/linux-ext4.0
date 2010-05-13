From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
Date: Fri, 14 May 2010 07:33:45 +1000
Message-ID: <1273786425.21352.191.camel@pasglop>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <20100512150057.GA29867@atrey.karlin.mff.cuni.cz>
	 <1273709714.21352.138.camel@pasglop> <20100513151245.GA21251@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Saeed Bishara <saeed@marvell.com>,
	Nicolas Pitre <nico@marvell.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"James E.J. Bottomley" <jejb@parisc-linux.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:59381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab0EMVfg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 17:35:36 -0400
In-Reply-To: <20100513151245.GA21251@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2010-05-13 at 17:12 +0200, Jan Kara wrote:

> If you look at the array more in detail, you'll notice that 'offs' part of
> structure is sometimes identical. That should never happen because 'offs'
> contains offset of the corresponding directory entry in a block. So when
> offsets are identical in this array, subsequent move will copy some entries
> several times and leave entries that should be moved in the old block,
> resulting in a corruption we see.
>   The question is, how could offsets be the same? dx_make_map seems to get
> it right and dx_sort_map as well. Maybe I'd peek into disassembly of
> dx_sort_map to see whether swap() macro does what it should... If that
> looks OK, you could try adding some debug checks into dx_sort_map and try
> to catch the moment when duplicate offsets are created...

Thanks. I'll have a look. It could be a miscompile indeed. My cross-gcc
is a 4.4.0, maybe that's the root of the problem.

Cheers,
Ben.


