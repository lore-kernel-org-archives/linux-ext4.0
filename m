From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC PATCH 3/5] ext4: add operations on delayed extent tree
Date: Fri, 9 Sep 2011 09:14:02 +0800
Message-ID: <CAGBYx2a6nP75B_MigovDUPHSGALqQ-ar5Qb37vwTBgurxgfBjg@mail.gmail.com>
References: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
	<1314694821-17213-4-git-send-email-xiaoqiangnk@gmail.com>
	<20110908185851.GB2393@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	adityakali@google.com, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:46375 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab1IIBOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Sep 2011 21:14:03 -0400
Received: by gwb17 with SMTP id 17so651957gwb.1
        for <linux-ext4@vger.kernel.org>; Thu, 08 Sep 2011 18:14:03 -0700 (PDT)
In-Reply-To: <20110908185851.GB2393@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 9, 2011 at 2:58 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 30-08-11 17:00:19, Yongqiang Yang wrote:
>> This patch adds operations on a delayed extent tree.
>>
>> Signed-off-by; Yongqiang Yang <xiaoqiangnk@gmail.com>
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> =A0I don't have time to do a full review of the series now but I defi=
nitely
> think you should use RB tree to track extents. For big files written =
in
> random manner we will just burn lots of CPU cycles needlessly...
I planned to use RB instead,  I sent out this series to collect feedbac=
ks.

Thank you.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
