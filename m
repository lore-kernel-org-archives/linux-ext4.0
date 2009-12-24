From: Teran McKinney <sega01@gmail.com>
Subject: Re: benchmark results
Date: Thu, 24 Dec 2009 12:59:20 +0000
Message-ID: <b245135e0912240459j3ca92827sc69bb4665f60d8c3@mail.gmail.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Which I/O scheduler are you using? Pretty sure that ReiserFS is a
little less deadlocky with CFQ or another over deadline, but that
deadline usually gives the best results for me (especially for JFS).

Thanks,
Teran

On Thu, Dec 24, 2009 at 10:31, Christian Kujau <lists@nerdbynature.de> =
wrote:
> I've had the chance to use a testsystem here and couldn't resist runn=
ing a
> few benchmark programs on them: bonnie++, tiobench, dbench and a few
> generic ones (cp/rm/tar/etc...) on ext{234}, btrfs, jfs, ufs, xfs, zf=
s.
>
> All with standard mkfs/mount options and +noatime for all of them.
>
> Here are the results, no graphs - sorry:
> =C2=A0 http://nerdbynature.de/benchmarks/v40z/2009-12-22/
>
> Reiserfs is locking up during dbench, so I removed it from the
> config, here are some earlier results:
>
> =C2=A0 http://nerdbynature.de/benchmarks/v40z/2009-12-21/bonnie.html
>
> Bonnie++ couldn't complete on nilfs2, only the generic tests
> and tiobench were run. As nilfs2, ufs, zfs aren't supporting xattr, d=
bench
> could not be run on these filesystems.
>
> Short summary, AFAICT:
> =C2=A0 =C2=A0- btrfs, ext4 are the overall winners
> =C2=A0 =C2=A0- xfs to, but creating/deleting many files was *very* sl=
ow
> =C2=A0 =C2=A0- if you need only fast but no cool features or journali=
ng, ext2
> =C2=A0 =C2=A0 =C2=A0is still a good choice :)
>
> Thanks,
> Christian.
> --
> BOFH excuse #84:
>
> Someone is standing on the ethernet cable, causing a kink in the cabl=
e
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-de=
vel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
