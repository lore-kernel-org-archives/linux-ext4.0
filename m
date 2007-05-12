From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Fri, 11 May 2007 21:21:24 -0500
Message-ID: <464524A4.9060209@redhat.com>
References: <20070512020248.GQ6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXELCV1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 May 2007 22:21:27 -0400
In-Reply-To: <20070512020248.GQ6375@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> It is possible to specify the RAID stride to mke2fs allow it to optimize
> the layout of the bitmaps.  With the new mballoc it is also possible to
> tell it via a mount option to do large allocations aligned on the RAID
> stride (by default it aligns on 1MB boundaries from the start of the LUN).
> 
> What would be rather convenient is to store the RAID stride value in the
> superblock.  That would spare a lot of hassle on the part of the admin
> to tune the filesystem optimally for the underlying storage.  There is
> also a library used in the XFS tools that knows how to probe various
> kinds of block devices (e.g. MD RAID, LVM/DM, etc) to get their storage
> layout that would avoid the need for the user to specify anything.
> 
> Any thoughts on this?

I think it sounds great.  I think ext4 would benefit greatly from 
knowing a bit more about the underlying device geometry & allocating 
accordingly...

-Eric
