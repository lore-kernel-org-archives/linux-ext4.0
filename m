From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Tue, 6 Nov 2007 00:15:29 +0800
Message-ID: <20071105161529.GC2892@webber.adilger.int>
References: <46D7097F.4020501@linux.vnet.ibm.com> <1188552066.3781.15.camel@dhcp5.linsyssoft.com> <1193964035.4014.23.camel@localhost.localdomain> <20071102052031.GC18505@webber.adilger.int> <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com> <20071103013621.GC2863@webber.adilger.int> <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41283 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXKEQPi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 11:15:38 -0500
Content-Disposition: inline
In-Reply-To: <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 05, 2007  08:04 -0800, Badari Pulavarty wrote:
> On Sat, 2007-11-03 at 09:36 +0800, Andreas Dilger wrote:
> > But...  this implies that every user of bh->b_data needs to kmap, and I
> > don't see that in the code anywhere else.  That makes me think something
> > else is going wrong here.
> 
> Most cases, this is handled in ll_rw_block() code - when we submit the
> buffer head for IO. If the page is in highmem, we will end up creating
> a bounce bufer for it. 
> 
> In our case, JBD code is trying to look at the data to do checksum
> on it. Thats why we have to kmap() the page before looking.

My point is that there is a LOT of code in ext[234] that dereferences
bh->b_data without kmap() (e.g. group descriptors, bitmaps, superblock,
inode tables, etc).  Does that imply that something is forcing those
bh pages into lowmem, or is the journal bh page in question being
allocated in some different way that allows it to be in highmem?

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
