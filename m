From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] code cleanup on include/linux/fs.h
Date: Thu, 17 Feb 2011 11:25:17 -0600
Message-ID: <4D5D59FD.3050200@redhat.com>
References: <AANLkTinpYGiq_mn7iO4xKW01nLXWrW89bRMXjME=5pSS@mail.gmail.com> <20110217161445.GI26780@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steven Liu <lingjiujianke@gmail.com>, linux-ext4@vger.kernel.org,
	liuqi <liuqi@thunderst.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1BQRZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 12:25:25 -0500
In-Reply-To: <20110217161445.GI26780@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/17/11 10:14 AM, Ted Ts'o wrote:
> On Thu, Feb 17, 2011 at 05:38:43PM +0800, Steven Liu wrote:
>> Hi Ted,
>>
>>
>>       Can this patch be fixed.
>>
>>        Cleanup the unsed code on  include/linux/fs.h.
>>     All filesystem using mount_bdev and mount_nodev
>>     to replace get_sb_bdev and get_sb_nodev.
>>     So rmmove the unused code.
> 
> Um, why are you sending this to the linux-ext4 list?

To be clear, sending this to linux-fsdevel and linux-kernel would probably
be more appropriate.  With the changes Ted suggested.

-Eric

> And if you really want to get rid of get_sb_bdev and get_sb_nodev, you
> should send a single patch which removes it from all files in the
> Linux source tree, as well as updating references to these functions
> in the Documentation/filesystems/porting file.
> 
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

