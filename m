From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Date: Mon, 3 Sep 2007 00:55:04 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
 <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org>
 <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
 <20070902152801.GA19962@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	adilger@clusterfs.com, sho@tnes.nec.co.jp,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbXICHzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Sep 2007 03:55:08 -0400
In-Reply-To: <20070902152801.GA19962@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2 Sep 2007, Christoph Hellwig wrote:

> > We are doing what you describe right now. So the current code is broken?
> Yes.

How about getting rid of the slabs there and use kmalloc? Kmalloc in mm 
(and therfore hopefully 2.6.24) will convert kmallocs > PAGE_SIZE to page 
allocator calls. Not sure what to do about the 1k and 2k requests though.
