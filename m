From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Strange "rm -fr" issue
Date: Sun, 29 Dec 2013 11:47:21 -0700
Message-ID: <59DA49F7-C44D-4C50-A9C8-55C0BB78F29C@dilger.ca>
References: <20131229142406.GA393@x4>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46472 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3L2SrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Dec 2013 13:47:23 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so10843848pbc.34
        for <linux-ext4@vger.kernel.org>; Sun, 29 Dec 2013 10:47:22 -0800 (PST)
In-Reply-To: <20131229142406.GA393@x4>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you are able to reproduce this issue (extract the same tree and then
try "rm -fr" again) please run this under strace to see how many entrie=
s are returned during readdir from the kernel.

It could be a bug in the ext4 readdir code or it could be a bug in glib=
c or coreutils.=20

Cheers, Andreas

> On Dec 29, 2013, at 7:24, Markus Trippelsdorf <markus@trippelsdorf.de=
> wrote:
>=20
> I came across the following strange issue today:
>=20
> markus@x4 tmp % rm -fr boost
> rm: cannot remove =E2=80=98boost/results/boost/bin.v2/libs=E2=80=99: =
Directory not empty
> markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> total 68K
> drwxr-xr-x 17 markus markus 4.0K Dec 29 15:01 .
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
> drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 python
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 serialization
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
> markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> total 140K
> drwxr-xr-x 35 markus markus 4.0K Dec 29 15:01 .
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 config
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
> drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 predef
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 preprocessor
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 program_options
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_map
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_tree
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 proto
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ptr_container
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 python
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 random
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 range
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ratio
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 rational
> drwxr-xr-x  5 markus markus 4.0K Dec 29 15:01 regex
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 scope_exit
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 serialization
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 signals
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 signals2
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 smart_ptr
> drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 spirit
> drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
> markus@x4 tmp % rm -fr boost
> markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> ls: cannot access boost/results/boost/bin.v2/libs: No such file or di=
rectory
> markus@x4 tmp %
>=20
> fsck.ext4 shows nothing. Kernel is latest git. coreutils-8.22.
> /dev/sda       ext4      1.8T  743G  1.1T  41% /var
> /dev/sda on /var type ext4 (rw,relatime,data=3Dordered)
>=20
> --=20
> Markus
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
