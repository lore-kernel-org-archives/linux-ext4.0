From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question on delalloc
Date: Tue, 4 Jun 2013 01:22:03 -0400
Message-ID: <20130604052203.GA29587@thunk.org>
References: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?5a6L5p+P57+w?= <solarispika@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54560 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab3FDFWH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 01:22:07 -0400
Content-Disposition: inline
In-Reply-To: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 04, 2013 at 03:00:29AM +0800, =E5=AE=8B=E6=9F=8F=E7=BF=B0 w=
rote:
> Also after I traced into filemap_write_and_wait_range, I found it
> eventually calls ext4_writepage to do the most part of work, which in
> its comment says "We don't do any block allocation in this function."
>=20
> So, can anyone kindly shed any light on my question, or point out my =
mistakes?

There are three possible address_space_operations structures that can
be used for ext4 files.  They are ext4_aops, ext4_journalled_aops, and
ext4_da_aops.  It is the last one which is used for delayed allocation
files, and in that case filemap_write_and_wait_range will use
ext4_da_writepages().

These days, if there is an writepages function, the writepage function
is not used at all.  It used to be used for direct reclaim, but that's
been replaced by I/O-less reclaim.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
