From: "Vitaliy Filippov" <vitalif@yourcmc.ru>
Subject: Re: A tool that allows changing inode table sizes
Date: Fri, 28 Feb 2014 01:12:04 +0400
Message-ID: <op.xbyk6eur0ncgu9@vitalif.vhome>
References: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
 <530F6950.2020702@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org, "Phillip Susi" <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:51200 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaB0VMH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Feb 2014 16:12:07 -0500
In-Reply-To: <530F6950.2020702@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Wow!  That is quite a project, and this patch manager sounds very
> nice.  Good work!

Thanks :)

Since that initial post I've also implemented a simple 'patchbd' kernel  
module - http://svn.yourcmc.ru/viewvc.py/vitalif/trunk/sftl/patchbd.c  
(don't look at sftl*, it's some old academic try to implement a software  
FTL); it now has different format of patch files, so patch_io_manager is  
also rewritten... It's still quite a hack of course: block maps for  
example are logically stored twice - once explicitly and once in the  
underlying FS extent tree... But it's working, opposed to an LVM snapshot  
than made my system hang when being actively written; it's fast since  
there are no additional kernel threads or work queues (except loop thread  
of course), it just proxies bio's to other devices... and you can finally  
mount and test a 'patched' block device... :)

Also I've done testing on a real harddrive (that 3TB one) and actually  
fixed one bug after that testing :) also I've left the patch block device  
mounted for a ~week, ... and the patch file had grown up to 20GB. Then  
I've applied it with e2patch. Everything went OK. :)

What I'll do next is trying to actually port it into resize2fs...

-- 
With best regards,
   Vitaliy Filippov
