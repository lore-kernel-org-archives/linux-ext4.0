From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Is >16TB support considered stable?
Date: Fri, 28 May 2010 15:39:24 -0400
Message-ID: <4C001BEC.9080906@redhat.com>
References: <4BFFF4D2.6020908@van-ness.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Sandon Van Ness <sandon@van-ness.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0E1Tj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 15:39:27 -0400
In-Reply-To: <4BFFF4D2.6020908@van-ness.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 12:52 PM, Sandon Van Ness wrote:
> I have a 36 TB (33.5276 TiB) device. I was originally planning to run
> JFS like I am doing on my 18 TB (16.6697 TiB) partition but the
> userspace tools for file-system creation (mkfs) on JFS do not correctly
> create file-systems over 32 TiB. XFS is not an option for me (I have had
> bad experiences and its too corruptible) and btrfs is too beta for me.
> My only options thus are ext4 or JFS (limited to 32 TiB).
>
> I would rather not waste ~ 1TiB of space which will likely go to other
> partitions that would normally only be 500 GiB but will now be 1.5 TiB
> if I can and with some of my testing of ext4 I think it could be a
> viable solution. I heard that with the pu branch 64-bit addressing
> exists so you can successfully create/fsck>16 TiB file-systems. I did
> read on the mailing lists that there were some problems on 32-bit
> machine but i will only use this file-sytem on x86_64.
>
> So here is my question to you guys:
>
> Is the pu branch pretty stable? Is it stable enough to have a 33 TiB
> file-system in the real-world and be as stable and work as well as a<16
> TiB file-system or am I better off losing out some of my space and
> making a 32 TiB (minus a little) JFS partition and just stick to what I
> know works and works well?
>    

Not sure which version of XFS you had trouble with, but it is certainly 
the most stable file system for anything over 16TB....

Regards,

Ric

