From: Alex Tomas <bzzz@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Tue, 30 Sep 2008 18:02:16 +0400
Message-ID: <48E23168.2020608@sun.com>
References: <48DA28B0.2020207@sun.com>
 <20080925220936.GL10950@webber.adilger.int> <48DC1806.90805@sun.com>
 <20080925232951.GQ10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:40520 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYI3ODH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 10:03:07 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8UE35iN005680
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2008 14:03:05 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8000201HNWB100@fe-emea-09.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 30 Sep 2008 15:03:05 +0100 (BST)
Received: from gw.home.net ([91.76.47.4])
 by fe-emea-09.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb 28
 2007)) with ESMTPSA id <0K8000ESWHO8KRD0@fe-emea-09.sun.com> for
 linux-ext4@vger.kernel.org; Tue, 30 Sep 2008 15:02:33 +0100 (BST)
In-reply-to: <20080925232951.GQ10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> It _sounds_ simple, but I think the implementation will not be what
> is expected.  Either you need to keep a 3rd bitmap for each group
> which is (I&B) used for finding either inodes or blocks first (with
> respectively find_first_bit() or find_first_zero_bit()), then check t=
he
> "normal" inode and block bitmaps, keeping this in sync with mballoc, =
and
> confusion/danger on disk/e2fsck because in-use itable blocks are mark=
ed
> "0" in the block bitmap.  There will be races between updating these
> bitmaps, unless the group is locked for both block or inode allocatio=
ns
> on any update because setting any bit completely changes the meaning.
>=20
> Alternately, if there are only I and B bitmaps, then find_first_bit()
> and find_first_zero_bit() are not useful.  Searching for free blocks
> means looking for "B:0" and finding potentially many "B:0 I:1" blocks
> that are full of inodes.  Searching for free inodes means looking for
> "I:1" (strangely) but finding potentially many "I:1 B:0" blocks.

mballoc already maintains own in-core copy, so we'd have to apply anoth=
er
bitmap to it. as for races - I think this can be done by proper orderin=
g,
probably w/o locks even: free block turns used first, then becomes part
of "fragmentary" space. anyway, the complexity would be away simpler th=
an
mballoc itself, for example.

> I much prefer the dynamic itable idea from Jos=E9 (which I embellishe=
d in
> my other email), which is very simple for both the kernel and e2fsck,
> robust, and avoids the 64-bit inode problem for userspace to the maxi=
mum
> amount (i.e. a full 4B inodes must be in use before we ever need to
> use 64-bit inodes).  The lack of complexity in itable allocation also
> translates directly into increased robustness in the face of corrupti=
on.
>=20
> It doesn't provide dynamic-sized inodes (which hasn't traditionally
> been a problem), nor is it perfect in terms of being able to fully
> populate a filesystem with inodes in all use cases but it could work
> in all but completely pathalogical fragmentation cases (at which poin=
t
> one wonders if it isn't better to just return -ENOSPC than to flog a
> nearly dead filesystem).  It can definitely do a good job in most lik=
ely
> uses, and also provides a big win over what is done today.

I do understand simplicity and robustness as driving reasons much. and =
I
agree dynamic inodes added via empty group descriptors is an excellent =
idea.
but I still think that with original idea we could get much more than j=
ust
dynamic inodes (though it was original intention). for example, storing
small directories (upto ~200 dir entries) within inode could be very ni=
ce
to avoid bunch of seeks. and tail packing could be as well. notice we d=
on't
really need fine structures to find free slots in that fragmentary spac=
e -
usually small files are generated at once (e.g. tar -xf), so to pack th=
em
we just need to remember few last "partial filled" blocks. if some file
is deleted and we get free slot in corresponded block - who cares - wit=
h
current ext3/4 we'd waste whole block anyway.

another reason for that design was to support >2^32 files per filesyste=
m.

thanks, Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
