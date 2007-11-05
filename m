From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Mon, 05 Nov 2007 08:04:55 -0800
Message-ID: <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com>
References: <46D7097F.4020501@linux.vnet.ibm.com>
	 <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
	 <1193964035.4014.23.camel@localhost.localdomain>
	 <20071102052031.GC18505@webber.adilger.int>
	 <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
	 <20071103013621.GC2863@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53344 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXKEQDh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 11:03:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5G3b95017229
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 11:03:37 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5G3bce074948
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 09:03:37 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5G3Zqd032753
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 09:03:36 -0700
In-Reply-To: <20071103013621.GC2863@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-11-03 at 09:36 +0800, Andreas Dilger wrote:
> On Nov 02, 2007  08:31 -0800, Badari Pulavarty wrote:
> > On Fri, 2007-11-02 at 13:20 +0800, Andreas Dilger wrote:
> > > On Nov 01, 2007  17:40 -0700, Mingming Cao wrote:
> > > > Current journal checksumming patch failed fsstress test on NUMA. The 
> > > > bh->b_data passed to the crc32_be () function could be NULL pointer, 
> > > > which caused kernel oops immediately when running fsstress with -o 
> > > > journal_checksum. It is because the page is part of highmem on NUMA box.
> > > > We need to kmap the page before access the bh->b_data to calculate
> > > > the checksums.
> > > 
> > > I have no objection to the patch, per-se, but I'm surprised that there
> > > would ever be a buffer head pointing at a page in high memory?  That
> > > seems contrary to what I would expect...
> > 
> > I was surprised to see that too while helping Mingming/Avantika track
> > this issue. I was under impression that we are checksumming only
> > metadata and it should be lowmem. But only "buffer_head"s are in lowmem.
> > Pages that point to can be in Highmem.
> 
> But...  this implies that every user of bh->b_data needs to kmap, and I
> don't see that in the code anywhere else.  That makes me think something
> else is going wrong here.

Most cases, this is handled in ll_rw_block() code - when we submit the
buffer head for IO. If the page is in highmem, we will end up creating
a bounce bufer for it. 

In our case, JBD code is trying to look at the data to do checksum
on it. Thats why we have to kmap() the page before looking.

Thanks,
Badari
