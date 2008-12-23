From: Diego Calleja <diegocg@gmail.com>
Subject: Re: Ext4 documentation
Date: Tue, 23 Dec 2008 10:00:07 +0100
Message-ID: <20081223100007.6b79cd27@diego-desktop>
References: <20081222235841.7aaaef93@diego-desktop>
	<20081222234456.GW5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43286 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYLWI61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 03:58:27 -0500
Received: by bwz14 with SMTP id 14so9438621bwz.13
        for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 00:58:25 -0800 (PST)
In-Reply-To: <20081222234456.GW5000@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

El Mon, 22 Dec 2008 16:44:56 -0700, Andreas Dilger <adilger@sun.com> es=
cribi=C3=B3:

> Looks pretty good, thanks for writing this up.  Minor notes:
> - While > 16TB is supported by ext4 disk formats, the mke2fs/e2fsck c=
ode
>   to support this is not in any released e2fsprogs yet
> - I don't think the journal async commit blocks are enabled by defaul=
t, so
>   the "20% speedup" is not available yet.  There is some work that
>   needs to be done to make this feature 100% safe in case of corrupti=
on.
> - I'm not sure if enabling flex_bg on an existing ext3 filesystem is =
useful
> - you don't mention anything about the required e2fsprogs version.  I
>   _think_ (someone should confirm) that e2fsprogs-1.41.3 is the minim=
um
>   version that anyone should use.

Thanks, I've mentioned all this.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
