From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH] ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg
Date: Thu, 7 Jun 2012 16:39:55 +0200
Message-ID: <1735237152.20120607163955@eikelenboom.it>
References: <1339077153-13212-1-git-send-email-tytso@mit.edu> <1511035441.20120607160116@eikelenboom.it> <20120607141051.GB2864@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:35232
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760966Ab2FGOkA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2012 10:40:00 -0400
In-Reply-To: <20120607141051.GB2864@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thursday, June 7, 2012, 4:10:51 PM, you wrote:

> On Thu, Jun 07, 2012 at 04:01:16PM +0200, Sander Eikelenboom wrote:
>> 
>> BTW: Is there any (real) advantage to recreate the FS using the ext4's flex_bg instead of converting the ext3 to ext4 and using ext3 uninit_bg ?
>> 

> It speeds up e2fsck times, and it allows for more contiguous free
> space in the file system.  So yes, there is an advantage to using a
> native ext4 file system --- but of course that's a pain in the tuckus
> for people with large RAID arrays.  Which also explains why we were
> mainly seeing this bug reported with people using large RAID devices;
> those are the people who are most likely to want to do an
> upgrade-in-place, because it's too painful to recreate and then copy
> the data.  Which is fine; one of the major features of ext4 is to be
> able to support upgrades-in-place from ext3.

Ok thx for the info and the fix !

--
Sander

> Unfortunately, while I had native (unconverted) ext3 file systems in
> my test matrix, I didn't have converted ext3 file system formats in my
> regular regression test suite script.  That is going to be fixed
> shortly....

>                                             - Ted




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

