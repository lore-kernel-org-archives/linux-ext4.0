From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 09:47:03 +0100
Message-ID: <4F684407.1040807@suse.cz>
References: <20120320025835.GE14363@thunk.org> <1332212574.7847.49.camel@joe2Laptop> <216818.1332222366@turing-police.cc.vt.edu> <20120320.031001.1532841232287663716.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Valdis.Kletnieks@vt.edu, joe@perches.com, tytso@mit.edu,
	anca.emanuel@gmail.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42890 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2CTIrH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 04:47:07 -0400
In-Reply-To: <20120320.031001.1532841232287663716.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/20/2012 08:10 AM, David Miller wrote:
> From: Valdis.Kletnieks@vt.edu
> Date: Tue, 20 Mar 2012 01:46:06 -0400
> 
>> OK. Say I'm a scraper.  How do I distinguish between:
>>
>> pr_info("foo");
>> printk(KERN_INFO "foo");
>>
>> Oh my. seems that both result in exactly the same thing ending up in the
>> dmesg buffer
> 
> No it doesn't result in the same output, read the definitions again.
> 
> pr_info can be influenced by pr_fmt, plain printk cannot

Ok, but how exactly does one select per-subsystem messages relying only
on pr_fmt?

Joe writes: "notify a particular set of per subsystem messages that
pr_<level> could easily provide"

Maybe the concept is not explained well enough that we do not follow?

thanks,
-- 
js
suse labs
