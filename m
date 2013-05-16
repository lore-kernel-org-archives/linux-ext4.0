From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 15:50:38 -0500
Message-ID: <5195469E.4090200@redhat.com>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com> <5195456D.8030805@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab3EPUum (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:50:42 -0400
In-Reply-To: <5195456D.8030805@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/13 3:45 PM, Toralf F=C3=B6rster wrote:
> Forget to mention, that now df shows for the loop the same values as =
for / :

because it's "half unmounted" - mtab still has it, so df is
doing a statfs of it, but it's not really mounted (as /proc/mounts
shows) so you get a 2nd statfs on /

-Eric

> n22 ~ # df
> Filesystem     1K-blocks     Used Available Use% Mounted on
> rootfs         188262740 32904632 145771804  19% /
> /dev/root      188262740 32904632 145771804  19% /
> devtmpfs         4086480        0   4086480   0% /dev
> tmpfs            4086744      888   4085856   1% /run
> shm              4086744        0   4086744   0% /dev/shm
> cgroup_root        10240        0     10240   0% /sys/fs/cgroup
> /dev/sdb4      530428688 24466632 505962056   5% /mnt/E
> tmpfs            3145728   243872   2901856   8% /mnt/ramdisk
> /dev/loop0     188262740 32904632 145771804  19% /mnt/trinity
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
