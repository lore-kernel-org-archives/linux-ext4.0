From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Fri, 15 Feb 2008 16:18:28 +0100
Message-ID: <47B5AD44.8010305@bull.net>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr> <47B46E71.805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34143 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYBOPRY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2008 10:17:24 -0500
In-Reply-To: <47B46E71.805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Valerie Clement wrote:
>> Fix kernel BUG at fs/ext4/mballoc.c:910!
>>
>> From: Valerie Clement <valerie.clement@bull.net>
>>
>> With the flex_bg feature enabled, a large file creation oopses the
>> kernel.
> 
> Valerie, what's the specific testcase for this?
> 
> Thanks,
> -Eric
I just did a simple dd,
  dd if=/dev/zero of=/mnt/test/foo bs=1M count=8k
on an ext4 filesystem with the uninit_groups, lazy_bg and flex_bg
features enabled and the default mount options.

The difficulty is to build e2fsprogs programs that integrate all
these new features together.
    Valerie
