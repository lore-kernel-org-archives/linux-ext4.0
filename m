From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.7)
Date: Fri, 07 Mar 2008 16:08:37 -0800
Message-ID: <1204934917.14884.70.camel@localhost.localdomain>
References: <200803060001.AA00322@TNESG9526.rs.jp.nec.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35793 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205AbYCHAJN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 19:09:13 -0500
In-Reply-To: <200803060001.AA00322@TNESG9526.rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-06 at 09:01 +0900, Akira Fujita wrote:
> Hi all,
>=20
> I have updated ext4 online defrag to interchange
> the data blocks of the target and temporary files=20
> in an atomic manner.
> We have no corruption in the target file anymore
> if unexpected system down occurs while doing defrag. =20
>=20

Thanks for the update.

> Next step:
> Remove the limit of target file size (now 128MB) in -f mode.
> * Past mail concerning -f mode.
> http://marc.info/?l=3Dlinux-ext4&m=3D118239067704899&w=3D4
>=20

The old version have many useful high level description, could you
preserve that and add to the change logs in this updated series?

> Dependency:
> My patches depend on the multi-block allocation in ext4 patch queue.
>=20
mballoc patch already in maintain so this dependency could be removed.

> Summary of patches:
> * These patches are applied on the top of
>   ext4 git tree(linux-2.6.25-rc3-git4).=20
>   http://repo.or.cz/r/ext4-patch-queue.git
>   And attached files are the updated patches.
>=20

I assume the following three patches are diffs against current ext4
patch queue

> [PATCH 1/3]
>  - Interchange the data blocks of the target and
>    temporary files in an atomic manner.
>=20
> [PATCH 2/3]
> =E3=80=80- Change the name of functions.
> =E3=80=80   ext4_ext_xxx -> ext4_defrag_xxx
> =E3=80=80- Some cleanups.
>=20
> [PATCH 3/3] ext4 online defrag command
>  - Change the error handling for ext4_iget().
>  - Usage is as follows:
>    o Put the multiple files closer together.
>      # e4defrag -r directory-name
>    o Defrag for free space fragmentation.
>      # e4defrag -f file-name
>    o Defrag for a single file.
>      # e4defrag file-name
>    o Defrag for all files on ext4.
>      # e4defrag device-name
>=20
> Review and comment are welcome.
>=20

Attempted to do so...

The updated patch series could not compile one-by-one, could you rework
the series so that in the future we could able to bi-search the ext4
patch queue? As a whole, I got compile warning when applied all the
updated patches:(

review comments against the 4 updated kernel patches to follow.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
