From: Andreas Dilger <adilger@sun.com>
Subject: Re: About reserve of blocks for "overflow extents" in ext4 metadata
Date: Tue, 08 Dec 2009 11:24:07 -0700
Message-ID: <913B5E53-3552-4D39-B8D3-5598A5D28712@sun.com>
References: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:35003 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937349AbZLHSXy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 13:23:54 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB8INxFp008187
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 10:24:00 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUC00500J0JRT00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 08 Dec 2009 10:23:59 -0800 (PST)
In-reply-to: <41BA663C8B2F72499F48B0EF991C188E0478535CF5@RU-EXSTRCL1.ru.corp.acronis.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-08, at 03:03, Vyacheslav Dubeyko wrote:
> I think that it make sense to has in ext4 metadata a reserve of  
> blocks for "overflow extents" (it is the extents that to form  
> extent's tree and it is placed in some blocks is described in  
> i_block inode's field for a file). The reserve of blocks for  
> "overflow extents" can be located (during operation of ext4 file  
> system creation by mkfs) after inode table for every virtual  
> (FLEX_BG) group by united aggregate of blocks. The size and  
> placement of this reserve has to be described by free special inode.
>
> In my opinion, the reserve of blocks for "overflow extents" resolves  
> such problems:
> 1) In the case of ext4 volume's shrinking resize (especially, in the  
> case of very fragmented volume) it can be very difficult to estimate  
> possibility of successful resize because of existing mechanism of  
> extents' tree layout on the volume. It is possible to encounter  
> during resize the problem of free blocks' lack for rebuilding of  
> extents' tree for replaced files. The reserve of blocks for  
> "overflow extents" guarantee against encountering of such problem  
> during resizes.
> 2) The presence of the reserve of blocks for "overflow extents"  
> means that all existing extents' trees of files will locate in one  
> place. This fact and placement the reserve just after inode table  
> will increase efficiency of operations with extents' trees, in my  
> opinion.
> 3) The localized layout of extents' trees of files means efficient  
> journaling of this metadata, also.

In fact, for most files the 4 extents that can be stored within the  
inode itself provide enough space to store all of the extents of the  
file.  Reserving extra space is generally sub-optimal, either because  
it wastes space when too many blocks are reserved (causing ENOSPC  
before it is needed), or when too few blocks are reserved it will  
cause the same failures as you report today.

I wouldn't object to tuning the block allocator to pack index and  
extent blocks into shared (in-memory) preallocated regions, but I  
don't think that needs to be a hard reservation.  The mballoc code  
already has the concept of aggregating small IOs into a single free  
chunk, and it makes sense to put the index/extent blocks together in  
this way, to avoid seeking during e2fsck, and to avoid fragmenting the  
free space with small allocations.

In fact, I thought Ted had done some work in this area already?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

