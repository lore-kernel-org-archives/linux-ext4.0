From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: fsck errors with fsstress
Date: Fri, 18 Apr 2008 15:24:47 -0400
Message-ID: <20080418192447.GC25797@mit.edu>
References: <20080415064733.GA8099@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42486 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082AbYDRT0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 15:26:18 -0400
Content-Disposition: inline
In-Reply-To: <20080415064733.GA8099@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2008 at 12:17:33PM +0530, Aneesh Kumar K.V wrote:
> 
> On x86_64 after fsstress with fallocate is run with 
> 
> fsstress -c -n1000 -p1000 -d /mnt/tmp/fsstress -f dwrite=0
> 
> e2fsprogs from next branch with HEAD at v1.40.8-163-g60dc00b
> 
> /usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda5
> e2fsck 1.40.8 (13-Mar-2008)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 401326 has an invalid extent
> 	(logical block 76, physical block 2441549, invalid len 711)
> Clear? no

I think this was fixed by Eric's patch:

    e2fsck: Only check PR_1_EXTENT_ENDS_BEYOND for leaf nodes

I've integrated this and pushed it out into the latest 'pu' branch.

          		     	 	   - Ted
