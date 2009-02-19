From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Thu, 19 Feb 2009 09:46:51 -0600
Message-ID: <499D7EEB.2070908@redhat.com>
References: <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de> <20090218212957.GR3600@mini-me.lan> <499CC185.6050904@anarazel.de> <20090219032244.GW3600@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
	Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.or
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56754 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZBSPsy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2009 10:48:54 -0500
In-Reply-To: <20090219032244.GW3600@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Feb 19, 2009 at 03:18:45AM +0100, Andres Freund wrote:
>> On 02/18/2009 10:29 PM, Theodore Tso wrote:
>>> Ok, that's good.  Good to know the workaround works.
>>> Can you send me a dumpe2fs of the filesystem in question?  I'm curious
>>> what was going on...
>> Will do as soon as I am at the same place as the machine. I guess thats  
>> only interesting to you privately (size and so on)?
>>
>>> Thanks for the report.  I'll push the workaround patch to Linus for
>>> 2.6.29 to avoid this problem for now.  I recently sent to linux-ext4
>>> for comment a patch to revamp the Orlov allocator for flex_bg and to
>>> use that instead of find_group_flex(), but no way that's going into
>>> 2.6.29 at this point....
>> Would it be helpfull if I test that patch?
>>
> 
> Sure, I'll take all of the testing I can get.  :-)
> 
> The patch is in the ext4 patch queue, and I sent them to the ext4
> patch queue.  The patch is also in patch work:
> 
> http://patchwork.ozlabs.org/patch/23343/
> 
> The patch which I sent you earlier (available below) is a prequisite:
> 
> http://patchwork.ozlabs.org/patch/23228/

Ted, I hope the printk will be removed or at least ratelimited before it
gets upstream?

Thanks,
-Eric
