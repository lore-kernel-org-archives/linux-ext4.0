From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/8] fs/buffer.c: make some functions non-static
Date: Sat, 13 Jan 2018 10:55:11 +0530
Message-ID: <5174754.qQ3mymzVSl@localhost.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com> <20180112141129.27507-3-chandan@linux.vnet.ibm.com> <20180112143823.GA28063@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbeAMFX7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 00:23:59 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0D5Nmil088587
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jan 2018 00:23:58 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ff9jvumqf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jan 2018 00:23:58 -0500
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 13 Jan 2018 05:23:56 -0000
In-Reply-To: <20180112143823.GA28063@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday, January 12, 2018 8:08:23 PM IST Matthew Wilcox wrote:
> On Fri, Jan 12, 2018 at 07:41:23PM +0530, Chandan Rajendra wrote:
> > @@ -1642,12 +1642,12 @@ EXPORT_SYMBOL(clean_bdev_aliases);
> >   * constraints in mind (relevant mostly if some
> >   * architecture has a slow bit-scan instruction)
> >   */
> > -static inline int block_size_bits(unsigned int blocksize)
> > +int block_size_bits(unsigned int blocksize)
> >  {
> >  	return ilog2(blocksize);
> >  }
> 
> Could you move this to buffer.h instead please?
> 
> 

It just occured to me that I could use inode->i_blkbits instead of
block_size_bits() inside the new function ext4_block_read_full_page().
Hence I will drop the above change from the next version of the patchset.

Thanks for the review.

-- 
chandan
