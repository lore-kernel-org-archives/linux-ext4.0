From: James Cloos <cloos@jhcloos.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Fri, 19 Feb 2010 16:44:08 -0500
Message-ID: <m3r5ognbnj.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eagle.jhcloos.com ([207.210.242.212]:35078 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0BSVow (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 16:44:52 -0500
In-Reply-To: <93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
	(Mike Fedyk's message of "Fri, 19 Feb 2010 13:22:45 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Mike" =3D=3D Mike Fedyk <mfedyk@mikefedyk.com> writes:

Mike> On Sat, Feb 13, 2010 at 7:11 PM, James Cloos <cloos@jhcloos.com> =
wrote:
>> Sometime between rc6 and rc7 all filesystem I/O started using 100% C=
PU,
>> usually on the order of 60% sys, 40% user.
>>=20
>> I've tried this with each of ext4, jfs and btrfs filesystems. =A0All=
 show
>> the same issue.
>>=20

Mike> Are you sure you're not running with any of the debugging options
Mike> enabled?  I see the same, but I have debugging enabled (rawhide
Mike> kernel).

There are some:

CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CFG80211_DEBUGFS=3Dy
CONFIG_MAC80211_DEBUGFS=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy
CONFIG_FIREWIRE_OHCI_DEBUG=3Dy
CONFIG_USB_SERIAL_DEBUG=3Dm
CONFIG_DEBUG_FS=3Dy
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_SCHED_DEBUG=3Dy
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_MEMORY_INIT=3Dy
CONFIG_DEBUG_STACKOVERFLOW=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy

I forgot about /proc/sched_debug, but am back at -rc6 right now; I'll
post an example of /proc/sched_debug output during the issue when I'm
next in rc8 or later.

-JimC
--=20
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
