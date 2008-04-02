From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Date: Wed, 2 Apr 2008 21:16:59 +0900
Message-ID: <3AF481B79787436E8E20D6C597D5DD1C@nsl.ad.nec.co.jp>
References: <20080328180736t-sato@mail.jp.nec.com> <20080331000057.GI108924158@sgi.com> <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp> <20080402062147.GH103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <dm-devel@redhat.com>,
	<xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "David Chinner" <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39472 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYDBMRY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 08:17:24 -0400
In-Reply-To: <20080402062147.GH103491721@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

David Chinner wrote:
>> Exactly my timeout feature is only for an application, not for
>> freeze_bdev().
>> I think it is needed for the situation we can't unfreeze from userspace.
>> (e.g. Freezing the root filesystem)
>
> Ummm - why can't you unfreeze the root fs from userspace? freezing
> only prevents modification to the filesystem. A frozen filesystem is
> effectively a read-only filesystem...
>
> On XFS:
>
> # xfs_freeze -f /
> # echo $?
> 0
> # xfs_freeze -u /
> # echo $?
> 0

Yes. If we have already logged in, we can unfreeze as above.
But if not, we cannot log in and unfreeze because the modification
of /var/log/wtmp is blocked in the log-in procedure.
The timeout feature will work in such case.

Cheers, Takashi
