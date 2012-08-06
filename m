From: Gordan Bobic <gordan@bobich.net>
Subject: Re: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Mon, 06 Aug 2012 23:21:19 +0100
Message-ID: <5020435F.5000304@bobich.net>
References: <bug-45621-13602@https.bugzilla.kernel.org/> <20120806221442.D539011FA3A@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 78-86-195-58.zone2.bethere.co.uk ([78.86.195.58]:57563 "EHLO
	external.sentinel2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755950Ab2HFWVW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Aug 2012 18:21:22 -0400
Received: from ariia.shatteredsilicon.net (unknown [10.2.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by external.sentinel2 (Postfix) with ESMTPSA id C8BA726D5
	for <linux-ext4@vger.kernel.org>; Mon,  6 Aug 2012 23:21:19 +0100 (BST)
In-Reply-To: <20120806221442.D539011FA3A@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/06/2012 11:14 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D45621
>
>
>
>
>
> --- Comment #6 from markus.doits@googlemail.com  2012-08-06 22:14:42 =
---
> Just ran memtest for 3+ hours, 3 passes finished successfully. I know=
, longer
> is better, but cannot run it longer atm (since it's a server with cru=
cial
> infrastructure). System is not overclocked or so, everything default.

memtest86 is completely useless at finding marginal memory. It'll only=20
typically find a problem if there is a properly, permanently dead or=20
stuck bit in the RAM.

If Windows is an option temporarily for testing use OCCT. If it isn't,=20
I've found something like this to work pretty well for finding CPU and=20
memory stability issues:

#####
# Assuming your /dev/shm is mounted on tmpfs - make sure it's big
# enough. Adjust count=3D accordingly
dd if=3D/dev/urandom bs=3D1M count=3D1024 of=3D/dev/shm/test

# Run one instance of this per CPU thread

#!/bin/bash

sum=3D`sha512sum /tmp/test`

while (/bin/true); do
   echo -n .
   sum2=3D`sha512sum /tmp/test`
   if [ "$sum" !=3D "$sum2" ]; then
     echo =E2=80=9C=E2=80=9D
     echo =E2=80=9CError detected. $sum !=3D $sum2=E2=80=B3
     exit
   fi
done
#####

That should be a lot better at finding CPU/cache/MCH/RAM issues.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
