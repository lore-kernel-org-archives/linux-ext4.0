From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: Fwd: block level cow operation
Date: Fri, 10 May 2013 18:44:16 +0530
Message-ID: <CAD6i1fL3ED+BNdBfJio4e1w+sSGg0_tJea7DwD7h3r59VeT5iA@mail.gmail.com>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com>
 <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
 <87txnfrcbp.fsf@openvz.org> <CAD6i1fKzoWdqaBRzTh1xMu9thc=9GCGbvz3eyi3yzeTMNgBApg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50228 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3EJNOh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 May 2013 09:14:37 -0400
Received: by mail-ee0-f46.google.com with SMTP id e49so223152eek.33
        for <linux-ext4@vger.kernel.org>; Fri, 10 May 2013 06:14:36 -0700 (PDT)
In-Reply-To: <CAD6i1fKzoWdqaBRzTh1xMu9thc=9GCGbvz3eyi3yzeTMNgBApg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, Apr 25, 2013 at 6:30 PM, Prashant Shah <pshah.mumbai@gmail.com> wrote:
> Hi,
>
> On Tue, Apr 9, 2013 at 8:16 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>>
>> you should not block bio/requests handling, but simply deffer original
>> bio. Some things like that:
>>
>> OUR_MAIN_ENTERING_POINT {
>>   if (bio->bi_rw == WRITE) {
>>      if (cow_required(bio))
>>        cow_bio  = create_cow_copy(bio)
>>        submit_bio(cow_bio);
>>    }
>>   /* Cow is not required */
>>    submit_bio(bio);
>> }
>
>> This approach gives us reasonable performance ~3 times slower than disk
>> throughput.
>> For a reference implementation you may look at driver/dm/dm-snap or to
>> Acronis snapapi module (AFAIR it is opensource)
>> }

Is this scenario possible ?

If a write bio (bio1) for a particular sector is under cow and waiting
for the read of the original block to complete. At the same time there
is another write bio (bio2) for the same sector. The original order is
bio1 then bio2. Now since bio1 is delayed due to cow and the new order
becomes bio2 followed by bio1 that goes in the queue. This will cause
the final on-disk write to be bio1.

Regards.
