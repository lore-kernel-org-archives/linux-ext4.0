From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Lazytime undone by/not working with remount?
Date: Mon, 18 May 2015 10:18:39 -0500
Message-ID: <555A02CF.1000506@redhat.com>
References: <pan.2015.05.16.11.05.04@googlemail.com> <55575399.6010801@googlemail.com> <20150518082135.GK4834@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Karel Zak <kzak@redhat.com>,
	=?windows-1252?Q?Holger_Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbbERPSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2015 11:18:40 -0400
In-Reply-To: <20150518082135.GK4834@ws.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/18/15 3:21 AM, Karel Zak wrote:
> On Sat, May 16, 2015 at 04:26:33PM +0200, Holger Hoffst=E4tte wrote:
>>> playing with lazytime on 4.0.4-rc1 + yesterday's fencepost patch) I=
 noticed
>>> something odd. Mounting secondary (non-root) partitions with lazyti=
me works
>>> fine, but / does not seem to retain the value from fstab - apparent=
ly because
>>> it is remounted rw during boot, and lazytime gets swallowed/undone.
>>>
>>> Same effect when trying to remount manually with lazytime:
>>>
>>> tux>findmnt /
>>> TARGET SOURCE    FSTYPE OPTIONS
>>> /      /dev/sda1 ext4   rw,noatime
>>>
>>> tux>mount -o lazytime,remount /=20
>>>
>>> tux>dmesg=20
>>> [ 5208.482505] EXT4-fs (sda1): re-mounted. Opts: (null)
>>>
>>> tux>findmnt /                 =20
>>> TARGET SOURCE    FSTYPE OPTIONS
>>> /      /dev/sda1 ext4   rw,noatime
>>>
>>> tux>mount --version
>>> mount from util-linux 2.26.2 (libmount 2.26.0: assert, debug)

And what does /proc/mounts say?  That'll tell you what is actually set
on the superblock.  Works here, on 4.1.0-rc2:

# mount /dev/sdb1 /mnt/test
# mount -o remount,lazytime /mnt/test
# grep sdb1 /proc/mounts=20
/dev/sdb1 /mnt/test ext4 rw,lazytime,seclabel,relatime,data=3Dordered 0=
 0

# dmesg | tail -n 2
[516203.450943] EXT4-fs (sdb1): mounted filesystem with ordered data mo=
de. Opts: (null)
[516211.222020] EXT4-fs (sdb1): re-mounted. Opts: lazytime

-Eric


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
