From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Weird jbd2 I/O load
Date: Mon, 21 Oct 2013 17:24:45 +0300
Message-ID: <5265392D.1020500@redhost.ro>
References: <525DB679.4070008@redhost.ro> <20131021135338.GA3392@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gts6.roserve.net ([128.140.230.209]:59900 "EHLO
	gts6.roserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3JUOZC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 10:25:02 -0400
Received: from 5-13-211-235.residential.rdsnet.ro ([5.13.211.235]:65389 helo=[127.0.0.1])
	by gts6.roserve.net with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <andrei.banu@redhost.ro>)
	id 1VYGPg-00075l-21
	for linux-ext4@vger.kernel.org; Mon, 21 Oct 2013 17:24:56 +0300
In-Reply-To: <20131021135338.GA3392@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

Thank you for your reply. We can make this test and if it doesn't help 
we'll re-enable
the barrier but first I need to ask a few questions:

1. /dev/md2 is mounted on /. So your command should look like this?

$ mount -t ext4 -o remount,barrier=0    /dev/md2    /

In /etc/fstab I have other parameters as well: 
noatime,usrjquota=quota.user,jqfmt=vfsv0
Do I also add these like this:

$ mount -t ext4 -o 
remount,barrier=0,noatime,usrjquota=quota.user,jqfmt=vfsv0 /dev/md2     /

2. Can the command above be run on an active (very active) cPanel server?

3. How do I re-enable the barrier?

4. What is the probability of data loss in case of cold reboot?

Thanks!

On 10/21/2013 4:53 PM, Zheng Liu wrote:
> Hi Andrei,
>
> Could you please disable barrier for ext4 and try your 'dd' test again?
>    $ sudo mount -t ext4 -o remount,barrier=0 ${DEV} ${MNT}
>
> *WARNING: you could lost your data with barrier=0 when you get a power
> failure or cold reset.*
>
> We have met a similar problem that is because some SSDs couldn't handle
> barrier command properly.
>
> Regards,
>                                                  - Zheng

