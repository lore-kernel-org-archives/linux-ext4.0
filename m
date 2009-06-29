From: =?UTF-8?Q?Krzysztof_Kosi=C5=84ski?= <tweenk.pl@gmail.com>
Subject: Re: Massive corruption on RAID0
Date: Mon, 29 Jun 2009 17:12:50 +0200
Message-ID: <298610bb0906290812t249c7e52l80e57af36bd0e80c@mail.gmail.com>
References: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>
	 <4A48355D.5040001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39336 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZF2PMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 11:12:49 -0400
Received: by fxm18 with SMTP id 18so1029308fxm.37
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 08:12:50 -0700 (PDT)
In-Reply-To: <4A48355D.5040001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

W dniu 29 czerwca 2009 05:30 u=C5=BCytkownik Eric Sandeen
<sandeen@redhat.com> napisa=C5=82:
> Is the super.bin above from before the fiddling you did (i.e. right
> after the power loss?)
Yes, it's before I started my recovery attempts, though mount and
e2fsck -p were run on it during the boot process before I removed it
from fstab.

> The superblock is marked with errors, I wonder
> if there were other errors reported on the filesystem prior to the po=
wer
> loss; you might check your logs ...
I checked and it seems there were no errors until the power failure.
By the way, is there some way to have RAID0-like functionality with
write barriers?

Regards, Krzysztof Kosi=C5=84ski
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
