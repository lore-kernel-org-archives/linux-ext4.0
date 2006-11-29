From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Boot failure with ext2 and initrds
Date: Wed, 29 Nov 2006 09:20:24 +0000
Message-ID: <20061129092023.GA23101@flint.arm.linux.org.uk>
References: <20061114113120.d4c22b02.akpm@osdl.org> <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com> <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com> <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com> <20061115232228.afaf42f2.akpm@osdl.org> <20061116123448.GA28311@flint.arm.linux.org.uk> <20061125145915.GB13089@flint.arm.linux.org.uk> <20061129074000.GA21352@flint.arm.linux.org.uk> <20061129003036.dd27f01e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, Hugh Dickins <hugh@veritas.com>,
	Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:50450 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S966547AbWK2JUm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 04:20:42 -0500
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061129003036.dd27f01e.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 29, 2006 at 12:30:36AM -0800, Andrew Morton wrote:
> On Wed, 29 Nov 2006 07:40:00 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > Yet another attempt to get a response from Andrew.  It is rather
> > important that you DO respond to this.
> 
> You can read the code as easily as I can?

Sigh.  Please don't cut the relevant part of my _first_ email message
where it can be clearly seen that I _have_ read the code and interpreted
it _differently_ from you.

> I'm not really sure what you're asking - I thought Mingming cleared
> things up.

Which message did this happen?

What I'm looking for is confirmation of the semantics of
find_next_zero_bit(), which is a fairly simple question to ask, and
certainly does not justify this rather obtuse and difficult thread.

<extremely frustrated>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
