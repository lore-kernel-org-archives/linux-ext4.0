From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 compile error on m68k
Date: Thu, 10 Apr 2008 10:01:42 -0400
Message-ID: <20080410140142.GA18896@infradead.org>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0804051345180.7216@anakin> <20080410104059.GA23116@skywalker> <je7if69bh4.fsf@sykes.suse.de> <20080410135807.GA7526@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Schwab <schwab@suse.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	zippel@linux-m68k.org, linux-ext4@vger.kernel.org,
	linux-m68k@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbYDJOCm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 10:02:42 -0400
Content-Disposition: inline
In-Reply-To: <20080410135807.GA7526@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Should be same  ext2_find_next_zero_bit except that it find the next
> set bit rather than the zero bit. The API is used to find the set bit
> in bitmap. To explain the little endian dependency, what we have is
> 
> 0	x	n
> [.......1.......]
> 
> Now we read this as (char *) and try to find the first set bit which
> in the above example is x. To speed up most of the architectures would
> like to consider it as an array of long. That implies that the value
> in the array should be considered as a little endian long, hence the
> *_le_bit.

This kind of documentation should be in the kernel tree somewhere.
And while we're at it all the routines should be renamed from extN_*
to *_le_bit because that describes what they do.
