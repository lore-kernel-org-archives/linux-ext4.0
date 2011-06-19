From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Can someone confirm ext4 BUG_ON on latest kernel build?
Date: Sun, 19 Jun 2011 08:07:04 -0700
Message-ID: <20110619080704.33753b99.rdunlap@xenotime.net>
References: <4DFDCBE0.5020806@halfdog.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: halfdog <me@halfdog.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:40488 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754171Ab1FSPHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jun 2011 11:07:07 -0400
In-Reply-To: <4DFDCBE0.5020806@halfdog.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[adding ext4 mailing list]


On Sun, 19 Jun 2011 10:13:52 +0000 halfdog wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Sorry, I do not have latest kernel. Can someone confirm this on latest?
> At least bugtracker does not know about it, and to my understanding of
> source, should be still here.
> 
> 
> dd if=/dev/zero bs=1M count=64 of=test
> mkfs.ext4 -F test
> echo -n " " | dd of=test bs=1 count=1 seek=297195 conv=notrunc
> mount -o loop test /mnt/test
> dmesg -c
> 
> On ubuntu natty with latest kernel, it seems, that
> fs/ext4/super.c:__save_error_info calls mod_timer before timer->function
> is set at end of fs/ext4/super.c:ext4_fill_super via
>   sbi->s_err_report.function = print_daily_error_info;
> 
> This causes BUG_ON(!timer->function) in kernel/timer.c:__mod_timer
> Device is stuck, not usable any more.
> 
> Thanks
> 
> - -- 
> http://www.halfdog.net/
> PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
> 
> iD8DBQFN/cvFxFmThv7tq+4RAgfvAJ97N9bnKq4kN99XneTMyJZ5Hha9MQCfcguN
> L4trkTeOsIqDWF8m6VUqcgc=
> =zvYY
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
