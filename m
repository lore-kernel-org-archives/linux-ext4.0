Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332B4C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF298218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:09:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="bhNLtrfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfCUUJO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:09:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42503 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbfCUUJO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:09:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id p6so4931917pgh.9
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2019 13:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=jidgJ6XN7X0CmtQi3xfHp+wGmQClRtHWbtFjIX9GNDs=;
        b=bhNLtrfENDNDkqZiHu8mt6DfuJj+CrIF441iu7BgfkJpdYlBJbVm9SkpGoMI5ras9l
         H9JisLgELaEKlVAqayMAKmQmMZADHIjzcBAViaNi5uvA3LwX+4FoVxu2hxoyORcGDNHs
         VHWF7kF9rBGigQg1S/EID7emD85L3tAzApgkDUJnrBZdVhfJsF1ij5h29x7A0Bb+ICbu
         zO7jRnKUXSsf9HplQ5cUTPk5Yvjc3IKoTSgiIfinmWkdVE0zK6xG4Y/c2GZXPVfbYMJN
         d44kcCYCgv4qnW3Pc/k9adqF2R27ZBwLZhn/c4J7OBR+DlfbFvCD7i1X6/pJASLvUEMG
         4Rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=jidgJ6XN7X0CmtQi3xfHp+wGmQClRtHWbtFjIX9GNDs=;
        b=cG6BISwFPusf0z5M7j/lTuw3WwKKd7AcC79Fv3uBfoiLkIItR69qoEQoA4V2XGzxKD
         eKdf8IY+g9c5nExCWjUsFafisM4XAWegO1PEvxvVxli8GKjrgMCWpN8vhJOw5KQUOxoT
         HYc9MpCJOS8EICyOVjIsKI0O37mRlo4Owsa5mlr9I5PQA5UoRg94XL4aoTC7AhdH595t
         YBvTBWToIRLsiJ01H+y4yne6egNb9VIuX2TkvOzES0A/s0ihGUhwEjnRHiW9cEGmRrDb
         DmZbe6B0j6rv4LYSA73L/oUD5ipfbU+fkGR0FC0EOPJMFPwPr7KdoduoOl7IJCoYxmdM
         qloQ==
X-Gm-Message-State: APjAAAU7HhzpdHRF+csYfgU2Ot08sSfGVO/MukIIrVB/cU4Cl6X8oN+E
        TE4H/77pp7SxN3OvOqoKqo/9BywmGVpHoA==
X-Google-Smtp-Source: APXvYqwxo7pgp49PvETPhpcQAqA85h90FKqUjiNr0xtJaC7PF2DDdAAdDmIrt2nc3+rWhuua1uYGyQ==
X-Received: by 2002:aa7:8102:: with SMTP id b2mr5158017pfi.69.1553198952839;
        Thu, 21 Mar 2019 13:09:12 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id z127sm6753474pgb.77.2019.03.21.13.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Mar 2019 13:09:11 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <DD9258DD-6E46-425D-837A-9DF70CD64D3D@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_62EC0534-66DE-4D47-9C99-5EC2819E2358";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Date:   Thu, 21 Mar 2019 14:09:08 -0600
In-Reply-To: <20190321155703.ili5ghofgm3hneq5@work>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
To:     Lukas Czerner <lczerner@redhat.com>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu> <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu> <20190321155703.ili5ghofgm3hneq5@work>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_62EC0534-66DE-4D47-9C99-5EC2819E2358
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 21, 2019, at 9:57 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>=20
> So the good news is that it's not really a problem. What you really =
want
> is the mountpoint if it exists and the device otherwise right ?
>=20
> Then my suggestion will do just that becuase awk will separate the =
fieds
> with FS (field separator) which by default is a single space. But =
space
> is special in awk becuase the fields will be separated by a runs of
> space, so if you pick the fileds just right you'll get what you want.
>=20
> So if I run this on my system
>=20
> # lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n -l `lvs -o lv_path -S =
lv_active=3Dactive,lv_role=3Dpublic,lv_role!=3Dsnapshot,vg_free\>256 =
--noheadings`
>=20
> I'll get
>=20
>            /dev/mapper/vg_perpetuum-ext4--suck
>            /dev/mapper/vg_perpetuum-fedora29
>            /dev/mapper/vg_perpetuum-fedora29--2
>            /dev/mapper/vg_perpetuum-freebsd
> /mnt/kernel /dev/mapper/vg_perpetuum-kernel      ext4
> /home       /dev/mapper/vg_perpetuum-lv_home     xfs
> /           /dev/mapper/vg_perpetuum-lv_root     xfs
> [SWAP]      /dev/mapper/vg_perpetuum-lv_swap     swap
> /var        /dev/mapper/vg_perpetuum-lv_var      xfs
>            /dev/mapper/vg_perpetuum-lvol001     ext4
>            /dev/mapper/vg_perpetuum-overlay     ext4
>            /dev/mapper/vg_perpetuum-rhel7
>            /dev/mapper/vg_perpetuum-rhel8
>            /dev/mapper/vg_perpetuum-test0       ext3
>            /dev/mapper/vg_perpetuum-testing     ext4
>            /dev/mapper/vg_perpetuum-testing1    xfs
>            /dev/mapper/vg_perpetuum-thinvolume
>=20
> now if I add
>=20
> | awk '{print $1}'
>=20
> I'll get
>=20
> /dev/mapper/vg_perpetuum-ext4--suck
> /dev/mapper/vg_perpetuum-fedora29
> /dev/mapper/vg_perpetuum-fedora29--2
> /dev/mapper/vg_perpetuum-freebsd
> /mnt/kernel
> /home
> /
> [SWAP]
> /var
> /dev/mapper/vg_perpetuum-lvol001
> /dev/mapper/vg_perpetuum-overlay
> /dev/mapper/vg_perpetuum-rhel7
> /dev/mapper/vg_perpetuum-rhel8
> /dev/mapper/vg_perpetuum-test0
> /dev/mapper/vg_perpetuum-testing
> /dev/mapper/vg_perpetuum-testing1
> /dev/mapper/vg_perpetuum-thinvolume
>=20
>=20
> hence I get mountpoin where the volume is mounted and the device where
> it is not. That's what we need right ?
>=20
> What I did not consider was [SWAP] but we can get rid of that easily.
>=20
> grep -v '[SWAP]'
>=20
> So in the end we'll have something like
>=20
> # lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n -l `lvs -o lv_path -S =
lv_active=3Dactive,lv_role=3Dpublic,lv_role!=3Dsnapshot,vg_free\>256 =
--noheadings` | grep -v '[SWAP]' | grep ' ext[234]$' | awk '{print $1}'

This doesn't need to skip [SWAP] explicitly because it will not have an =
ext[234]
filesystem mounted on it, so would be excluded by the next "grep" =
anyway.

However, if you are using "awk" then there is no need for the extra =
grep(2) I think.
Something like the following looks like it will work:

  lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n -l $(lvs -o lv_path \
      -S lv_active=3Dactive,lv_role=3Dpublic,lv_role!=3Dsnapshot,vg_free\>=
256 --noheadings) |
      awk '($NF > 1 && $2 =3D=3D ext[234]) || ($NF > 2 && $3 =3D=3D =
ext[234]) { print $1 }'

The "$NF" checks appear to be needed because "$3 =3D ext[234]" seems to =
match everything
if "$3" is empty, though I can't understand why that would be desirable.

> and so on my system this gives me
>=20
> /mnt/kernel
> /dev/mapper/vg_perpetuum-lvol001
> /dev/mapper/vg_perpetuum-overlay
> /dev/mapper/vg_perpetuum-test0
> /dev/mapper/vg_perpetuum-test10
> /dev/mapper/vg_perpetuum-test11
> /dev/mapper/vg_perpetuum-test3
> /dev/mapper/vg_perpetuum-test4
> /dev/mapper/vg_perpetuum-test9
> /dev/mapper/vg_perpetuum-testing
>=20
> And leaving out mounted file systems is again as simple as
>=20
> grep -v '^/dev/'
>=20
> Have I missed something ?
>=20
>=20
> Now for the performance. I drop caches, then run each twice
>=20
> the ls_scan_targets function runs
>=20
> real	0m0.575s
> user	0m0.086s
> sys	0m0.179s
>=20
> real	0m0.241s
> user	0m0.088s
> sys	0m0.169s
>=20
>=20
> My one-line suggestion runs
>=20
> real	0m0.275s
> user	0m0.027s
> sys	0m0.047s
>=20
> real	0m0.069s
> user	0m0.015s
> sys	0m0.052s
>=20
>=20
> So the difference is significant, although I would not consider it
> meaningful since it's really low anyway, but some people complained so =
I
> guess someone cares and people do have different systems so...
>=20
>>=20
>> :-)
>>=20
>> We could have used awk to select the field, but that still doesn't
>> deal with the mountpoint column being empty when it is unmounted.  I
>> did briefly consider using lsblk -J, but I didn't want to add a
>> dependency on the jq[1] package (and I didn't even know if =
RHEL/Fedora
>> packages jq).
>>=20
>> [1] https://packages.debian.org/stretch/jq
>=20
> Yes Fedora does have it, but I agree that adding this dependency is =
not
> ideal.
>=20
> Thanks!
> -Lukas
>=20
>>=20
>> Cheers,
>>=20
>> 					- Ted


Cheers, Andreas






--Apple-Mail=_62EC0534-66DE-4D47-9C99-5EC2819E2358
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyT72QACgkQcqXauRfM
H+ADTA//R47EKTuh4UayBBjPVDCFSpiGL0928PXYapWlkNgJoXF+qbeEns5dEe+C
HacSWNTYFgXI8q4KYdIhu01Gt4Zp2Y0lZZqZF1jMdXJEJBlpsMyZunY9L135WErh
81hagBsAeRNalCa2BfNoUBEb3RjJfkCwlMZNS4DGPrTbZiQE3iwsQszVQFmZZIsv
FLj8FxOogpb4WDwPEFB8f6PhX+wyDL5Lu8DMt1ptMUF6v5rpmjzveQ/CWnEpT+gr
Tfe6z3JWZ3G5XsAfAh/1xIJ6Ul9GH2WFQqCBd923nz052vbxDtD2WI6a8Xgh+xM7
1N6vYh/6dMYZZde1nIPxUmtjPeRs4o20/g1VCqY5V4+CwGePzG7ljz7Byenu6eAG
kGXak+bQrR4hRafBw+ocxuRioU6GJIWZkk0oX2DI4R9/ZsuL1vglGz4PGLH+KGQK
eNiE8+3lDn4JdzhvPqOrVVIJa2xmh2DQi80go05mVxkoT/Ji5haO/eMVz2scY44I
ZoCewYyEyk4Us3huFKb5V0fox4Gz7ZDgdKc7ToaZV6Zz/Yrhzv3CD2EcsLT/iV1V
9l6s8VVm91TaV2vfwTBJ93LqQB3YtBGDismeWuDfbYYMqlsZg+DVYwvuKsRtNw1M
iAJvajusD+xCU3qfzbDM15sMm4CM2rEEQf3OXG+crGdPSsdDk/U=
=QzyX
-----END PGP SIGNATURE-----

--Apple-Mail=_62EC0534-66DE-4D47-9C99-5EC2819E2358--
