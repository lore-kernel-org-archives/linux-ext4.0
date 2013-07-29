From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH 1/2] debugfs.c: the max length of debugfs argument is
 too short
Date: Mon, 29 Jul 2013 15:16:05 +0800
Message-ID: <51F616B5.6020606@windriver.com>
References: <1374834657-17091-1-git-send-email-liezhi.yang@windriver.com> <1374834657-17091-2-git-send-email-liezhi.yang@windriver.com> <20130729023756.GD5827@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <dvhart@linux.intel.com>,
	<darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:64369 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3G2HQf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 03:16:35 -0400
In-Reply-To: <20130729023756.GD5827@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

Thanks, I will update it and send a V3.

// Robert

On 07/29/2013 10:37 AM, Theodore Ts'o wrote:
> On Fri, Jul 26, 2013 at 06:30:56PM +0800, Robert Yang wrote:
>> The max length of debugfs argument is 256 which is too short, the
>> arguments are two paths, the PATH_MAX is 4096 according to
>> /usr/include/linux/limits.h, use 2048 (4096 / 2) is a reasonable value.
>
> I'd just use BUFSIZ (which is 8192 on Linux systems).  That's what the
> ss library uses, and if you might have two paths and PATH_MAX is 4096,
> 2048 could easily be too small.
>
> 					- Ted
>
>
