From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Fri, 02 Nov 2007 08:31:48 -0800
Message-ID: <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
References: <46D7097F.4020501@linux.vnet.ibm.com>
	 <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
	 <1193964035.4014.23.camel@localhost.localdomain>
	 <20071102052031.GC18505@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49874 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbXKBP3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2007 11:29:41 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA2FUvtd011841
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 11:30:57 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA2FTM8q470430
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 11:29:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA2FTLfP011625
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 11:29:22 -0400
In-Reply-To: <20071102052031.GC18505@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-11-02 at 13:20 +0800, Andreas Dilger wrote:
> On Nov 01, 2007  17:40 -0700, Mingming Cao wrote:
> > Current journal checksumming patch failed fsstress test on NUMA. The 
> > bh->b_data passed to the crc32_be () function could be NULL pointer, 
> > which caused kernel oops immediately when running fsstress with -o 
> > journal_checksum. It is because the page is part of highmem on NUMA box.
> > We need to kmap the page before access the bh->b_data to calculate
> > the checksums.
> 
> I have no objection to the patch, per-se, but I'm surprised that there
> would ever be a buffer head pointing at a page in high memory?  That
> seems contrary to what I would expect...

I was surprised to see that too while helping Mingming/Avantika track
this issue. I was under impression that we are checksumming only
metadata and it should be lowmem. But only "buffer_head"s are in lowmem.
Pages that point to can be in Highmem.

Thanks,
Badari
