From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 33/49] ext4: Add the journal checksum feature
Date: Wed, 23 Jan 2008 15:40:10 -0700
Message-ID: <20080123224010.GF18433@webber.adilger.int>
References: <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <20080123140704.01249f86.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	girish@clusterfs.com, adilger@clusterfs.com,
	shaggy@linux.vnet.ibm.com, cmm@us.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8714 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYAWWky (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 17:40:54 -0500
In-reply-to: <20080123140704.01249f86.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 23, 2008  14:07 -0800, Andrew Morton wrote:
> > +{
> > +	struct page *page = bh->b_page;
> > +	char *addr;
> > +	__u32 checksum;
> > +
> > +	addr = kmap_atomic(page, KM_USER0);
> > +	checksum = crc32_be(crc32_sum,
> > +		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
> > +	kunmap_atomic(addr, KM_USER0);
> > +
> > +	return checksum;
> > +}
> 
> Can this buffer actually be in highmem?

Yes, this was found during system testing.  While ext3/4 will only allocate
buffer heads in lowmem, the jbd/jbd2 code can allocate buffers in highmem.
I was surprised about this also.

Please see the thread in ext4-devel:
[PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
