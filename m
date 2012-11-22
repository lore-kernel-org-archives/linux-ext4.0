From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h in super.c
Date: Thu, 22 Nov 2012 10:43:52 +0530
Message-ID: <CAK9yfHyVJjxX46C8b6fduxTmEeqvx5p9j-bE7X9v=Wcpq9aLVA@mail.gmail.com>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
	<20121119133944.GA11095@gmail.com>
	<CAK9yfHyLzJE+rH3L0UN1x2dVNcEdaR=F7Z_Q2NfTidV2GKuP=g@mail.gmail.com>
	<20121119162356.GB2337@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Sachin Kamat <sachin.kamat@linaro.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, patches@linaro.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55777 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2KVVsd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Nov 2012 16:48:33 -0500
Received: by mail-vb0-f46.google.com with SMTP id ff1so3138577vbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Nov 2012 13:48:32 -0800 (PST)
In-Reply-To: <20121119162356.GB2337@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

On 19 November 2012 21:53, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, Nov 19, 2012 at 08:36:06PM +0530, Sachin Kamat wrote:
>> Hi Zheng,
>>
>> On 19 November 2012 19:09, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>> > On Mon, Nov 19, 2012 at 04:47:22PM +0530, Sachin Kamat wrote:
>> >> ext4_extents.h was included twice.
>> >>
>> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> >> ---
>> >>  fs/ext4/super.c |    1 -
>> >>  1 files changed, 0 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> >> index ad6cd8a..c8a6138 100644
>> >> --- a/fs/ext4/super.c
>> >> +++ b/fs/ext4/super.c
>> >> @@ -50,7 +50,6 @@
>> >>  #include "xattr.h"
>> >>  #include "acl.h"
>> >>  #include "mballoc.h"
>> >> -#include "ext4_extents.h"
>> >
>> > Hi Sachin,
>> >
>> > Sorry, I don't find this duplicated code in mainline kernel 3.7-rc6.
>>
>> The duplicated code is available on the linux-next tree (20121115).
>> The second instance was added by the commit
>> "ext4: let ext4 maintain extent status tree" (commit id: 51865fda).
>
> Good catch.  Sorry for my fault that introduces this duplicated code.
> The patch looks good to me.
>
> Regards,
>                                                 - Zheng

This is just a simple patch to remove the include statement coded
twice in the file.
Please pick this up.

-- 
With warm regards,
Sachin
