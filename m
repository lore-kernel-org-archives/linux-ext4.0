From: Zeev Tarantov <zeev.tarantov@gmail.com>
Subject: Re: problem(?) in ext4 or mke2fs
Date: Sun, 3 Apr 2011 22:01:54 +0300
Message-ID: <BANLkTimRJ95zd64CPckPu9RpRwHioJdVCA@mail.gmail.com>
References: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com>
 <4D98BF34.6040503@redhat.com> <BANLkTikZYqbjkTrZPAPFkhMcRnmJtuAzzw@mail.gmail.com>
 <4D98C2E0.3010808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54725 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1DCTCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 15:02:14 -0400
Received: by pzk9 with SMTP id 9so1112085pzk.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 12:02:14 -0700 (PDT)
In-Reply-To: <4D98C2E0.3010808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 3, 2011 at 21:56, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/3/11 11:52 AM, Zeev Tarantov wrote:
>> If the filesystem created with the default options is slow or has
>> higher cpu usage, it should be changed.
>
> I agree. =A0For actual striped storage, this makes it faster, but thi=
s
> case is a problem; block-sized stripe width is never going to be good=
=2E
> What device is this, exactly?

Look in linux-2.6/drivers/staging/zram/zram.txt

> -Eric (losing my free airport wifi in about 8 minutes, so I may have
> to continue this later...!)
>
>>> -Eric
>>
>> -Z.T.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
