Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95654C169C4
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 01:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465C121473
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 01:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="x6evQzxH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfA3B2m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 20:28:42 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45738 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfA3B2l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 20:28:41 -0500
Received: by mail-pg1-f196.google.com with SMTP id y4so9575840pgc.12
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 17:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=wWrA8ptP7CVWXbwpyxmHdBpuvLMWo79jcY7gaTcplSM=;
        b=x6evQzxHYem9gIGCQf+ls1bH/9b2ox7taYqMwRAPFmE7LQa0G5hnwfjg8XyX4Dzj09
         RhLg7rFKEHaurZMyyuMaQmRB8SAw4UyJNjeEg83VOlUaotgdzLEhpu6xB9jutzq81WqD
         V6fA98H2z1Fu3j2zsFRTV320KF06ZEuHDe+5gIAs48uuYlvgl9f4Ia2t847fBCYM7yWF
         /yJaaqWkRXZ/LqdjnAlUNKBPIt9x413Fh6xCuQJ6jt6wlAe/JkR8W7GoDjVi6b4+Qtsd
         ZUlodiNkwXpbf3uSOezLvbAUbXrakOIOsHWF7B57960WljF9iALAHmc2/WhrAwmJp24E
         VJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=wWrA8ptP7CVWXbwpyxmHdBpuvLMWo79jcY7gaTcplSM=;
        b=tG32scK9H2CvTAx+UqqZ1DAQDzZxrT0Nn3cxlE2V1tPd+6kqBVRrFlm59527eLq1Ub
         wdzJZR1jRmUl5zTwGF7iQOOVZ7udBFm4LaVY1x4Kitfr8x14bV5PQLHGbI0XuwJ1tRm9
         NkfIZOhLoM3ckaEz8SdvzZVh4LDUMS7s3mOTlKMVJE49WYnEDD13MhvHw61v+BIJqU31
         J3z9+u9+jyL8GMaop1p4GGC59uKZvDsb1BiJ5ZIaZ9gelvcGPsoQhuV1sADvdUXX7n2v
         M+tRR1+3IepQNsJRcfJUPhXv9Ay/Q3NG4ZQx5tyUGc5s9ZoP/t6DL6SyuKn2aC5oiVOz
         6RNQ==
X-Gm-Message-State: AJcUukf+xVVb9VQFPoFS3kKIAE5p4eHWSVnALAp9LEol/0b0yIdVUOT6
        3Qc9ru1sPrEXfRb8j1QC/8sj03PWioc=
X-Google-Smtp-Source: ALg8bN7h2vvA9NqwRwVlAkoPVvG1rWkYj1EaxfXR4YWvezDfOTPCvC5fB6qaCUDb4oxHXON33vWp5A==
X-Received: by 2002:a63:fa58:: with SMTP id g24mr25137721pgk.390.1548811720636;
        Tue, 29 Jan 2019 17:28:40 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54? ([2605:8d80:4a0:7c8a:14fc:648d:efbb:9e54])
        by smtp.gmail.com with ESMTPSA id n22sm38740pfh.166.2019.01.29.17.28.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 17:28:39 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <89166FB4-CE4F-4FA8-B1F2-AD0AA34F88DA@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_745CD562-674A-4CFB-8860-BD26C877C68A";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: Replace opencoded i_writecount usage with
 inode_is_open_for_write
Date:   Tue, 29 Jan 2019 18:23:05 -0700
In-Reply-To: <20181211082355.19841-1-nborisov@suse.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
References: <20181211082355.19841-1-nborisov@suse.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_745CD562-674A-4CFB-8860-BD26C877C68A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 11, 2018, at 1:23 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>=20
> There is a function which clearly conveys the objective of checking
> i_writecount. Additionally the usage in ext4_mb_initialize_context was
> wrong, since a node would have wrongfully been reported as writable if
> i_writecount had a negative value (MMAP_DENY_WRITE).
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c   | 2 +-
> fs/ext4/mballoc.c | 7 +++----
> 2 files changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..04e5bc0b5c8d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -391,7 +391,7 @@ void ext4_da_update_reserve_space(struct inode =
*inode,
> 	 * inode's preallocations.
> 	 */
> 	if ((ei->i_reserved_data_blocks =3D=3D 0) &&
> -	    (atomic_read(&inode->i_writecount) =3D=3D 0))
> +	    !inode_is_open_for_write(inode))
> 		ext4_discard_preallocations(inode);
> }
>=20
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2248083cdca..6fb76d408093 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4176,9 +4176,8 @@ static void ext4_mb_group_or_file(struct =
ext4_allocation_context *ac)
> 	isize =3D (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - =
1)
> 		>> bsbits;
>=20
> -	if ((size =3D=3D isize) &&
> -	    !ext4_fs_is_busy(sbi) &&
> -	    (atomic_read(&ac->ac_inode->i_writecount) =3D=3D 0)) {
> +	if ((size =3D=3D isize) && !ext4_fs_is_busy(sbi) &&
> +	    !inode_is_open_for_write(ac->ac_inode)) {
> 		ac->ac_flags |=3D EXT4_MB_HINT_NOPREALLOC;
> 		return;
> 	}
> @@ -4258,7 +4257,7 @@ ext4_mb_initialize_context(struct =
ext4_allocation_context *ac,
> 			(unsigned) ar->goal, ac->ac_flags, =
ac->ac_2order,
> 			(unsigned) ar->lleft, (unsigned) ar->pleft,
> 			(unsigned) ar->lright, (unsigned) ar->pright,
> -			atomic_read(&ar->inode->i_writecount) ? "" : =
"non-");
> +			inode_is_open_for_write(ar->inode) ? "" : =
"non-");
> 	return 0;
>=20
> }
> --
> 2.17.1
>=20


Cheers, Andreas






--Apple-Mail=_745CD562-674A-4CFB-8860-BD26C877C68A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxQ/HkACgkQcqXauRfM
H+DJWA/+JAdBvvZWV9WyXO8LH6XXuDAJkxjfetkI2s6wjNvLnk/cFlUTrTwPqBlm
GWcw4s6LeFN2HxspfXGDKVJyi1H/ubbxDWac0s9F/Uu0V+e64xibW8YZIfzZWnjj
NC9cRLf4ZLnJepObplR+6HqBzMFciFPoqurORfgdSEBIXVx3QPus/REV9Lrc2zuw
oVyE0xnQ2ClbtOzUX1lLWscoYCp1s+XF9of+Pv5exabQEpeY0o/XsG2Lf2paV5dO
P4OLx+ZnrZjl6smC/tJ8busfR96TvTrgXgBYuB+MfjaqZIgJhFSBVIxwnKTchI7R
6Qd7EdOrgVT2EYf4ZFjV3IrH/RlwfxHb8jmFb3Xmy64J9VzALdM++dpKUdvPwPYb
142iM9TBoBCsAOOye+6T/1THHvahKPYrty53+ajIcq7FHeKMFPynBiXeDchH3XRP
zfpWGCSBn99OW/bv1ZNxSsNnCcU30kTQneQ3vvnL0YPDY5/OD6JlbI1gLriiPEJC
eVopbKYZnTB0C3cvtwS3WktHv+ksODM7LLKWX1Ib1m5UGT4g7+sGWmGZzybncFkL
tQpGmfICC8T4F5C4J1oGda2q/6huvl9dcwqKnIYViv5adf7gM3e2IjG5Qkb6mXZ1
MFZy2aiUJCFQWaN/JtGk+jqKNLoD064R7y6exmpmsijiuN1NMeY=
=Lumg
-----END PGP SIGNATURE-----

--Apple-Mail=_745CD562-674A-4CFB-8860-BD26C877C68A--
