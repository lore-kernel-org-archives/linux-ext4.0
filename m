Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D16C433F5
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353FB60F6B
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Sep 2021 14:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbhIFOSP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242521AbhIFOSO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Sep 2021 10:18:14 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3273EC061575;
        Mon,  6 Sep 2021 07:17:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d:444a:d152:279d:1dbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6ABBE4E5;
        Mon,  6 Sep 2021 14:17:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6ABBE4E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1630937829; bh=Lpb9vzRhZk8zRQogy14Qm1CbB1/Zp0tXUREKdcmXFNs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QX77uN5jJKeA9sED9SI9/o05/2+fHw0la8hL5q96xQEl5IrRybr+n080Q5nHMhHnX
         2mSTXrOdZ3TC7YpRSiJVQeMrQixIafiWEBSnwafats9W1bBtVwzwNHt5AACWxxciJ0
         6f26FjAEPm0S32wv/E4el1ofh7lFpQ8bciPK0Z6Mb+veQn23Rrk42SKttL53XWoo0J
         Ga4HCCwNFsujYqNld6XdurAF3/4u+kETAxztplLwx8ciSPmzb5r7+rIN7O+N/WEfF4
         7q1270EQfX8b9iGrMvh5hXvvT1zzIg0+YOivLLD4HrVI9pMzGboMEZOu149mRySCsD
         G3gUri4uvf38w==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Markus Heiser <markus.heiser@darmarit.de>,
        Akira Yokosawa <akiyks@gmail.com>
Cc:     jack@suse.cz, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/2] ext4: docs: switch away from list-table
In-Reply-To: <68ae637d-dc8d-cedc-b058-8f4ebb146137@darmarit.de>
References: <20210902220854.198850-2-corbet@lwn.net>
 <b1909f4c-9e07-abd7-89ee-c2e551f9dc5b@gmail.com>
 <871r65zobl.fsf@meer.lwn.net>
 <a93af4a2-9b9f-6430-bc3a-dfb2dbf7e56b@gmail.com>
 <68ae637d-dc8d-cedc-b058-8f4ebb146137@darmarit.de>
Date:   Mon, 06 Sep 2021 08:17:08 -0600
Message-ID: <87lf49wzyz.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Markus Heiser <markus.heiser@darmarit.de> writes:

> We prefer list tables ...
>
> """Their advantage is that they are easy to create or modify and that the
> diff of a modification is much more meaningful, because it is limited to
> the modified content."""
>
> By example: We have some very large tables with tons of rows and cols.
> If you need to extend one column just by one character you have to edit
> the whole table and the diff is not readable.
>
> It is not limited to big tables, e.g. if you patch a simple typo,
> you might need touch content not related to your fix.
>
> At the end it is a trade of, what weights more, readability of the
> plain text or readability of the patch / most often I would vote
> for the latter.

If the documentation is of any use of all there will be a lot more
people reading it than will be reading patches making tweaks to it.
Optimizing for patch readability seems like the wrong focus to me.

The ext4 folks can decide what they like best in this specific case.
But I think that the advice in favor of list tables is wrong in the
general case; they are completely unreadable in their source form, and
that goes against one of the key reasons we adopted RST in the first
place.

Somebody will surely try to add a list table to the wrong document
someday and I'll get to live through another one of those nifty
explosions - and I'll have neither reasons nor motivation to defend that
policy.

Thanks,

jon
