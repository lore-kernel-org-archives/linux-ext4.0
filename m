From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h in super.c
Date: Mon, 19 Nov 2012 20:36:06 +0530
Message-ID: <CAK9yfHyLzJE+rH3L0UN1x2dVNcEdaR=F7Z_Q2NfTidV2GKuP=g@mail.gmail.com>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
	<20121119133944.GA11095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: gnehzuil.liu@gmail.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, patches@linaro.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65141 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2KSPGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 10:06:08 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so1221441vcm.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 07:06:06 -0800 (PST)
In-Reply-To: <20121119133944.GA11095@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zheng,

On 19 November 2012 19:09, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, Nov 19, 2012 at 04:47:22PM +0530, Sachin Kamat wrote:
>> ext4_extents.h was included twice.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  fs/ext4/super.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index ad6cd8a..c8a6138 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -50,7 +50,6 @@
>>  #include "xattr.h"
>>  #include "acl.h"
>>  #include "mballoc.h"
>> -#include "ext4_extents.h"
>
> Hi Sachin,
>
> Sorry, I don't find this duplicated code in mainline kernel 3.7-rc6.

The duplicated code is available on the linux-next tree (20121115).
The second instance was added by the commit
"ext4: let ext4 maintain extent status tree" (commit id: 51865fda).

>
> Regards,
>                                                 - Zheng
>
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/ext4.h>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
