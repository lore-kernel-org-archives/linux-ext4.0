Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51011C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 22:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C243218AD
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 22:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pycDR0eY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731856AbfBRWax (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:30:53 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36867 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbfBRWax (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2019 17:30:53 -0500
Received: by mail-qt1-f193.google.com with SMTP id a48so21026753qtb.4;
        Mon, 18 Feb 2019 14:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=zQ+rW8xj/RQR5ug2h9q7b524JpzwsETcbe2rNn2M4gA=;
        b=pycDR0eYUUpiaR+Pg2PdAYEeEf93KrZ+SfKC5mRArmhN25oFcjY+Y3rqxrlI2yXlWE
         dGJS4hb0/3LKv9e7pT8e2VSvsJQWuib2en/zB84eIfiGRxHJT++AISnKP/rHPJkM/Yej
         gJfrgyfq1WzX6eVfL0IOZENBl2Hfqjui7AofIXUJH3VPN6XZyKyGFWmra0Gcm68viaOJ
         acL09wROyXqh66yyEnp/MYJFSzM8HPzm4WVJ/hm2EXBl5Dwgz6snDrlqnpxukHntQQrM
         8YMMGzUdibWgniPPzpxRreJbC94CcLzW20pKi+JTNGMl/UmxCeB5QJ100mDWp48EheXC
         AJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zQ+rW8xj/RQR5ug2h9q7b524JpzwsETcbe2rNn2M4gA=;
        b=pzWncYPyrYGnNzYnXt2IKoidGEHqyXVHXLWLlS3Q6pu8ApYAem+8Btpf2LUW6gStUd
         9eDm+TAH5mCV2FRiaDkafhgl+I1A8TQXUw2BRlPYVIW0pqEYA/0HymJZq73cZsJouRIv
         83SkJmX3kMU6uQ2/feylPLH4nB28FPIRVaFAkL4dOmvDziFrLd3VFcTnO/+t2qEoINjL
         QQfGOAhHHRoxoAZtTyl+5I98jootXPkpLnJ+HzLj5dKf/d5QhpzvmuxGjfG3yelOY5KA
         56DlGAuDgcak9hgrTO7d9UCL+PLATXeuSBAv3p1BRwIQpLtz/tHUO5TV8uPBfcKCZjgw
         +mdQ==
X-Gm-Message-State: AHQUAuZOJRCSgGvaIDYIY6hP4AHc4uYmEA5hrCDsO14cYG+V6amsCO5O
        gm++OmT+vwjg3BtLDGcjBrA3egGR8j4=
X-Google-Smtp-Source: AHgI3IY6Yklx2L3LEMsz3lAyI3mXpcX25uBJ0jDOJd8eJUey2HGNt5+WPbh+lcKGgwaA1lAFyUJHTA==
X-Received: by 2002:ac8:25b5:: with SMTP id e50mr21051332qte.186.1550529050902;
        Mon, 18 Feb 2019 14:30:50 -0800 (PST)
Received: from [192.168.1.204] (pool-108-7-72-149.bstnma.fios.verizon.net. [108.7.72.149])
        by smtp.gmail.com with ESMTPSA id f19sm9610599qtf.1.2019.02.18.14.30.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 14:30:50 -0800 (PST)
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
To:     Dave Chinner <david@fromorbit.com>
Cc:     lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190218022243.GC14116@dastard>
From:   Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <86f2588d-8567-3905-40aa-c422393daaf1@gmail.com>
Date:   Mon, 18 Feb 2019 17:30:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190218022243.GC14116@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/17/19 9:22 PM, Dave Chinner wrote:
> On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
>> On 2/17/19 4:09 PM, Dave Chinner wrote:
>>> On Sun, Feb 17, 2019 at 03:36:10PM -0500, Ric Wheeler wrote:
>>>> One proposal for btrfs was that we should look at getting discard
>>>> out of the synchronous path in order to minimize the slowdown
>>>> associated with enabling discard at mount time. Seems like an
>>>> obvious win for "hint" like operations like discard.
>>> We already have support for that. blkdev_issue_discard() is
>>> synchornous, yes, but __blkdev_issue_discard() will only build the
>>> discard bio chain - it is up to the caller to submit and wait for it.
>>>
>>> Some callers (XFS, dm-thinp, nvmet, etc) use a bio completion to
>>> handle the discard IO completion, hence allowing async dispatch and
>>> processing of the discard chain without blocking the caller. Others
>>> (like ext4) simply call submit_bio_wait() to do wait synchronously
>>> on completion of the discard bio chain.
>>>
>>>> I do wonder where we stand now with the cost of the various discard
>>>> commands - how painful is it for modern SSD's?
>>> AIUI, it still depends on the SSD implementation, unfortunately.
>> I think the variability makes life really miserable for layers above it.
> Yup, that it does.
>
>> Might be worth constructing some tooling that we can use to validate
>> or shame vendors over
> That doesn't seem to work.
>
>> - testing things like a full device discard,
>> discard of fs block size and big chunks, discard against already
>> discarded, etc.
> We did that many years ago because discard on SSDs sucked:
>
> https://people.redhat.com/lczerner/discard/test_discard.html
> https://sourceforge.net/projects/test-discard/files/
>
> And, really, that didn't changed a thing - discard still sucks...
>
> Cheers,
>
> Dave.

Totally forgot about that work - maybe it is time to try again and poke some 
vendors.

Ric


