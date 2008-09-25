From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Thu, 25 Sep 2008 17:29:51 -0600
Message-ID: <20080925232951.GQ10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
 <20080925220936.GL10950@webber.adilger.int> <48DC1806.90805@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53038 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYIYXaO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 19:30:14 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8PNUDau016934
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 16:30:13 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7R00801YH3U700@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 16:30:13 -0700 (PDT)
Received: from webber.adilger.int ([68.147.167.155])
 by fe-sfbay-10.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb
 28 2007)) with ESMTPSA id <0K7R003HWYMBKRF0@fe-sfbay-10.sun.com> for
 linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 16:30:12 -0700 (PDT)
In-reply-to: <48DC1806.90805@sun.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 26, 2008  03:00 +0400, Alex Tomas wrote:
> Andreas Dilger wrote:
>> Storing B:0 for an in-use block seems very dangerous to me.  This al=
so
>> doesn't really address the need to be able to quickly locate free in=
odes,
>> because it means "I:1" _might_ mean the inode is free or it might no=
t,
>> so EVERY "in-use" inode would need to be checked to see if it is fre=
e.
>
> just combine I and B into single bitmap:
> 1) when you look for free block it's any 0 bit in bitmap made by (I &=
 B)
> 2) when you look for free inode (in current inode blocks) it's any 1 =
bit
>    in bitmap made again by (I & B), then you read corresponded block =
and
>    find free slot there (for example, it can be null i_mode)
>
> looks very simple and doable?

It _sounds_ simple, but I think the implementation will not be what
is expected.  Either you need to keep a 3rd bitmap for each group
which is (I&B) used for finding either inodes or blocks first (with
respectively find_first_bit() or find_first_zero_bit()), then check the
"normal" inode and block bitmaps, keeping this in sync with mballoc, an=
d
confusion/danger on disk/e2fsck because in-use itable blocks are marked
"0" in the block bitmap.  There will be races between updating these
bitmaps, unless the group is locked for both block or inode allocations
on any update because setting any bit completely changes the meaning.

Alternately, if there are only I and B bitmaps, then find_first_bit()
and find_first_zero_bit() are not useful.  Searching for free blocks
means looking for "B:0" and finding potentially many "B:0 I:1" blocks
that are full of inodes.  Searching for free inodes means looking for
"I:1" (strangely) but finding potentially many "I:1 B:0" blocks.

I much prefer the dynamic itable idea from Jos=E9 (which I embellished =
in
my other email), which is very simple for both the kernel and e2fsck,
robust, and avoids the 64-bit inode problem for userspace to the maximu=
m
amount (i.e. a full 4B inodes must be in use before we ever need to
use 64-bit inodes).  The lack of complexity in itable allocation also
translates directly into increased robustness in the face of corruption=
=2E

It doesn't provide dynamic-sized inodes (which hasn't traditionally
been a problem), nor is it perfect in terms of being able to fully
populate a filesystem with inodes in all use cases but it could work
in all but completely pathalogical fragmentation cases (at which point
one wonders if it isn't better to just return -ENOSPC than to flog a
nearly dead filesystem).  It can definitely do a good job in most likel=
y
uses, and also provides a big win over what is done today.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
