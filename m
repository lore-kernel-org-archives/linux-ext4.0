From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Mon, 26 Jun 2017 14:45:56 -0600
Message-ID: <97EC040D-FF3D-4921-8CF0-F338542BAA42@dilger.ca>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
 <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca>
 <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
 <20170623232616.r3ffksjntjfbrzgb@thunk.org>
 <54BEB476-F6E0-4421-B381-92442457910F@dilger.ca>
 <20170624002454.wjieb3ppvljumzzj@thunk.org>
 <CAAeU0aOQF=g7zAP5gtOb0ur-zN-crsHTWNbTYJJZvVJa+JoB_w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5C6CE0F5-ECB6-4DAC-BA73-91C9D3D10CE2";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
        Khazhismel Kumykov <khazhy@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34320 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdFZUqE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 16:46:04 -0400
Received: by mail-it0-f66.google.com with SMTP id y134so1151026itc.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 13:46:04 -0700 (PDT)
In-Reply-To: <CAAeU0aOQF=g7zAP5gtOb0ur-zN-crsHTWNbTYJJZvVJa+JoB_w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5C6CE0F5-ECB6-4DAC-BA73-91C9D3D10CE2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 26, 2017, at 1:22 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> On Thu, Jun 22, 2017 at 4:23 PM, Khazhismel Kumykov =
<khazhy@google.com> wrote:
>> -                       /* read error, skip block & hope for the best =
*/
>>                        EXT4_ERROR_INODE(dir, "reading directory =
lblock %lu",
>>                                         (unsigned long) block);
>>                        brelse(bh);
>> -                       goto next;
>> +                       ret =3D ERR_PTR(-EIO);
>> +                       goto cleanup_and_exit;
>=20
> EXT4_ERROR_INODE() triggers ext4_handle_error() which performs error
> handling. I think it should be removed here because we are returning
> the error to the caller and there is nothing more drastic about this
> error than other error return paths in the same function.

The issue is that this represents filesystem corruption, since the
IO error in the leaf block means some files cannot be looked up, and
new files cannot be created in this directory.  Running e2fsck will
repair this problem, so ext4_handle_error() will mark the filesystem
in error so that e2fsck will be run on the next restart and this error
is not lost because it is only returned to the application.

The sysadmin already has the option to declare the behaviour of
ext4_handle_error() - "continue" (which seems to what you are already
running), "remount-ro" (what we are using), or "panic" the node (which
some HA systems use).

To my reading, this patch only applies to the "continue" case, and it
is good to make this handling more robust.  Similar work was done with
the block and inode bitmaps (EXT4_{MB_GRP,GROUP_INFO}_BBITMAP_CORRUPT
and EXT4_{MB_GRP,GROUP_INFO}_IBITMAP_CORRUPT) to skip allocations in
those groups if an error is detected.

Cheers, Andreas


--Apple-Mail=_5C6CE0F5-ECB6-4DAC-BA73-91C9D3D10CE2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUXKFpIg59Q01vtYRAgvlAJ9MPa2wklmlx9Q1C413ToWTpEYaUACfT6XJ
Yt/8dCeusxHfW/1p3zI9Opw=
=ZwSG
-----END PGP SIGNATURE-----

--Apple-Mail=_5C6CE0F5-ECB6-4DAC-BA73-91C9D3D10CE2--
