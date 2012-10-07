From: Tao Ma <tm@tao.ma>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: Sun, 07 Oct 2012 21:39:04 +0800
Message-ID: <507185F8.3040700@tao.ma>
References: <20121007050427.6711.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:33055 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752849Ab2JGNjM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 09:39:12 -0400
In-Reply-To: <20121007050427.6711.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi George,
On 10/07/2012 01:04 PM, George Spelvin wrote:
> Feeling a bit adventurous, I enabled metadata_csum on many of
> my daily-use file systems.
> 
> I have now noticed a problem in the event of an unclean shutdown.
> 
> On reboot, the kernel complains about a bad superblock checksum, suggests
> e2fsck, and then fails to mount the root filesystem.
> 
> This makes running e2fsck a bit problematic.
> 
> I can fix it manually, but it makes automatic reboots *extremely*
> problematic.
> 
> Is it possible to fix the kernel code to be a bit more forgiving?
Interesting. In general, metadata checksum should be updated with the
same content it checksums. So could you please answer my questions first?
1. your kernel version please?
2. what do you mean a *unclean* shutdown?
3. what do you find in your /var/log/messages except the bad superblock
checksum error?

Thanks
Tao
