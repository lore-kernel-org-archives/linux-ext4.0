From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] libblkid: support for GUID Partition Table (GPT),
	please?
Date: Mon, 17 May 2010 11:47:53 +0200
Message-ID: <20100517094753.GK2209@nb.net.home>
References: <87632ql0pg.fsf@violet.siamics.net> <87vdapkgnk.fsf@violet.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0EQJrw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 May 2010 05:47:52 -0400
Content-Disposition: inline
In-Reply-To: <87vdapkgnk.fsf@violet.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 15, 2010 at 10:06:23AM +0700, Ivan Shmakov wrote:
> >>>>> "IS" =3D=3D Ivan Shmakov <ivan@main.uusia.org> writes:
>=20
>  IS> GPT contains a supposed to be unique =E2=80=9CDisk GUID=E2=80=9D=
 field, which
>  IS> allows for the media bearing such a partition table to be
>  IS> identified.

 The devel version of libblkid from util-linux-ng supports partition ta=
bles
 parsing, and the partition name (GPT nad Mac) and partition UUID (only=
 GPT)
 are exported to udev. For example:

   # blkid -p -o udev /dev/sdb1
   ID_PART_ENTRY_SCHEME=3Dgpt
   ID_PART_ENTRY_NAME=3DThisIsName
   ID_PART_ENTRY_UUID=3Dbc10cf1d-7e63-524c-8203-087ae10a820b
   ID_PART_ENTRY_TYPE=3Da2a0d0eb-e5b9-3344-87c0-68b6b72699c7
   ID_PART_ENTRY_NUMBER=3D1

 In my TODO list is to support partition identifiers for standard
 operations like mount/fsck, something like:

   # mount PARTUUID=3Dbc10cf1d-7e63-524c-8203-087ae10a820b /mnt
 or
   # mount PARTLABEL=3DThisIsName /mnt
=20
 Comments?

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
