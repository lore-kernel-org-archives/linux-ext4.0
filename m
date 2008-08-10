From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: add EXT4_IOC_GETCRTIME ioctl
Date: Sat, 9 Aug 2008 22:26:43 -0400
Message-ID: <20080810022643.GC14756@mit.edu>
References: <48996A33.3010507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36432 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753674AbYHJDoF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2008 23:44:05 -0400
Content-Disposition: inline
In-Reply-To: <48996A33.3010507@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 06, 2008 at 05:09:07PM +0800, Li Zefan wrote:
> +	case EXT4_IOC_GETCRTIME:
> +		return put_user(ei->i_crtime, (struct timespec __user *)arg);
> +

I'm worried about writing a struct timespec directly to user space,
because the kernel's idea of what is struct timespec might not be the
same as the userspace's understanding of struct timespec ---
specifically, because of the question of the width of time_t might be
different in the kernel and in userspace on different architectures.

I think we would be better off explicitly defining a structure, or
just returning the seconds and nanoseconds in explicit primitive
types.

Regards,

	     	 	       		 - Ted
