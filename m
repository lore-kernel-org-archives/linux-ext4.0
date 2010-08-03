From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: persistent preallocation
Date: Tue, 03 Aug 2010 15:18:28 +0400
Message-ID: <87aap4aqrf.fsf@dmon-lap.sw.ru>
References: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Bo =?utf-8?Q?Brant=C3=A9n?= <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39622 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab0HCLSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 07:18:33 -0400
Received: by eya25 with SMTP id 25so1561470eya.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Aug 2010 04:18:32 -0700 (PDT)
In-Reply-To: <Pine.A41.4.64.1008031256060.1073402@stalin.acc.umu.se> ("Bo
	=?utf-8?Q?Brant=C3=A9n=22's?= message of "Tue, 3 Aug 2010 12:58:21 +0200
 (CEST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bo Brant=C3=A9n <bosse@acc.umu.se> writes:

> Hello,
>
> I have a question on the implementation of persistent preallocation,
> the reason to not return the disk block is because it can contain old
> data but I wonder if an implementation has to return zeros instead or
Please look at fallocate(2) syscall.
> if it could return any garbage as long as it is not _that_ garbage?
Off course it is not a garbage, it is old user's data which may be
very very useful (old passwords, cookies, and etc)for person who has
time to analyze it :)
>
> Bo Branten
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
