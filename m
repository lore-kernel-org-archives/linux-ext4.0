From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Fri, 26 Oct 2007 21:54:55 -0500
Message-ID: <4722A87F.3070709@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex.tomas@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbXJ0Cy6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2007 22:54:58 -0400
In-Reply-To: <20071026221938.GV3042@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 26, 2007  16:24 -0500, Eric Sandeen wrote:
>> The resulting file had over 4k extents.
>> [root@bear-05 ~]# filefrag -v /mnt/test/foobar  | grep -i extents
>> File is stored in extents format
>> /mnt/test/foobar: 4075 extents found
> 
> On a related note - we're just putting the finishing touches on the
> FIEMAP patches for ext4 + e2fsprogs, so that we can get decent looking
> output from filefrag, and much more efficiently than FIBMAP.

sounds good.

> One of the issues is that w/o delalloc the mballoc code only gets 
> single-block allocations, so there might be a problem with the interface
> to mballoc.  That might be caused by the fact the patches were changed
> at one point from delalloc-atop-mballoc to mballoc-atop-delalloc, and
> something was missed in that conversion.
> 
> Have you tried O_DIRECT?  That is another way to access mballoc w/o
> using delalloc.

I've tried osync:
http://people.redhat.com/esandeen/seekwatcher/ext4-dd-osync-write.png

but not yet O_DIRECT, will do.

-Eric
