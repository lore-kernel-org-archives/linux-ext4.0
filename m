From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: discard + LVM
Date: Sat, 06 Mar 2010 23:38:30 -0600
Message-ID: <4B933BD6.80100@redhat.com>
References: <4B922929.5020006@zappa.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Sundstrom <sunkan@zappa.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0CGFif (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Mar 2010 00:38:35 -0500
In-Reply-To: <4B922929.5020006@zappa.cx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Sundstrom wrote:
> Hi..
> 
> I have an OCZ agility SSD drive with FW 1.5 that supports the TRIM command.
> 
> I can see that it works on a plain partition.
> But it does not seem to work together with LVM.
> 
> So I'm wondering if this is expected and whether it is something that
> will be worked on to get fixed?

It is expected, as lvm is not yet passing discard requests.

I'd ask next on the LVM lists ;)

-Eric

> Otherwise I guess that I will consider reverting back to plain
> partitions on my SSD drive.
> 
> Thanks for any help
> 
> /Andreas Sundstrom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

