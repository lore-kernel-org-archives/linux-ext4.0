From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Unregister features interface on module unload
Date: Tue, 18 Jan 2011 14:10:12 -0600
Message-ID: <4D35F3A4.1070402@redhat.com>
References: <1295276437-27966-1-git-send-email-lczerner@redhat.com> <4D3485BF.4030100@redhat.com> <4D35ECD1.3070502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1ARUKO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jan 2011 15:10:14 -0500
In-Reply-To: <4D35ECD1.3070502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/18/2011 01:41 PM, Eric Sandeen wrote:
> 
> 
> On 01/17/2011 12:09 PM, Eric Sandeen wrote:
> 
>> On 01/17/2011 09:00 AM, Lukas Czerner wrote:
>>> Ext4 features interface was not properly unregistered which led to
>>> problems while unloading/reloading ext4 module. This commit fixes that by
>>> adding proper kobject unregistration code into ext4_exit_fs() as well as
>>> fail-path of ext4_init_fs()
>>>
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>> Reported-by: Eric Sandeen <sandeen@redhat.com>
>> Works for me!
>>
> I may have spoken too soon.  After a few insmod/mount/io/umount/rmmod loops I got:
> 
> [   95.625277] general protection fault: 0000 [#1] SMP 
> 

Sorry, I think this is Yet Another Problem and your patch is fine;
reverting the whole features advert commit and doing the same test
yields the same failure.

-Eric
