From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 05/10] misc/create_inode.c: copy regular file
Date: Fri, 27 Dec 2013 09:48:04 +0800
Message-ID: <52BCDC54.9000109@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com> <1387800600-13718-6-git-send-email-liezhi.yang@windriver.com> <1387827139.5088.69.camel@dvhart-mobl4.amr.corp.intel.com> <20131226160335.GA23928@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:59905 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3L0BsK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Dec 2013 20:48:10 -0500
In-Reply-To: <20131226160335.GA23928@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

Thanks for the reply, I will update it.

// Robert

On 12/27/2013 12:03 AM, Theodore Ts'o wrote:
> On Mon, Dec 23, 2013 at 11:32:19AM -0800, Darren Hart wrote:
>>
>> Does __FUNCTION__ not provide this same functionality in this context?
>> No need to store this explicitly is there?
>
> Note: __func__ (which is specified by C99, and supported by newer
> GCC's) is preferred over __FUNCTION__.
>
> If we really care about supporting older versions of GCC, we could do
> this:
>
>       #if __STDC_VERSION__ < 199901L
>       # if __GNUC__ >= 2
>       #  define __func__ __FUNCTION__
>       # else
>       #  define __func__ "<unknown>"
>       # endif
>       #endif
>
> Cheers,
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
