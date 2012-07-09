From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Mon, 9 Jul 2012 23:07:42 +0530
Message-ID: <CAOiN93mB+fTYdMQ69hAD45mf4cw1q72bykgOZ9gmrt8udNvNSg@mail.gmail.com>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com>
	<CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
	<alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
	<CAOiN93kzvKVDzSJ13HJZDh9ANt3UaBy0o_QHNKCSHHTizjtY0w@mail.gmail.com>
	<alpine.LFD.2.00.1207041926290.29222@localhost>
	<CAOiN93mJO6=dV4U=Qyw7myz34EF_doaoLsFHksmu4-n8pOzXBA@mail.gmail.com>
	<alpine.LFD.2.00.1207091121480.5986@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: sandeen@redhat.com, Ted Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2GIRhn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2012 13:37:43 -0400
In-Reply-To: <alpine.LFD.2.00.1207091121480.5986@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Ok, the code is not very clear, but now I can see it. p_block is
> actually misused here to store the number of indexes in the current
> node while diving into the tree. Then on the way up, we are checking
> that to see if the eh_entries changed or not (which is indicating
> that something has been freed deeper in the tree).
True, p_block is misused. We tried to fix the problem with
minimum code change.
>
> That said, it makes sense to set it before the loop itself because
> we are actually skipping the path construction while diving into
> the tree since patch is already initialized and we're starting
> walking back from 'depth' up in this case. So the patch seems fine.
> Thanks for catching it and fixing it.
>
> You can add
>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>
Thanks for your review.
>
>> >
>> > Note: there are some indent problems in your patch, like for example
>> > this:
>> >
>> > +                       path[k].p_block =
>> > +                       le16_to_cpu(path[k].p_hdr->eh_entries)+1;
>> >
>> >
>> Before submitting the patch, I run checkpatch.pl with --strict option.
>> It did'nt show any error or warning. Should I re-submit
>> the patch with an extra tab before the second line? The call is yours.
>
> checkpatch.pl does not catch everything. Just look at how wrapping
> of long lines is done in the code, there are plenty of examples.
>
True again. I will resend patch with proper indentation.
>>
>> > Anyway, what do you think about the modification ?
>> >
>> Also there is 1 modification missing from your patch.
>>     ext4_ext_drop_refs(path);
>>         kfree(path);
>> +       path = NULL;
>>         if (err == -EAGAIN)
>>                 goto again;
>> If path is not set to NULL, it will crash in xfstest #13. Ted has
>> already reported it.
>
> Right, I've probably used the old patch as an example.
>
> Thanks!
> -Lukas
>
Thanks,
Ashish
