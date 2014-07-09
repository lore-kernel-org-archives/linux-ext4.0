From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Question about data integrity on SD cards
Date: Wed, 9 Jul 2014 14:51:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407091444140.2128@localhost.localdomain>
References: <53BD32D5.3000804@kelvatek.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Grzegorz Sikorski <g.sikorski@kelvatek.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaGIMvL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jul 2014 08:51:11 -0400
In-Reply-To: <53BD32D5.3000804@kelvatek.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 9 Jul 2014, Grzegorz Sikorski wrote:

> Date: Wed, 09 Jul 2014 13:17:25 +0100
> From: Grzegorz Sikorski <g.sikorski@kelvatek.com>
> To: linux-ext4@vger.kernel.org
> Subject: Question about data integrity on SD cards
> 
> Hi,
> 
> In our project we use SQLite3 database on EXT4 filesystem partition on microSD
> card. On unexpected power failure/system crash or just hardware reset, we
> observe occasional database corruption. SQLite3 developers claim their part is
> free of risk of database corruption, as long as fsync call is doing it's job
> properly. We tried several SD cards, including industrial grade which should
> have proper firmware (at least their manufacturers say there is no risk of
> data corruption on power loss). We tried several different mount settings and
> after some reading we found, that the safest (and slowest) option (that should
> never fail, as far as we understand) would be like:
> rw,relatime,barrier=1,journal_checksum,nodelalloc,data=journal,usrquota
> In spite of all that, we still observe random database corruption on
> power-down/reset. Can you confirm there is no problem in EXT4 filesystem?

There have been reports on SD cards not working correctly on power
failure, most likely due to flush not working correctly. It was
mentioned several times in this huge thread (concerning different
problem, but maybe related)
http://www.spinics.net/lists/linux-ext4/msg43974.html

At this point we do not know about any problems with ext4 file
system regarding fsync functionality. However you have not said
which kernel you are using.

Also, have you tried reproducing it on a different hardware, let's
say SSD, or spinning disk ? Do you have any SD card which seems to
be working reliably across power failures, or did you see that
behaviour with all SD cards you've tested ?

Thanks!
-Lukas

> 
> Best regards,
> Greg
> 
> --
> ExchangeDefender Message Security: Click below to verify authenticity
> https://admin.exchangedefender.com/verify.php?id=s69CHHv3024052&from=g.sikorski@camlintechnologies.com
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
