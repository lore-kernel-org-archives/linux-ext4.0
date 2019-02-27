Return-Path: <SRS0=GcgC=RC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE203C10F16
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 11:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712F1217F5
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Feb 2019 11:40:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSYxmMTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfB0LkM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:40:12 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44402 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LkM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2019 06:40:12 -0500
Received: by mail-qk1-f195.google.com with SMTP id r21so9566336qkl.11;
        Wed, 27 Feb 2019 03:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MqbmZmBEflLOc417L9UA6PZUErgZBe5rEek4RAEVK8E=;
        b=bSYxmMTfnUnIKJ8+xat5MGZezAjJ0zfi1TFmsJaB+vMJZGu+URIo6kXVwf3DjPN7sE
         PZl7IXxGHL7fPXT6jyjvKDREiksA1LGzdLFTt+xmrqaCopKOGu6XfHeVGwXIryBA23P+
         Q280f3F2RdjRsBImk8EOTkPosh1yAxzEwoF7rhj8c7m/s7NkivbTn1hdxC62ukLOvdfp
         kRbvV5KE4iU329jKbtctzqa5yFjHYn1CROvMaXekfFxY2TdbFiWSf2LKI8zVooRxl+2i
         gsF+LZj0sQwmx3aKzd1FsxNAsxDdwSCCbqzhuWVSIgmGF2uM2nAQrcxI68Lh/yP1KFvx
         U6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MqbmZmBEflLOc417L9UA6PZUErgZBe5rEek4RAEVK8E=;
        b=d8gpZk1le6mteGdCPcumsTZoe74JHXv3QDgepczVQE8QUgtEbtLRcSO8xczx4PmN5e
         URzBjI5CVKnPvDrVjU/idwJD5lqd/UGBTXEwtelpJN8lq/+W3wJFLL1RHNFrVf0EQQLZ
         TFia96yITBZmKlHZnD4ikOSBtFO35/pqn3wkQP3XDPo8VCvNDvMGHGwCSYcpKf8chdu6
         ZrKIUlqCnQdBeuL+zHtxhOtks6AjSNw3HGKFuOjHivl5HtzLoNDzQGduUMiKmGbOt7dt
         pcv3yddKrlNzYl+l0ZGUns/72pLLRrSBUFnRCPveV70qEP5r3ONqWI6H8RTUjpUMrMdG
         meow==
X-Gm-Message-State: AHQUAuY2aNk2pSYaHm643k0JlI5eymGffjjY3y6TPn+0nuO8Zgm6H1sG
        t0gp3PWeu+LMpQDZ7mEKjoH20Wi4htdS7w==
X-Google-Smtp-Source: AHgI3IZpWYVCoLx7N2g/U9q5rX6fPvQw9p9dShC5WBDKb2Ke+eaisa92IzQL295Q3bruvCKKeLu1yw==
X-Received: by 2002:a37:d6d6:: with SMTP id p83mr1784695qkl.172.1551267609979;
        Wed, 27 Feb 2019 03:40:09 -0800 (PST)
Received: from [192.168.1.204] (pool-108-7-72-149.bstnma.fios.verizon.net. [108.7.72.149])
        by smtp.gmail.com with ESMTPSA id r30sm10091056qtj.45.2019.02.27.03.40.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 03:40:09 -0800 (PST)
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
To:     Keith Busch <keith.busch@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain> <yq18sy8ili7.fsf@oracle.com>
 <20190222164504.GB10066@localhost.localdomain>
From:   Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <ec70ef66-cc7a-5a07-9e09-8154d332067a@gmail.com>
Date:   Wed, 27 Feb 2019 06:40:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190222164504.GB10066@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/22/19 11:45 AM, Keith Busch wrote:
> On Thu, Feb 21, 2019 at 09:51:12PM -0500, Martin K. Petersen wrote:
>> Keith,
>>
>>> With respect to fs block sizes, one thing making discards suck is that
>>> many high capacity SSDs' physical page sizes are larger than the fs
>>> block size, and a sub-page discard is worse than doing nothing.
>> That ties into the whole zeroing as a side-effect thing.
>>
>> The devices really need to distinguish between discard-as-a-hint where
>> it is free to ignore anything that's not a whole multiple of whatever
>> the internal granularity is, and the WRITE ZEROES use case where the end
>> result needs to be deterministic.
> Exactly, yes, considering the deterministic zeroing behavior. For devices
> supporting that, sub-page discards turn into a read-modify-write instead
> of invalidating the page.  That increases WAF instead of improving it
> as intended, and large page SSDs are most likely to have relatively poor
> write endurance in the first place.
>
> We have NVMe spec changes in the pipeline so devices can report this
> granularity. But my real concern isn't with discard per se, but more
> with the writes since we don't support "sector" sizes greater than the
> system's page size. This is a bit of a different topic from where this
> thread started, though.

All of this behavior I think could be helped if we can get some discard testing 
tooling that large customers could use to validate/quantify performance issues. 
Most vendors are moderately good at jumping through hoops held up by large deals 
when the path through that hoop leads to a big deal :)

Ric



