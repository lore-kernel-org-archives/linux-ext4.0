From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Large buffer cache in EXT4
Date: Sun, 17 Feb 2013 11:25:39 +0100
Message-ID: <201302171125.40116.Martin@lichtvoll.de>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com> (sfid-20130217_102624_558919_7A70A64E)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36393 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3BQKZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 05:25:41 -0500
In-Reply-To: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Sonntag, 17. Februar 2013 schrieb Subranshu Patel:
> I created 2 filesystem on my system (RHEL 6.3, kernel version 2.6.32)
> - XFS and EXT4 and mounted them.
>=20
> On both the filesystem I executed the mdtest tool(opensource tool) fo=
r
> 64 concurrent process. Each process performed the following:
> - Create large number of directories
> - Remove all the directories
>=20
> During this time I monitored the memory usage of the system using sar
> command. I checked the 3 components - kbmemused, kbbuffers and
> kbcached
>=20
> kbmemused - Amount of used memory in kilobytes. This does not take
> into account memory used by the kernel itself.
> kbbuffers - buffer cache
> kbcached - page cache
>=20
> While the kbmemused and kbcached component was almost similar in EXT4
> and XFS (XFS being a little higher), the kbbuffer showed a totally
> different trend.
>=20
> For EXT4, kbbuffers was:
> 390999KB for dir creation
> 364803KB for dir removal
> For XFS, kbbuffers was:
>=20
> 1701KB for dir creation
> 2738KB for dir removal
>=20
> In kernel 2.6, both buffer cache and page cache are merged. The page
> cache caches pages of files. The buffer cache caches disk blocks whic=
h
> consists of mainly metadata (not file data).
>=20
> Why is the buffer cache large in case of EXT4 and what is stored in
> the buffer cache?

What is stored in the buffer cache? An interesting question. I also won=
dered=20
about it.

I always thought filesystem metadata that is to be written to the disk.=
 As=20
opposed to dirty pages which are counted in Dirty: in /proc/meminfo.

Then on being asked in a Linux Performance Analyse and Tuning training =
I=20
held where I had some little Linux kernel hackers in there, it seemed t=
o me,=20
they found out, that it is a disk block buffer by looking at the source=
=2E And=20
indeed on doing dd if=3D/dev/zero of=3D/dev/somedevice bs=3D1M or so th=
e buffer=20
count raises considerably.

What I never really understand was what is the clear distinction betwee=
n=20
dirty pages and disk block buffers. Why isn=C2=B4t anything that is abo=
ut to be=20
written to disk in one cache?

Can anybody enlighten me?

PS: buffers=3D0 with BTRFS also.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
