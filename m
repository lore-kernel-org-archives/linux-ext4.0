From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH -v2] ext4: remove usage of Uptodate flag to initialize
	buddy after an online resize
Date: Wed, 22 Oct 2008 09:56:45 +0200
Message-ID: <1224662205.3569.44.camel@frecb007923.frec.bull.fr>
References: <1222872243.11560.19.camel@frecb007923.frec.bull.fr>
	 <1223036515.4075.11.camel@frecb007923.frec.bull.fr>
	 <1224602191.3569.25.camel@frecb007923.frec.bull.fr>
	 <20081021155228.GE15685@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47552 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYJVHzJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Oct 2008 03:55:09 -0400
In-Reply-To: <20081021155228.GE15685@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le mardi 21 octobre 2008 =C3=A0 11:52 -0400, Theodore Tso a =C3=A9crit =
:
> Hi Frederic,
>=20
> Thanks for posting the update to your patch; I take it you've solved
> the race condition?  I haven't take a look at your updated patch yet,
> but one thought that might make the potential race conditions much
> simpler to analyze and prevent.

Yes the race condition I found is solved with this patch. The issue
happened when concurrent threads try to write to blocks in groups which
had been added by the resizing. As I briefly explained in the patch, it
was a matter of mballocator's datas which were wrongly initialized
several times.

> At the moment, the resize code, just before it calls to fix up the
> mballoc data structures, calls ext4_free_blocks_sb() to mark the bloc=
k
> bitmap as being freed.  That call should really go away, as
> ext4_free_blocs_sb() is a remnant from the legacy block allocator, an=
d
> in fact does a lot of extra stuff that is not needed by mballoc().
> Perhaps the right answer is that we should have one function that
> updates the block bitmap, as well as initializing the mballoc() data
> structures, and it would *only* be called from the resize code.  If

OK, I will take a look at this function and see if I can update/clean
it.

> the concern is protecting against multiple resizers running at the
> same time, then let's either (a) not call unlock_super() until the
> mballoc data structures are initialized, or (b) create a new mutex
> that is explicit for use by the online resize code.
>=20

In fact, I have never tested with multiple resizers til now because I
never managed to run several instance of resize2fs concurrently: if a
resize2fs is running, the second one simply fails with a "device busy"
error.

=46rederic



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
