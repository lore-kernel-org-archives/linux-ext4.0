From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
Date: Thu, 9 Jun 2011 10:05:42 +0800
Message-ID: <BANLkTi=4=YkZezxkFh80JAwjH16Fu8PFXA@mail.gmail.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<4DEFC43B.1080802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Mike Snitzer <snitzer@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43691 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1FICFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 22:05:43 -0400
In-Reply-To: <4DEFC43B.1080802@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 9, 2011 at 2:49 AM, Sunil Mushran <sunil.mushran@oracle.com=
> wrote:
> On 06/08/2011 11:26 AM, Amir G. wrote:
>>
>> 2. Data blocks are never copied
>> The move-on-write technique is used to re-allocate data blocks on re=
write
>> instead of copying them.
>> This is not something that can be done when the snapshot is stored o=
n
>> external storage, but it can done when the snapshot file lives in th=
e fs.
>
> But does that not lead to fragmentation. And if I am understanding th=
is,
> the fragmentation will not resolve after dropping the snapshot. So wh=
ile
> you do save the overhead on write, you make the user pay on all futur=
e
> reads (that need to hit the disk).
Hi Sunil,

I am undertaking a project which aims to reduce fragmentation when the
file is rewritten.  When the snapshot is deleted, fragmentation
introduced by snapshot will be removed once the file is rewritten.  If
it is necessary, I think defragmentation can be done when the file is
read.

But it is not ready yet.  So it is not a part of the code which are
going to be merged.

Does I answer your question?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
