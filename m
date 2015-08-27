From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: errors following ext3 to ext4 conversion
Date: Wed, 26 Aug 2015 21:15:36 -0700
Message-ID: <20150827041536.GH10037@birch.djwong.org>
References: <55DE5F79.4010004@yale.edu>
 <20150827033949.GA12151@thunk.org>
 <55DE8771.9050109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Chris Hunter <chris.hunter@yale.edu>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18868 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbbH0EPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2015 00:15:42 -0400
Content-Disposition: inline
In-Reply-To: <55DE8771.9050109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:43:45PM -0500, Eric Sandeen wrote:
> On 8/26/15 10:39 PM, Theodore Ts'o wrote:
> 
> > Merely turning on the extents feature doesn't actually convert any
> > files to use extents.  So if e2fsck is showing errors like this:
> > 
> >> e2fsck shows a variety of errors:
> >> Pass 1: Checking inodes, blocks, and sizes
> >> Inode 118843400, end of extent exceeds allowed value
> >>         (logical block 1409, physical block 3803034390, len 976)
> >> Inode 118843400, end of extent exceeds allowed value
> >>         (logical block 2385, physical block 3803056554, len 4294966945)
> > 
> > This suggests that the file system was likely corrupted before you
> > tried converting the file system, since there should not have been any
> > extent-mapped files in an ext3 file system.
> 
> Hm, do we not require a freshly-fsck'd fs (tm) prior to a conversion attempt,
> like we do (I think) for resize?

tune2fs is not as strict as resize2fs; iirc resize whines if it finds ERROR
status, lack of VALID status, or it having been too long since the last fsck,
whereas tune2fs only cares that the fs is marked VALID.

(Scary, if you think about it...)

--D

> 
> That might be a good idea ...
> 
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
