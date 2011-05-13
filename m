From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Slow filesystem.
Date: Fri, 13 May 2011 09:27:17 -0500
Message-ID: <4DCD3FC5.3000006@redhat.com>
References: <20110513125958.GA22871@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab1EMO1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 10:27:22 -0400
In-Reply-To: <20110513125958.GA22871@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/13/11 7:59 AM, Rogier Wolff wrote:
> 
> Hi
> 
> My work (as in what brings in money to buy things from) file-system is
> now "slow as hell". Last time this happened you guys told me that this
> was because I had millions of hardlinks and way too many files.
> 
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/md0                815M    4.1M    811M    1% /recover2
> 
> I have only 4.1M files. Only 1% inodes "in use". 
> 
> 
> The filesystem was filling up lately, but i've managed to create some
> free space.
> 
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0              6.3T  5.3T  720G  89% /recover2
> 
>  The question is: How do I get the filesystem to perform
> normally again?
> 
> 
> All mkdir calls are taking around 62 milliseconds: 
> 
> 14:57:02 mkdir("...ME_25c8e/", 0777) = 0 <0.062312>
> 14:57:02 mkdir("...ME_112ff/", 0777) = 0 <0.062658>
> 14:57:02 mkdir("...ME_183cf/", 0777) = 0 <0.062344>

I don't know what the workload is, and "slow" isn't very well characterized here, but from this can I assume that mkdir is the bottleneck?

Did you ever try that patch I sent you for this issue in March?

Using oprofile to see where the fs is spending its time might also be useful.

-Eric

> while on my workstation where i'm not supposed to be working
> with client-data I get: 
> 
> 14:58:18 mkdir("...ME_2a6c6/", 0777) = 0 <0.000033>
> 14:58:18 mkdir("...ME_2b3d9/", 0777) = 0 <0.000031>
> 14:58:18 mkdir("...ME_2c63f/", 0777) = 0 <0.000034>
> 
> So, things on my big datastorage drive are about 2000 times slower
> than on my workstation.
> 
> 	Roger. 
> 

