From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: newsletter: Re: ext4 crashes on nfs server
Date: Thu, 19 Jan 2012 11:18:36 -0600
Message-ID: <4F18506C.9050601@redhat.com>
References: <OF2380C53F.32FE8350-ONC125798A.00494E7A@aschendorff.de> <4F1835F3.9060604@redhat.com> <OFBE4B8BA4.837045FD-ONC125798A.005E13C5@aschendorff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: muellejo@aschendorff.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2ASRSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jan 2012 12:18:40 -0500
In-Reply-To: <OFBE4B8BA4.837045FD-ONC125798A.005E13C5@aschendorff.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/19/12 11:07 AM, muellejo@aschendorff.de wrote:
> Thanks Eric,
> 
>> Looks like an oops/panic/BUG - but are you sure you didn't start copying a line or two too late?
> 
> Well, there are other interesting information in /var/log/messages about 10 minutes
> I uploaded them here http://vam-emp.aschendorff.de/tmp/

That all looks like a mess.  I think you need to go through your logs and find
the first sign of trouble, and start there.

I don't know what is dumping out all that hex...

-Eric

> We also suffered from a huge amount from these log entries
> they are somehow related to disabling ipv6 and vsftp but I
> guess this is not really related to our ext4 crashes.
> After now upgrading vsftp they disappeared, debian has got a bug for that
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=590653
> 
> Jan 18 20:52:26 ez-nfs-prod-vm1 kernel: [14913.361952] lo: Disabled Privacy Extensions
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

