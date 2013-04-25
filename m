From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: Fwd: block level cow operation
Date: Thu, 25 Apr 2013 18:30:18 +0530
Message-ID: <CAD6i1fKzoWdqaBRzTh1xMu9thc=9GCGbvz3eyi3yzeTMNgBApg@mail.gmail.com>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com>
 <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com> <87txnfrcbp.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42276 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3DYNAk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2013 09:00:40 -0400
Received: by mail-ea0-f171.google.com with SMTP id b10so325082eae.2
        for <linux-ext4@vger.kernel.org>; Thu, 25 Apr 2013 06:00:38 -0700 (PDT)
In-Reply-To: <87txnfrcbp.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, Apr 9, 2013 at 8:16 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>
> you should not block bio/requests handling, but simply deffer original
> bio. Some things like that:
>
> OUR_MAIN_ENTERING_POINT {
>   if (bio->bi_rw == WRITE) {
>      if (cow_required(bio))
>        cow_bio  = create_cow_copy(bio)
>        submit_bio(cow_bio);
>    }
>   /* Cow is not required */
>    submit_bio(bio);
> }

> This approach gives us reasonable performance ~3 times slower than disk
> throughput.
> For a reference implementation you may look at driver/dm/dm-snap or to
> Acronis snapapi module (AFAIR it is opensource)
> }

Thanks. That is what I was looking for. Got the ref code from snapapi
module which is opensource.

Its not something that is specific to any filesystem.

Regards.
