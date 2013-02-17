From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Large buffer cache in EXT4
Date: Sun, 17 Feb 2013 11:19:11 +0100
Message-ID: <201302171119.11371.Martin@lichtvoll.de>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com> <6F61E227-A6F7-4AD6-9B9C-39E9E9EAABFA@dilger.ca> (sfid-20130217_102626_808359_E4FE7377)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Subranshu Patel <spatel.ml@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50288 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3BQKTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 05:19:13 -0500
In-Reply-To: <6F61E227-A6F7-4AD6-9B9C-39E9E9EAABFA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Sonntag, 17. Februar 2013 schrieb Andreas Dilger:
> On 2013-02-16, at 21:04, Subranshu Patel <spatel.ml@gmail.com> wrote:
> > I created 2 filesystem on my system (RHEL 6.3, kernel version 2.6.3=
2)
> > - XFS and EXT4 and mounted them.
> >=20
> > On both the filesystem I executed the mdtest tool(opensource tool) =
for
> > 64 concurrent process. Each process performed the following:
> > - Create large number of directories
> > - Remove all the directories
> >=20
> > During this time I monitored the memory usage of the system using s=
ar
> > command. I checked the 3 components - kbmemused, kbbuffers and
> > kbcached
> >=20
> > kbmemused - Amount of used memory in kilobytes. This does not take
> > into account memory used by the kernel itself.
> > kbbuffers - buffer cache
> > kbcached - page cache
> >=20
> > While the kbmemused and kbcached component was almost similar in EX=
T4
> > and XFS (XFS being a little higher), the kbbuffer showed a totally
> > different trend.
> >=20
> > For EXT4, kbbuffers was:
> > 390999KB for dir creation
> > 364803KB for dir removal
> > For XFS, kbbuffers was:
> >=20
> > 1701KB for dir creation
> > 2738KB for dir removal
> >=20
> > In kernel 2.6, both buffer cache and page cache are merged. The pag=
e
> > cache caches pages of files. The buffer cache caches disk blocks wh=
ich
> > consists of mainly metadata (not file data).
> >=20
> > Why is the buffer cache large in case of EXT4 and what is stored in
> > the buffer cache?
>=20
> XFS does not use buffer cache, while ext[234] does use buffer cache.
>=20
> This is just a different code design. Ext4 uses the buffer cache to t=
rack
> metadata for journaling.

Doesn=B4t XFS use its own mechanism with xfsbufd kernel thread?

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
