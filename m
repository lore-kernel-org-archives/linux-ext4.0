From: Wang Shaoyan <stufever@gmail.com>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error threshold
Date: Mon, 20 Jun 2011 22:12:48 +0800
Message-ID: <BANLkTikLrLPLgj3ykmqcZ_+KVQi85vrWAPSJHGX_hOV3nNL0sg@mail.gmail.com>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
	<20110620133626.GC4810@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62469 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1FTOMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 10:12:49 -0400
Received: by pvg12 with SMTP id 12so745661pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 07:12:49 -0700 (PDT)
In-Reply-To: <20110620133626.GC4810@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for your reply!
2011/6/20 Jan Kara <jack@suse.cz>:

> =A0Hum, if I understand your problem right, you should just mount the
> filesystem with errors=3Dremount-ro and you will get the behavior you=
 need.
> Or what is insufficient on that solution? Your patch surely provides =
more
> flexibility but is that really needed?
>

1.There are more than ten hard disks in each of our production
machine, so it is not right for
making the whole system panic, only based on one error in one harddisk.
2.There may be multiple tasks which access the same hard drive at the
same time, so it is
not ideal for changing the system to readonly, only based on one error
in one task,
while other task may be killed.

That's why we have a relaxed restrictions, only when the error counter
is grower than our
threshold, we change fs to readonly or panic.
When a system has a dozen hard drives, each hard drive is running
several tasks on time,
this feature is a real demand.

> BTW, in cluster environment (which Hadoop seems to be AFAIU) it is st=
andard
> to mount filesystem even with stricter errors=3Dpanic so that node is=
 taken
> off the grid as soon as some problem happens. Usually handling servic=
e
> failover is simpler than handling uncertain state after a filesystem =
error.
>



--=20
Wang Shaoyan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
