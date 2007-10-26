From: Andreas Dilger <adilger@sun.com>
Subject: Re: delalloc fragmenting files?
Date: Fri, 26 Oct 2007 16:19:38 -0600
Message-ID: <20071026221938.GV3042@webber.adilger.int>
References: <47225B1E.2060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex.tomas@sun.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53138 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbXJZWTk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2007 18:19:40 -0400
Content-Disposition: inline
In-Reply-To: <47225B1E.2060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 26, 2007  16:24 -0500, Eric Sandeen wrote:
> The resulting file had over 4k extents.
> [root@bear-05 ~]# filefrag -v /mnt/test/foobar  | grep -i extents
> File is stored in extents format
> /mnt/test/foobar: 4075 extents found

On a related note - we're just putting the finishing touches on the
FIEMAP patches for ext4 + e2fsprogs, so that we can get decent looking
output from filefrag, and much more efficiently than FIBMAP.

> if I don't mount with delalloc:
> 
> mount -t ext4dev -o data=writeback,extents,mballoc /dev/sdb7 /mnt/test
> 
> and run the same dd, I get 229 extents:
> 
> [root@bear-05 ~]# filefrag -v /mnt/test/foobar  | grep -i extents
> File is stored in extents format
> /mnt/test/foobar: 229 extents found

One of the issues is that w/o delalloc the mballoc code only gets 
single-block allocations, so there might be a problem with the interface
to mballoc.  That might be caused by the fact the patches were changed
at one point from delalloc-atop-mballoc to mballoc-atop-delalloc, and
something was missed in that conversion.

Have you tried O_DIRECT?  That is another way to access mballoc w/o
using delalloc.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
