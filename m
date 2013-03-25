From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Mon, 25 Mar 2013 08:53:09 -0400
Message-ID: <20130325125309.GE26792@thunk.org>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
 <20130324001143.GB4000@thunk.org>
 <alpine.LFD.2.00.1303251051460.23176@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, gharm@google.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55645 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab3CYMxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Mar 2013 08:53:14 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303251051460.23176@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 25, 2013 at 11:09:35AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Sorry for being dense, but I am trying to understand why this is so
> bad and what is the "expected" column there.
>=20
> The physical offset of each extent bellow starts on the start of the
> block group and it seems to me that it's perfectly aligned for every
> power of two up to the block group size.

Yes, but the logical offset isn't aligned.  Consider the simplest
workload, which is where we are writing the 1GB file sequentially.
Let's assume that the raid stripe size is 8M.  So ideally, we would
want each write to be a multiple of 8M, starting at logical block 0.

But look what happens here:

> > File size of 1 is 1073741824 (262144 blocks of 4096 bytes)
> >  ext:     logical_offset:        physical_offset: length:   expecte=
d: flags:
> >    0:        0..   32766:     458752..    491518:  32767:          =
   unwritten
> >    1:    32767..   65533:     491520..    524286:  32767:     49151=
9: unwritten
> >    2:    65534..   98300:     589824..    622590:  32767:     52428=
7: unwritten

If we do 8M writes, then we would want to write in chunks of 2048
blocks.  So consider what happens when we write the 2048 block chunk
starting with logical block 30720.  The fact that there is a
discontinuity between logical blocks 32766 and 32767 means that we
will have to do a read-modify-write cycle for that particular RAID
stripe.

Does that make more sense?

Another reason why keeping the file as physically contiguous as
possible is because we can now extent caching using the extent status
tree.  So if we can allocate the file using 2 physically contiguous
extents in instead of 9 or 10 physically contiguous extents, it means
the extent status tree uses less memory, too.  For a 1GB file, that
might not make that much difference, but if we caching 2048 of these
1G files (on a 2TB disk, for example), keeping the files as physically
contiguous as possible means we can cache the logical to physical
block mapping of all of these files much more easily.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
