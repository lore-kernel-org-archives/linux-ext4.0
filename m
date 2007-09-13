From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: new mballoc patches.
Date: Wed, 12 Sep 2007 17:30:45 -0700
Message-ID: <1189643445.4935.32.camel@localhost.localdomain>
References: <46E651E6.3070107@linux.vnet.ibm.com>
	 <46E6AE84.8050600@linux.vnet.ibm.com> <46E7DF34.8090209@bull.net>
	 <46E8290F.7020307@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34375 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXIMAar (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2007 20:30:47 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8D0Uknj008724
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:30:46 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8D0UkHB533472
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:30:46 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8D0UjQW018528
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:30:46 -0400
In-Reply-To: <46E8290F.7020307@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-09-12 at 23:29 +0530, Aneesh Kumar K.V wrote:
> Valerie,
> 
> 
> Valerie Clement wrote:
> > Aneesh Kumar K.V wrote:
> >>
> >> running fsstress on ppc64 give me
> >> EXT4-fs: group 9: 16384 blocks in bitmap, 32254 in gd
> >> EXT4-fs error (device sda7): ext4_mb_mark_diskspace_used: Allocating 
> >> block in system zone - block = 294915
> >>
> >> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
> >> #213792: invalid magic - magic 5e5e, entries 24158, max 24158(0), 
> >> depth 24158(0)
> >> RTAS: event: 137875, Type: Platform Error, Severity: 2
> >> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
> >> #232149: invalid magic - magic e5e5, entries 58853, max 58853(0), 
> >> depth 58853(0)
> >> RTAS: event: 137876, Type: Platform Error, Severity: 2
> >> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode 
> >> #214332: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> >> EXT4-fs error (device sda7): ext4_ext_remove_space: bad header in 
> >> inode #232149: invalid magic - magic e5e5, entries 58853, max 
> >> 58853(0), depth 58853(0)
> >>
> >> -aneesh
> > 
> > endian problem?
> > When running sparse on fs/ext4/ (make C=2 CF="-D__CHECK_ENDIAN__") :
> > 
> > fs/ext4/extents.c:2570:12: warning: incorrect type in assignment 
> > (different base types)
> > fs/ext4/extents.c:2570:12:    expected unsigned long [unsigned] 
> > [assigned] allocated
> > fs/ext4/extents.c:2570:12:    got restricted unsigned short 
> > [addressable] [assigned] [usertype] ee_len
> > 
> > I think the following line in extents.c
> >     allocated = newex.ee_len;
> > should be replaced by
> >     allocated = le16_to_cpu(newex.ee_len);
> > 
> > 
> 
> 
> Yes i guess that is the issue. fsstress is now running for the last 30 minutes without any error.
> 
> I have updated the patch series at 
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/
> 


Thanks Aneesh. These changes will show in 2.6.23-rc5 ext4 patch queue.

> Changes:
> a) mballoc patch fixes for sparse warning
> b) ext4_i_version_hi_2.patch patch fixes for sparse warning
> c) Added commit message for ext4_uninit_blockgroup.patch

That's very helpful. I think this might ready to merge for 2.6.24.

> d) Added new patch sparse-fix.patch ( this can be pushed to upstream separately)
This patch has sparse fix for uninit block group, so I fold that part to
the the ext4_uninit_blockgroup.patch.
I moved this patch to the beginning of the series as this fix should be
merged to upstream separately.


Mingming
> 
> 
> The complete patch set in 
> http://www.radian.org/~kvaneesh/ext4/patch-series/ext4-patch-queue.tar
> 
> 


> -aneesh
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
