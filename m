From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Mon, 18 Aug 2008 10:08:11 +0800
Message-ID: <48A8D98B.9020701@cn.fujitsu.com>
References: <48996A33.3010507@cn.fujitsu.com> <20080810022643.GC14756@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYHRCJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Aug 2008 22:09:45 -0400
In-Reply-To: <20080810022643.GC14756@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(sorry for the so dealyed reply, I was offline last week.)

Theodore Tso wrote:
> On Wed, Aug 06, 2008 at 05:09:07PM +0800, Li Zefan wrote:
>> +	case EXT4_IOC_GETCRTIME:
>> +		return put_user(ei->i_crtime, (struct timespec __user *)arg);
>> +
> 
> I'm worried about writing a struct timespec directly to user space,
> because the kernel's idea of what is struct timespec might not be the
> same as the userspace's understanding of struct timespec ---

We have system call nanosleep(), which copies a struct timespec directly
from user space.

> specifically, because of the question of the width of time_t might be
> different in the kernel and in userspace on different architectures.
> 

But timeval.tv_sec is also of type time_t. Also sys_time() writes a time_t
directry to user space.

I should not use put_user() though...

+		return copy_to_user((struct timespec __user *)arg,
+ 			&ei->i_crtime, sizeof(ei->i_crtime));

> I think we would be better off explicitly defining a structure, or
> just returning the seconds and nanoseconds in explicit primitive
> types.
> 


