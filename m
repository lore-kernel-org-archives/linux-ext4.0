From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Mon, 11 Feb 2013 09:38:20 -0600
Message-ID: <5119106C.2050608@redhat.com>
References: <B6CCAB6A-D340-47F8-9231-1280151552DC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab3BKPiV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:38:21 -0500
In-Reply-To: <B6CCAB6A-D340-47F8-9231-1280151552DC@colorremedies.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/9/13 6:17 PM, Chris Murphy wrote:
> 
> On 2013-02-07 15:50:07 GMT Eric Sandeen wrote:
> 
>> To be clear, this is only the case when installing the bootloader
>> itself to a partition containing a filesystem, not when installing
>> to the MBR, correct?
> 
> Correct.
> 
>> Which is different than saying "/boot is on ext4" - it's putting
>> the bootloader itself on a partition containing a filesystem,
>> something which is a bit more unusual, I think.
> 
> Some users apparently want distribution specific boot loaders as
> secondary, chain loaded from a primary boot loader that goes in the
> MBR gap.
> 

Understood, just didn't want this to turn into a "grub2 doesn't work
on ext4?!" meme.  :)

Thanks,
-Eric
