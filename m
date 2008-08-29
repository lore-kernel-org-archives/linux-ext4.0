From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: truncate block allocated on a failed
	ext3_write_begin
Date: Fri, 29 Aug 2008 20:14:51 +0530
Message-ID: <20080829144451.GA6440@skywalker>
References: <1219944473-8770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219944473-8770-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48B6E6CC.7030704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:40894 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYH2Ore (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 10:47:34 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7TEkOGI008386
	for <linux-ext4@vger.kernel.org>; Sat, 30 Aug 2008 00:46:24 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7TEj0xm219922
	for <linux-ext4@vger.kernel.org>; Sat, 30 Aug 2008 00:45:00 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7TEixeu012544
	for <linux-ext4@vger.kernel.org>; Sat, 30 Aug 2008 00:45:00 +1000
Content-Disposition: inline
In-Reply-To: <48B6E6CC.7030704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 12:56:28PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > For blocksize < pagesize we need to remove blocks that
> > got allocte in block_wirte_begin if we fail with ENOSPC
> > for later blocks. block_write_begin internally does
> > this if it allocated page locally. This make sure
> > we don't have blocks outisde inode.i_size during
> > ENOSPC
> 
> I think this is good; here's an easy testcase:
> 
> # dd if=/dev/zero of=fsfile bs=1k count=2048
> # mkfs.ext3 -F fsfile
> # mkdir mnt
> # mount -o loop fsfile mnt/
> # dd if=/dev/zero of=mnt/1kfile bs=1k count=1
> # cd mnt/
> # dd if=/dev/zero of=bigfile bs=4k
> # cd ..
> # umount mnt
> # e2fsck -f fsfile
> e2fsck 1.39 (29-May-2006)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 13, i_size is 974848, should be 976896.  Fix<y>?
> ...
> 
> can you test with that, unless you already have a testcase you've used?

I tested the above and it works fine. The problem appeared during
fsstress run and I used fsstress to debug and fix.


> 
> Assuming it fixes it (it should) you can add:
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>
> 

-aneesh
