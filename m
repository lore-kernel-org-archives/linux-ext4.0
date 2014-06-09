From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
Date: Mon, 09 Jun 2014 16:10:18 -0400
Message-ID: <539614AA.3040409@suse.com>
References: <20140604202758.GC22927@quack.suse.cz> <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaFIUKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 16:10:23 -0400
In-Reply-To: <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/7/14, 7:52 PM, Linus Torvalds wrote:
> On Wed, Jun 4, 2014 at 1:27 PM, Jan Kara <jack@suse.cz> wrote:
>> Hello Linus,
>>=20
>> could you please pull from
>>=20
>> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git=20
>> for_linus
>>=20
>> to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and=20
>> some small cleanups.
>=20
> This does not work at all for me:
>=20
> fs/reiserfs/do_balan.c: In function =E2=80=98balance_leaf_new_nodes=E2=
=80=99:=20
> fs/reiserfs/do_balan.c:1248:3: error: implicit declaration of=20
> function =E2=80=98format_bh=E2=80=99 [-Werror=3Dimplicit-function-dec=
laration]=20
> RFALSE(!buffer_journaled(tb->S_new[i]) ^
>=20
> Hmm? "format_bh()"?

Weird. That's part of a follow-on patchset. One of the patches gets
rid of do_reiserfs_warning printing into a static buffer w/o a lock. I
must've forgotten a 'quilt add' when adding that chunk to the newer
patch. I'll review what else, if anything, might've changed but for
now, that should be be s/format_bh(tb->S_new[i])/tb->S_new[i]/.

- -Jeff

- --=20
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTlhSqAAoJEB57S2MheeWyy+IP/iYBJbocG4hF8364ognOfyX+
Q1wEzuNvRbZkplNueI1spfvdSJdJ2xMkWYXhaX2WwjQtG+pibLTUbFe8fgEh4egL
0yxtkENeJye0RsCJVALH25iu3iL0u6e03phM6FyvgkRra1jOWSMXJTAlV8ZpQs3o
EXBQ5qoojOaWc3yGmYEugXkLOp5JyJZn0S9EbWqBKw9v8e01kz1zxzfUAoiYb6Ug
hhoXiP2MOhTsgGgMJcCuk2cPNZ2CmHBlv++hGmyA/Dbne1oi+TacaHilwXI2xNI+
fU0IgSVdVC4avZDXXAXLbz0oBLz4/ba/OIiFN8htipNU9wUBJ+GFawpEZIqZ8iTz
WEptpUhcjZdc2SXJxuajjf2Am4VmTt3Rv/wg8kvopD0ANT9sJxLPuKENFqqiusVe
ugE7tL4JkHbz4vm4cbNu3YP7LfXtq/s3EpwiW5SJMVcKURaOriyYrOYbdJ73yKwb
P1K7sj+z3zKmPVuRrbDOgyVKMP1xxb8/ockJVawRUx4vZcn08Nu5f7ZofPewW/mT
XVHDe+YFC+IGLqJwudE0j6O6ZAWZTt1uJeg6IoFenuJhZACZiT/dhR2r5z/kCclk
0VFpLhKR+xy8Q7BB3gDWYZ/NFS7RA8gEu0pbIOj36LUyERX4UeUOsH+oWYoxLvwj
sazZbiauomfvBVZxu4+f
=3D4Lqx
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
