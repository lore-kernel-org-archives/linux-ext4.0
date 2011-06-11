From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Sat, 11 Jun 2011 04:09:27 +0300
Message-ID: <BANLkTik2qGZaKFZwKsHidde+uhS1j+kFuw@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
	<BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
	<BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
	<alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
	<alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
	<52699.1307746288@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38234 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab1FKBJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 21:09:29 -0400
In-Reply-To: <52699.1307746288@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 11, 2011 at 1:51 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 09 Jun 2011 13:54:13 +0300, "Amir G." said:
>
>> Why do you keep saying 'backup only'?
>> There is a huge difference between having long lived snapshots,
>> like CTERA products have, and temporary snapshot for backup
>> purpose (for which LVM is adequate).
>
> I must have blinked somewhere - I'm not convinced LVM is even "adequa=
te" for
> backup purposes. =A0In particular, how does an LVM-level snapshot dea=
l with the
> "metadata in memory" problem (basically the exact same problem as run=
ning fsck
> on a disk partition that is already mounted)?
>
>

It uses the filesystem freeze API.
Same as ext4 snapshots.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
