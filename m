From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4:quiet 'unsed variables' compiling warnings.
Date: Tue, 28 Jun 2011 09:32:17 +0800
Message-ID: <BANLkTima0abH9p839-OVa7dk2U6B7PyoHg@mail.gmail.com>
References: <1308108420-13799-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110627203442.GF2729@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47237 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1F1BcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 21:32:17 -0400
Received: by pvg12 with SMTP id 12so3190146pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:32:17 -0700 (PDT)
In-Reply-To: <20110627203442.GF2729@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 4:34 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Jun 15, 2011 at 11:27:00AM +0800, Yongqiang Yang wrote:
>> Delete unused variables.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 859f2ae..fece8c2 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -2860,7 +2860,7 @@ ext4_mb_normalize_request(struct ext4_allocati=
on_context *ac,
>> =A0{
>> =A0 =A0 =A0 int bsbits, max;
>> =A0 =A0 =A0 ext4_lblk_t end;
>> - =A0 =A0 loff_t size, orig_size, start_off;
>> + =A0 =A0 loff_t size, start_off;
>
> Unfortunately, orig_size is being used by an mb_debug statement. =A0S=
o
> simply removing orig_size and its initialization will cause the build
> to break if CONFIG_EXT4_DEBUG is enabled.
Sorry for my carelessness.
>
> Can you resend this patch with this part of the patch removed?
>
> Also, for future reference I prefer for consistency's sake that the
> one-line summary be:
>
> ext4: quiet 'used variables' compiling warnings
>
> (note the space after "ext4: ", the lack of a ending period, and the
> spelling correction for "unsed"; the other change which I will
> commonly make for folks, again for consistency, is to make the first
> word after "ext4: " lower case --- the summary does not have to be a
> complete sentence, which is why I remove the trailing period)
I have resent the updated patch.   Thank you very much for your
explanation on the summary.

Yongqiang.
>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
