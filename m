From: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Lazytime undone by/not working with remount?
Date: Mon, 18 May 2015 17:36:52 +0200
Message-ID: <555A0714.8010806@googlemail.com>
References: <pan.2015.05.16.11.05.04@googlemail.com> <55575399.6010801@googlemail.com> <20150518082135.GK4834@ws.net.home> <555A02CF.1000506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>, Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:50488
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbERPnb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2015 11:43:31 -0400
In-Reply-To: <555A02CF.1000506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 05/18/15 17:18, Eric Sandeen wrote:
> On 5/18/15 3:21 AM, Karel Zak wrote:
>> On Sat, May 16, 2015 at 04:26:33PM +0200, Holger Hoffst=C3=A4tte wro=
te:
>>>> playing with lazytime on 4.0.4-rc1 + yesterday's fencepost patch) =
I noticed
>>>> something odd. Mounting secondary (non-root) partitions with lazyt=
ime works
>>>> fine, but / does not seem to retain the value from fstab - apparen=
tly because
>>>> it is remounted rw during boot, and lazytime gets swallowed/undone=
=2E
>>>>
>>>> Same effect when trying to remount manually with lazytime:
>>>>
>>>> tux>findmnt /
>>>> TARGET SOURCE    FSTYPE OPTIONS
>>>> /      /dev/sda1 ext4   rw,noatime
>>>>
>>>> tux>mount -o lazytime,remount /=20
>>>>
>>>> tux>dmesg=20
>>>> [ 5208.482505] EXT4-fs (sda1): re-mounted. Opts: (null)
>>>>
>>>> tux>findmnt /                 =20
>>>> TARGET SOURCE    FSTYPE OPTIONS
>>>> /      /dev/sda1 ext4   rw,noatime
>>>>
>>>> tux>mount --version
>>>> mount from util-linux 2.26.2 (libmount 2.26.0: assert, debug)
>=20
> And what does /proc/mounts say?  That'll tell you what is actually se=
t
> on the superblock.  Works here, on 4.1.0-rc2:
>=20
> # mount /dev/sdb1 /mnt/test
> # mount -o remount,lazytime /mnt/test
> # grep sdb1 /proc/mounts=20
> /dev/sdb1 /mnt/test ext4 rw,lazytime,seclabel,relatime,data=3Dordered=
 0 0
>=20
> # dmesg | tail -n 2
> [516203.450943] EXT4-fs (sdb1): mounted filesystem with ordered data =
mode. Opts: (null)
> [516211.222020] EXT4-fs (sdb1): re-mounted. Opts: lazytime

When I used util-linux 2.26.2 /proc/mounts never contained lazytime for=
 the root device (sda1), despite the fact that it and other partitions =
explicitly had lazytime in fstab. Secondary drives & partitions *did* g=
et the value right from the start, i.e. anything that didn't go through=
 a ro->remount transition.

It all works reliably with 2.25.x since - as Karel mentioned - the bug =
seems with ext4's remount logic in combination with readonly (as was th=
e case with the root partition) and mount now actually sending the MS_L=
AZYTIME flag, instead of relying on ext4's builtin extra handling.

-h

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
