From: Ruslan Bilovol <ruslan.bilovol@ti.com>
Subject: Re: [PATCH 2/2] ext4: add sanity checks in __ext4_check_dir_entry
Date: Tue, 4 Jun 2013 14:17:36 +0300
Message-ID: <CAB=otbSGmi3yiSM5CQUS9eQWDSdWmVTuQNrobNVOJ61z7vKSGw@mail.gmail.com>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
	<1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
	<20130603154048.GC20009@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34631 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3FDLRh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jun 2013 07:17:37 -0400
In-Reply-To: <20130603154048.GC20009@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Jun 3, 2013 at 6:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 03, 2013 at 01:00:16PM +0300, Ruslan Bilovol wrote:
>> Added checks for NULL before dereferencing some pointers
>>
>> +     if (!de || !bh || !dir)
>> +             return 1;
>
> Do you know which one of these pointers was NULL?

In my particular case, the ''de" pointer is NULL

Regards,
Ruslan

>
> I want't make sure we're fixing the root issue as opposed to papering
> over it.  I'm not seeing how any of these pointers could have been
> NULL (at least in my upstream kernel), and while I believe that this
> helped for your kernel, I want to make sure we understand exactly what
> was going on.
>
> Thanks,
>
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards,
Ruslan Bilvol
