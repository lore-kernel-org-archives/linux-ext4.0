Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826FDC4151A
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 23:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 524C1217D9
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 23:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEEpneuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfBQXnE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 18:43:04 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46000 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727475AbfBQXnD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2019 18:43:03 -0500
Received: by mail-qt1-f196.google.com with SMTP id d18so7305832qtg.12;
        Sun, 17 Feb 2019 15:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qsOKvt/Pmq5PIpTfxKjwbzK8GeiIgQ/5xK2omtv8d+I=;
        b=BEEpneuAcqyyy4hChUjYmziADOnQ/sC1O2ZccQWouw7Gu+9rnNjh+gDLa5Qaz168d1
         gPXOdDXck7IMWIec8RimmX6r1xoR28IdkW3XnMmfnX+nIG7X/HF3LsexUfSuVCQE4XSd
         T157DSTVOLVeaMzcSc1SQmrPAXndxuvhOz4NwiMrFb9XWy1fpo7W8kzlkQjL/cVifhbM
         91sg2F+4Qehsc2PEDMfisuH+A7FvyM610M4FNE+gVwHBDbO7DYNM9h2VmCjn1b9nrokA
         OCoCLnv/ks+MefMIlXPXK8E+HlxRfs3yUp5G7gweyX2bcekp2RyjJR10bz8s8sNmUH92
         u+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qsOKvt/Pmq5PIpTfxKjwbzK8GeiIgQ/5xK2omtv8d+I=;
        b=HNq6yXEz0ZIsec55PnI+/RWKpdFluy4nnClNYftsS4UJih/ZqsU07pl0ofx/rxiZ8s
         Hr5cFHUl9ogtfj1yggQGIf1m/koDHYQcx7/U4Ps5z/CcqweUphtFkGCuj5vh8Anhcy6V
         KBtoHYfRtDOmWKgwoQ5hTVeHCbvTJloNq5sbv95a0gzk8rdOfBUaz/UZi18K9iehxELQ
         gOSt5759oFc0yW5zi+LiMyxR5yRtsqw31e7V2hX+koYb2YmT4PczsnJe/eEMDDFbrZoK
         QFxYcMf/zDMPvjzj6oJHZvov3pGwQAlcs7KZS0ySb2VaIs007FYTnDeOuE2w4phB5JSV
         HdHQ==
X-Gm-Message-State: AHQUAubXvAzkZ0MXkakmCV8tqH67hUEep/0oy8HwPPTgWtOVfkF0oe/u
        3ki5Tlpm811EDOZh2NMK4d/DOH4sGyI=
X-Google-Smtp-Source: AHgI3IZ+IL1g9tgvhWtr3WnHiEf6unpawASr/uNVdUj5ymR7QydNV3UD2Q1Ndf1OA2ttxRjVc/7zwg==
X-Received: by 2002:ac8:30c5:: with SMTP id w5mr15845380qta.323.1550446981604;
        Sun, 17 Feb 2019 15:43:01 -0800 (PST)
Received: from [192.168.1.204] (pool-108-7-72-149.bstnma.fios.verizon.net. [108.7.72.149])
        by smtp.gmail.com with ESMTPSA id t26sm7919040qkl.73.2019.02.17.15.42.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 15:43:00 -0800 (PST)
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
From:   Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
Date:   Sun, 17 Feb 2019 18:42:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190217210948.GB14116@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/17/19 4:09 PM, Dave Chinner wrote:
> On Sun, Feb 17, 2019 at 03:36:10PM -0500, Ric Wheeler wrote:
>> One proposal for btrfs was that we should look at getting discard
>> out of the synchronous path in order to minimize the slowdown
>> associated with enabling discard at mount time. Seems like an
>> obvious win for "hint" like operations like discard.
> We already have support for that. blkdev_issue_discard() is
> synchornous, yes, but __blkdev_issue_discard() will only build the
> discard bio chain - it is up to the caller to submit and wait for it.
>
> Some callers (XFS, dm-thinp, nvmet, etc) use a bio completion to
> handle the discard IO completion, hence allowing async dispatch and
> processing of the discard chain without blocking the caller. Others
> (like ext4) simply call submit_bio_wait() to do wait synchronously
> on completion of the discard bio chain.
>
>> I do wonder where we stand now with the cost of the various discard
>> commands - how painful is it for modern SSD's?
> AIUI, it still depends on the SSD implementation, unfortunately.

I think the variability makes life really miserable for layers above it.

Might be worth constructing some tooling that we can use to validate or shame 
vendors over - testing things like a full device discard, discard of fs block 
size and big chunks, discard against already discarded, etc.

Regards,

Ric



