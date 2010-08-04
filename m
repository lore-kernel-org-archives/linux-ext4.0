From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Crash after umount'ing a disconnected disk (Re: extfs reliability)
Date: Wed, 04 Aug 2010 22:24:43 +0400
Message-ID: <4C59B06B.6090505@vlnb.net>
References: <20100804180325.GL9453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab0HDSYo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Aug 2010 14:24:44 -0400
In-Reply-To: <20100804180325.GL9453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o, on 08/04/2010 10:03 PM wrote:
> Ping?
>
> Have you had a chance to check out whether this patch solves the
> problem you were complaining with respect to yanking out the last
> iSCSI or FC link to a hard drive, and then umounting the disk
> afterwards?
>
> If you could try it out, I would really appreciate it.

Sorry, I have troubles to compile that kernel. With my regular config 
which I used for ages with Fedora Ubuntu early user space crashes. But 
I'll try to overcome it tomorrow.

Thanks,
Vlad
