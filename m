From: Tao Ma <tm@tao.ma>
Subject: Re: kernel thread "flush-254:12" eats 100% CPU
Date: Thu, 08 Sep 2011 13:15:56 +0800
Message-ID: <4E684F8C.3050308@tao.ma>
References: <j483kt$en1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Marcin M <gmane@mejor.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:56403 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752527Ab1IHFQx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Sep 2011 01:16:53 -0400
In-Reply-To: <j483kt$en1$1@dough.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/07/2011 11:46 PM, Marcin M wrote:
> Hello!
> I hope i'm writing to correct place (but i suspect g.l.kernel list could
> be proper also) :)
> I'm observing situation like in subject. From time to time
> "flush-254:12" takes 100% of cpu for a couple of minutes. Then
> everything becomes ok.
> This problem appears on my two different boxes.
> 
> box A)
> bare metal, i686, hardened-kernel-2.6.{37-38}
> on this box kernel thread never stops to do 100% of cpu. I've to reboot
> box (using sysrq, because i could't even umount partition associated
> with this thread)
> My workarround for it: i changed ext4 to xfs on dm device and problem
> disappeared
So do you have the backstrace for it? Just wonder what it is doing.
echo t > /proc/sysrq-trigger should tell us what the flusher is doing at
that time.

Thanks
Tao
> 
> box B)
> xen, full virtualization, x86_64, kernels:
> hardened-kernel-{2.6.39,3.0.3,3.0.4} and 3.1.0-rc4-git2
> problem is as i described above, flush took one cpu for a couple minutes
> and then everythings works correctly.
> 
> And again, 254-12 device is ext4 filesystem.
> In both cases it was used lvm. At box B, additionaly i'm using dmcrypt.
> Box B is configured in this way: sda->lvm2->dmcrypt->filesystem.
> 
> How can i help to debug this problem? Or maybe it's fixed already?
> 
> Regards,
> Marcin.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

