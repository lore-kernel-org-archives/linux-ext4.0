From: Tao Ma <tm@tao.ma>
Subject: Re: big allocation status
Date: Sat, 04 Jun 2011 16:34:09 +0800
Message-ID: <4DE9EE01.6070406@tao.ma>
References: <4DE83F83.6070302@tao.ma> <20110604033805.GD2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37758 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753311Ab1FDIel (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jun 2011 04:34:41 -0400
In-Reply-To: <20110604033805.GD2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/04/2011 11:38 AM, Ted Ts'o wrote:
> On Fri, Jun 03, 2011 at 09:57:23AM +0800, Tao Ma wrote:
>> Hi Ted,
>>
>> Do you have any new branch or patch set that can be used for testing
>> about big allocation? The latest patch set in the mailist is what you
>> have sent at the beginning of May. Do you have an updated one? We will
>> try to test it soon and it would grateful if we are on the same page.
> 
> There is a patch set available at:
> 
> git://repo.or.cz/ext4-patch-queue.git
> 
> The bigalloc patches are after the stable-boundary, and will apply
> against 3.0-rc1.
Great thanks, we will schedule some test maybe next week.
> 
> Note that I've fixed them up so that they apply on top of the punch
> changes; however, the punch ioctl will not work correctly if bigalloc
> is enabled, since that hasn't been fixed up yet.
Fine, our test cases will not use punch ioctl AFAIK.
> 
> Also, I'm still working on the e2fsprogs support.
Cool, but do you have a mkfs.ext4 that we can let the kernel part work
happily? Or we have to add the feature by hand by editing the disk
format. ;)

Regards,
Tao
