From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: File limit inside a single directory
Date: Thu, 12 Feb 2015 17:55:14 -0700
Message-ID: <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55> <54DD0091.1050104@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "suntrop@web.de" <suntrop@web.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36317 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbBMAzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2015 19:55:15 -0500
Received: by pdjp10 with SMTP id p10so15696901pdj.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2015 16:55:14 -0800 (PST)
In-Reply-To: <54DD0091.1050104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We started to have problems in our testing around 15M entries in one di=
rectory (depends on hashing, add/remove cycles), but 10-12M entries is =
probably safe unless the filenames are long (e.g. above 32 chars).=20

Cheers, Andreas

> On Feb 12, 2015, at 12:35, Eric Sandeen <sandeen@redhat.com> wrote:
>=20
>> On 2/12/15 1:16 PM, suntrop@web.de wrote:
>> Hello, i=E2=80=99m using a CMS which puts many files inside a single
>> directory. I=E2=80=99m wondering what the maximum number of files is=
 which
>> can reside inside said directory. Is there a number which should not
>> be exceeded on account of performance reasons e.g. Is there a
>> difference between ext3 and ext4?
>>=20
>> Thanks!
>=20
> for htree directories, you will be limited by the max size of the tre=
e, which currently is of limited depth.  That limit then depends on blo=
ck size and filename lengths.
>=20
> for 4k blocks, and 40 char names, you max out at around 20 million di=
rectory entries, if my old spreadsheet is still correct.
>=20
> That limit is the same for ext3 and ext4.
>=20
> performance-wise, to be honest, I'm not sure.  how many inodes are yo=
u talking about?
>=20
> -Eric
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
