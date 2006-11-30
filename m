From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC][PATCH 0/4] BIG_BG: support of large block groups
Date: Thu, 30 Nov 2006 16:17:41 +0100
Message-ID: <456EF615.1090205@bull.net>
References: <1164386860.17961.67.camel@ckrm> <20061129172318.GD5771@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:908 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1030376AbWK3PTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 10:19:41 -0500
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061129172318.GD5771@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> So what's the current limitation on the maximum size of the filesyste=
m
> without big block groups?  Well, the block group number is an unsigne=
d
> 32 bit number, so we can have 2**32 block group.  Using a 4k (2**12)
> block group, have a limit of 32768 blocks per block group, or 2**15
> blocks.  So the limit is 2**(32+15) or 2**47 blocks, or 2**59 bytes
> (512 petabytes).
Hi Ted,
thanks for your comments.

In fact, there is another limitation related to the block group size:
all the group descriptors are stored in the first group of the filesyst=
em.
Currently, with a 4-KB block size, the maximum size of a group is
2**15 blocks =3D 2**27 bytes.
With a group descriptor size of 32 bytes, we can store a maximum of
2**32 / 32 =3D 2**22 group descriptors in the first group.
So the maximum number of groups is limited to 2**22 which limits the=20
size of the filesystem to
2**22(groups) * 2**15(blocks) * 2**12(blocksize) =3D 2**49 bytes =3D 51=
2TB

With big block groups, we can grow beyond this limit of 512TB.

>=20
> Based on this analysis, it's clear that the big block groups patch ha=
s
> some benefits, but I'm wondering if they are sufficiently large to be
> worth it, especially since we also have to consider the changes
> necessary to the e2fsprogs (which haven't been written yet as far as =
I
> know).

I already made changes in the e2fsprogs to support larger block groups,
but there is still some work to do.
The first thing is when creating a large filesystem (over 512TB or=20
perhaps before) which is the optimal value for the block group size ?
How to set its default value used by mkfs ?
It is why I do tests now to see the behavior of a system when increasin=
g=20
  the size of the block groups.

   Val=E9rie
