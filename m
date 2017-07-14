From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: More thoughts about xattrs, journal credits, and their location
Date: Fri, 14 Jul 2017 15:13:27 -0700
Message-ID: <3B21155F-4426-413C-AF16-84E594812530@dilger.ca>
References: <20170706023819.32272-1-tahsin@google.com>
 <20170706023819.32272-2-tahsin@google.com>
 <20170708050900.afuwwia7c4izliir@thunk.org>
 <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
 <CAAeU0aMZjeX6utQfAPa131mhTPK27W4BtWodXYLPT3pss7Tp-w@mail.gmail.com>
 <522BF129-AE45-4722-BCC3-0DDC6A078EB8@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0A54B34E-1FE7-4ECE-B04E-7F72D3B4123C";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33147 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdGNWNc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jul 2017 18:13:32 -0400
Received: by mail-it0-f67.google.com with SMTP id 188so13573710itx.0
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jul 2017 15:13:32 -0700 (PDT)
In-Reply-To: <522BF129-AE45-4722-BCC3-0DDC6A078EB8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0A54B34E-1FE7-4ECE-B04E-7F72D3B4123C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 9, 2017, at 14:01, Tahsin Erdogan <tahsin@google.com> wrote:

>> What we could do is have ext4_new_inode check to see if there are
>> enough credits to do add the xattr's (if necessary) in a single
>> commit.  If not, what we could do is to add the inode to the orphan
>> list, and then set an inode state flag indicating we have done this.
>> At this point, we *can* break the ext4_new_inode() operation into
>> multiple commits, because if we crash in the middle the inode will be
>> cleaned up when we do the orphan list processing.
>=20
> This makes sense. Also, we currently add the worst case credit
> estimates of individual set xattr ops and start a journal handle with
> the sum of it. A slight optimization is to do this lazily.
> We can start with enough credits that can get us to a point where it
> is safe to start a new transaction (safe because of orphan addition).
> Then opportunistically extend the credits to get us to the next safe
> point, if that doesn't work, do the orphan add operation and start a
> new transaction. This should handle the worst case scenario and also
> optimize for common case. Also this should in general reduce the
> amount of allocated-but-unused credits which helps parallelism.

What about accumulating the total xattr size in the credits calculation? =
In
most cases we know the xattr sizes in advance, and if the transaction =
handle
tracks the total xattr size it can make a good estimate whether the =
xattrs
will fit in the inode or not rather than using worst-case credits all =
the time.

>> The downsides of this approach is that it causes the orphan list to =
be
>> a bottleneck.  So we would definitely not want to do this all time.
>=20
> Yes and I think lazy extend/restart should mitigate this.

Jan had a patch to improve the orphan list performance that never made =
it
into the kernel by having a per-CPU orphan list or similar.

It recall it got hung up on running out of reserved inodes or similar, =
which
is an issue we should fix in any case.

Cheers, Andreas






--Apple-Mail=_0A54B34E-1FE7-4ECE-B04E-7F72D3B4123C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZaUIHpIg59Q01vtYRAl+6AJ9NvMuZa6wF+V4cz0hsIONxP+oz8gCeOG2J
BZPxKCL1Uspt79hbr1R1J9Q=
=YO3m
-----END PGP SIGNATURE-----

--Apple-Mail=_0A54B34E-1FE7-4ECE-B04E-7F72D3B4123C--
