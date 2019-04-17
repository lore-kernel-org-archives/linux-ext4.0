Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E727DC282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B746120663
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="t92AtvlR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733117AbfDQR5y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:57:54 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38274 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733113AbfDQR5x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:57:53 -0400
Received: by mail-io1-f65.google.com with SMTP id v4so21367013ioj.5
        for <linux-ext4@vger.kernel.org>; Wed, 17 Apr 2019 10:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R55o9kUXAJBh2tF+7lJ4JvdI2/7fbKVS3keHkBQuoNQ=;
        b=t92AtvlR/3rv6myOl2qEMMrFqmL5j0URxSzPtqJ0hsuP5M2S1ZLU/myTKYV7zN6XRD
         xl+SkL88CQctt26c/njZ9YlZ+w3p7jDh7xvxhSjj1mg+CGRnezVZcQFgX80j5Yrq24U9
         qA9x83s5IJF/fAIfDW+7XOHyvihqjZgyzYoKbJBb90BzW4Sgm6xrOV4Jz0dC626BbJ96
         hxU5+5EBmK2xI/y7MzhKSNqHQa/0psZSH5OkICMYwN4x4kuFrggbl1NzMjO7ohbmtBWk
         E/2jU9aT1HwkQwRzrFXI+Vhj1FvTfT04H0Qkmxs5HQjU7tN133c/95tvJtjHERHb4YAH
         Wlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R55o9kUXAJBh2tF+7lJ4JvdI2/7fbKVS3keHkBQuoNQ=;
        b=lLjDy4NnJPmFBB+y3bTqerJZ1q68Zpc6snLURC6uWjGVMeiTYoC0hGbPKuTlw/FYm7
         t5UiZwPSg2Yu01Bkmu8RHh+guHEkGtGO1plZ/5BpeXwdPNtC+Upg2lLiVZHtf8mBDujG
         RiNE4sHL2OYecU56PZ/K2s/tnY6fSpNqLYrEYTbMSrgfvzS4cMEW/gOW9EocjYBXplsE
         SM/0N0sklSWyhG2GeIV6+jORtMHTTqLotCQA/QRvnihz8+WL3nic5g9rnF1YlWL0xUg1
         hsyXTirHLadmpdTPsvNQg36JTe2Qvl//UrNcF5lRj+dBAaPPSPuU4c9mWtkAEmY4Xn6J
         ngCQ==
X-Gm-Message-State: APjAAAUKhul3s6HgSCgm1BZ53Nvh5iuytebZ29UMR9Yy3SEHOEIL5TPe
        lna2/EIEHps0w0M/Oh+baTRcZg==
X-Google-Smtp-Source: APXvYqz9pczPxcJFDyzjPQrXKMuKkhGOqdKZhdX6tuSwnLL+/90o9NSkJ++zKmx0wuhuYOWclDBHnw==
X-Received: by 2002:a6b:7417:: with SMTP id s23mr2709245iog.2.1555523873316;
        Wed, 17 Apr 2019 10:57:53 -0700 (PDT)
Received: from [192.168.1.158] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id e11sm19033013iob.48.2019.04.17.10.57.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 10:57:51 -0700 (PDT)
Subject: Re: [PATCH v4 4/7] block: introduce write-hint to stream-id
 conversion
To:     Kanchan Joshi <joshi.k@samsung.com>, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
 <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
 <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6850a3ad-805f-4232-1bc7-f3249e1fba96@kernel.dk>
Date:   Wed, 17 Apr 2019 11:57:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 4/17/19 11:50 AM, Kanchan Joshi wrote:
> This patch moves write-hint-to-stream-id conversion in block-layer.
> Earlier this was done by driver (nvme). Current conversion is of the
> form "streamid = write-hint - 1", for both user and kernel streams.
> Conversion takes stream limit (maintained in request queue) into
> account. Write-hints beyond the exposed limit turn to 0.
> A new field 'streamid' has been added in request. While 'write-hint'
> field continues to exist. It keeps original value passed from upper
> layer, and used during merging checks.

Why not just use the bio write hint? We already disallow merging of
dissimilar write hints, so req->bio->bi_write_hint is known to be
identical with the rest of the bio's in that chain.

-- 
Jens Axboe

