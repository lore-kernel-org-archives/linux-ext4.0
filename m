From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Thu, 27 Oct 2011 02:35:05 -0400
Message-ID: <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:52309 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab1J0GkN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 02:40:13 -0400
In-Reply-To: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 26, 2011, at 7:36 PM, Andreas Dilger wrote:

> Ted,
> we were having a discussion about bigalloc and the maximum file size
> (as limited by the 2^32 logical block number in struct ext4_extent).
>=20
> Currently the maximum file size is blocksize * 2^32, 16TB for 4kB blo=
cks.
>=20
> Since it is not possible to allocate sub-blocks in the bigalloc code,
> what about storing the "chunk number" in the extent logical block?

This adds all sorts of complexity, and it's why we can't simply increas=
e the block size above a page size.  Basically, avoiding all of the com=
plex changes needed was the whole point of the bigalloc feature.

Effectively, if we stored the "chunk number" in the extent tree blocks,=
 it's equivalent of setting the block size to the larger chunk size.  A=
mong other things, it means that we have to support setting or clearing=
 the uninitialized bit in chunks larger than a page, and how dirtying a=
 4k page in a sparse file would require clearing 64k or 1 megabyte (wha=
tever the chunk size might be) either on disk or in memory.

In any case, it's not a simple change that we can make before the merge=
 window.   If someone wants to work on that, we can support that simply=
 by supporting block size > page size, with all of the complexity and p=
ain which has prevented us from supporting that for the last ten years=85=
=2E

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
