From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Thu, 15 Nov 2012 17:38:23 -0600
Message-ID: <50A57CEF.30404@redhat.com>
References: <20120903220213.GE19158@chaosreigns.com> <50A56635.20408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Tim Landscheidt <tim@tim-landscheidt.de>
To: darxus@chaosreigns.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2KOXia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 18:38:30 -0500
In-Reply-To: <50A56635.20408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/15/12 4:01 PM, Eric Sandeen wrote:
> On 9/3/12 5:02 PM, darxus@chaosreigns.com wrote:
>> [732715.730069] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0: ix (10742) != EXT_FIRST_INDEX (0)
>> [  496.347230] EXT4-fs error (device sda1): ext4_ext_search_left:1275: inode #21374007: comm flush-8:0:ix (10742) != EXT_FIRST_INDEX (0)
>>
>> Same search_left... argument?  Same inode?
>>
>> $ sudo find . -inum 21374007 -print
>> ./home/darxus/.cache/chromium/Default/Cache/data_3
> 
> If you are still running into this, could you also do:
> 
> debugfs -R "dump_extents <21374007>" /dev/sda1
> 
> and send me and/or the list the result of that?

Oh, and a question for both of you guys - have you used e4defrag on this filesystem (or this file?)

-Eric
