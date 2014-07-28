From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: resilience against power loss
Date: Mon, 28 Jul 2014 10:48:05 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407281044200.2077@localhost.localdomain>
References: <53CE9282.11182.166B0034@vicentiu.neagoe.ni.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: vicentiu.neagoe@ni.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaG1IsM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 04:48:12 -0400
In-Reply-To: <53CE9282.11182.166B0034@vicentiu.neagoe.ni.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Jul 2014, vicentiu.neagoe@ni.com wrote:

> Date: Tue, 22 Jul 2014 19:34:10 +0300
> From: vicentiu.neagoe@ni.com
> To: linux-ext4@vger.kernel.org
> Subject: resilience against power loss
> 
> Hello,
> 
> I'm trying to configure ext4 to prevent data corruption in case of a 
> power loss.
> 
> I test by doing a cold reset right after writing to a file.
> I tried the nodelalloc option, but the file still becomes corrupted 
> with trailing garbage.
> 
> Using ext3, I either get the old version of the file, or the new 
> version, and there is no corruption.
> 
> Does nodelalloc not guarantee data integrity?
> 
> Are there any other options that provide complete resilience against 
> power loss?

Well, that would be fsync. It'll make sure that your data actually reach
disk and that the disk actually write it from the cache to platters.

-Lukas

> 
> thanks
> 
> Vicentiu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
