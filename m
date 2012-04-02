From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: ignore last group without enough space when resizing
Date: Mon, 2 Apr 2012 23:06:49 +0800
Message-ID: <CAGBYx2ZQaagn+sNYOm=dRXYKHhPR_CR1ZOBdQB4=UQ24SC2Xzg@mail.gmail.com>
References: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
	<1328065291-13607-2-git-send-email-xiaoqiangnk@gmail.com>
	<CAMLZHHQ2Y7w4VvakYBmKeqzhnNi99We3y26fFwy9x1tDPx3vvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58514 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2DBPG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Apr 2012 11:06:57 -0400
Received: by obbtb18 with SMTP id tb18so2180042obb.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 Apr 2012 08:06:57 -0700 (PDT)
In-Reply-To: <CAMLZHHQ2Y7w4VvakYBmKeqzhnNi99We3y26fFwy9x1tDPx3vvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 2, 2012 at 11:04 PM, Daniel Drake <dsd@laptop.org> wrote:
> Hi,
>
> On Tue, Jan 31, 2012 at 9:01 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> If last gtoup has no enough space for group tables, then we
>> just ignore it.
>>
>> Reported-by: Daniel Drake <dsd@laptop.org>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> Thanks, this fixes the crash.
>
> Am I right in thinking that the companion patch "[PATCH] resize2fs:
> let online resizing report new blocks count right" is only needed for
> cosmetic reasons; the resize operation will be successful even without
> that patch applied to resize2fs?
Yep,  that patch just lets resize2fs report right size of resized filesytems.

Thanks,
Yongqiang.
>
> Thanks,
> Daniel



-- 
Best Wishes
Yongqiang Yang
