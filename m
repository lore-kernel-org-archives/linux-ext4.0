From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Date: Mon, 3 Sep 2007 20:33:08 +0100
Message-ID: <20070903193308.GA7771@infradead.org>
References: <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org> <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com> <20070902152801.GA19962@infradead.org> <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com> <20070903134043.GB28962@infradead.org> <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51476 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbXICTdT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2007 15:33:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 03, 2007 at 12:31:49PM -0700, Christoph Lameter wrote:
> So you'd be fine with replacing the allocs with
> 
> get_free_pages(GFP_xxx, get_order(size)) ?

Yes.  And rip out all that code related to setting up the slabs.  I plan
to add WARN_ONs to bio_add_page and friends to detect further usage of
slab pages if there is any.
