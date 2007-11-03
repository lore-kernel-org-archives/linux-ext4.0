From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Sat, 3 Nov 2007 09:36:21 +0800
Message-ID: <20071103013621.GC2863@webber.adilger.int>
References: <46D7097F.4020501@linux.vnet.ibm.com> <1188552066.3781.15.camel@dhcp5.linsyssoft.com> <1193964035.4014.23.camel@localhost.localdomain> <20071102052031.GC18505@webber.adilger.int> <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:44977 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXKCBhO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2007 21:37:14 -0400
Content-Disposition: inline
In-Reply-To: <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 02, 2007  08:31 -0800, Badari Pulavarty wrote:
> On Fri, 2007-11-02 at 13:20 +0800, Andreas Dilger wrote:
> > On Nov 01, 2007  17:40 -0700, Mingming Cao wrote:
> > > Current journal checksumming patch failed fsstress test on NUMA. The 
> > > bh->b_data passed to the crc32_be () function could be NULL pointer, 
> > > which caused kernel oops immediately when running fsstress with -o 
> > > journal_checksum. It is because the page is part of highmem on NUMA box.
> > > We need to kmap the page before access the bh->b_data to calculate
> > > the checksums.
> > 
> > I have no objection to the patch, per-se, but I'm surprised that there
> > would ever be a buffer head pointing at a page in high memory?  That
> > seems contrary to what I would expect...
> 
> I was surprised to see that too while helping Mingming/Avantika track
> this issue. I was under impression that we are checksumming only
> metadata and it should be lowmem. But only "buffer_head"s are in lowmem.
> Pages that point to can be in Highmem.

But...  this implies that every user of bh->b_data needs to kmap, and I
don't see that in the code anywhere else.  That makes me think something
else is going wrong here.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
