From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: File limit inside a single directory
Date: Sat, 14 Feb 2015 11:25:08 -0700
Message-ID: <160BB0B1-21A0-4689-8EF4-DBC3E3D52651@dilger.ca>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55> <54DD0091.1050104@redhat.com> <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca> <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16> <54DE3442.90707@redhat.com> <trinity-dc6eb585-f943-49c8-8da6-907e488f6402-1423909029655@3capp-webde-bs16>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "suntrop@web.de" <suntrop@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56988 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbbBNSZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2015 13:25:12 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so25841977pab.3
        for <linux-ext4@vger.kernel.org>; Sat, 14 Feb 2015 10:25:11 -0800 (PST)
In-Reply-To: <trinity-dc6eb585-f943-49c8-8da6-907e488f6402-1423909029655@3capp-webde-bs16>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you are using ext3 then you will get an EMLINK error at 32000 subdir=
s.=20
If you are using ext4 with the "dir_nlink" feature enabled then you
can create several million subdirs if you want.

As for performance, if you are not regularly creating and deleting the
directory I don't think you would even notice the performance differenc=
e
of a large directory.  The create and unlink rate get somewhat slower a=
t
100k files (from 25k/sec to 10k/sec) and 1M entries or so (to 5k/sec).
=46or lookups the whole directory will easily fit into cache (at about =
40MB
for 1M entries) so the lookup rate is not affected much by size.=20

Cheers, Andreas

> On Feb 14, 2015, at 03:17, suntrop@web.de wrote:
>=20
> Sorry for confusion, but now I am confused :-) My setup will be like
> /files/
> /files/1/
> /files/2/
> /files/3/
> (...)
> /files/24244/
> (...)
> /files/113524/
>=20
> Thus all folders reside within the /files/ directory (can't change th=
at).=20
> What happens when the max link count reach 32,000 and I create more f=
olders? Will this result in any errors or problems? I=E2=80=99m using e=
xt3. Is the only consequence that the links aren=E2=80=99t counting up =
any more, like ext4?
> =20
> =20
>=20
> Gesendet: Freitag, 13. Februar 2015 um 18:28 Uhr
> Von: "Eric Sandeen" <sandeen@redhat.com>
> An: suntrop@web.de, "Andreas Dilger" <adilger@dilger.ca>
> Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
> Betreff: Re: File limit inside a single directory
>> On 2/13/15 10:49 AM, suntrop@web.de wrote:
>> Thanks guys. I was afraid of having a couple 100K (at most). The
>> server support team told me not to have more than 10 to 20K. There
>> seems to be a misconception (for me and people from the CMS) about
>> the 32K subdirectory limit, but this ins't for files/folders within =
a
>> single directory but rather nested directories like /1/2/3.../32000
>=20
> You've confused things a bit here, FWIW.
>=20
> The 32k (well, 32000 because, sure) limit on ext3 is max link count;
> each subdirectory increases the link count on its parent, but only
> its parent. It's not about deep nesting, or about files in a dir.
> It's only about subdirs in a parent dir.
>=20
> # mkdir dir
> # stat dir | grep Links
> Device: fd06h/64774d Inode: 2490391 Links: 2 // . and .. entries
> # mkdir dir/subdir1 dir/subdir2 dir/subdir3
> # stat dir | grep Links
> Device: fd06h/64774d Inode: 2490391 Links: 5
> # mkdir dir/subdir1/subsubdir1 dir/subdir1/subsubdir2 dir/subdir1/sub=
subdir3
> # stat dir | grep Links
> Device: fd06h/64774d Inode: 2490391 Links: 5
>=20
> ext4 bumped that max to 64000, and just stops counting if that number
> gets exceeded...
>=20
> -Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
