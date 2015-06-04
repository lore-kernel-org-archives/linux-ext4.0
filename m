From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: Which newer kernel is OK with ext4?
Date: Thu, 4 Jun 2015 15:59:16 +0200
Message-ID: <mkpljk$al6$1@ger.gmane.org>
References: <mknlqf$m5d$1@ger.gmane.org> <20150604020852.GB5759@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbbFDN7i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jun 2015 09:59:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z0VgD-0002J5-Df
	for linux-ext4@vger.kernel.org; Thu, 04 Jun 2015 15:59:33 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2015 15:59:33 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Jun 2015 15:59:33 +0200
In-Reply-To: <20150604020852.GB5759@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 06/04/2015 04:08 AM:
> If you are more adventurous, you could try using one of the long-term
> supported kernel (i.e., such as 3.18).  See:
>
> 	https://www.kernel.org/category/releases.html
>
> But remember, now you have to properly configure the kernel, and you
> are responsible for checking for new releases of the a long-term
> supported kernel.  If you stick with a specific kernel version and
> don't upgrade it, then you might be prone to security bugs that would
> have been fixed by a newer kernel.

Thanks for the info,
I have many times compiled a kernel and used it successfully,
but when I dist-upgraded from Debian 7 to Debian 8 it installed
it's own stock kernel maintained by Debian. No problem to switch
to a newer kernel from kernel.org, but for me it was unclear
if and how the ongoing ext4-developments will have an impact on
existing ext4-partitions. Now I think everything is clear, I'll
take a newer kernel from kernel.org.

-- 
cu
Uenal


