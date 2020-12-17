Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D22EC4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 21:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E372A23715
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 21:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgLQV0J convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Dec 2020 16:26:09 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:54942 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729152AbgLQV0J (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Dec 2020 16:26:09 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2020 16:26:08 EST
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 09F33607400C;
        Thu, 17 Dec 2020 22:15:25 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hByukZsLW-RK; Thu, 17 Dec 2020 22:15:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id A7B15607400D;
        Thu, 17 Dec 2020 22:15:24 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QUqGYIv__iVP; Thu, 17 Dec 2020 22:15:24 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 857C7607400C;
        Thu, 17 Dec 2020 22:15:24 +0100 (CET)
Date:   Thu, 17 Dec 2020 22:15:24 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1954206563.139982.1608239724384.JavaMail.zimbra@nod.at>
In-Reply-To: <CA1BD917-22BD-4AAD-877D-BDF41B36D945@dilger.ca>
References: <20201201151301.22025-1-richard@nod.at> <X9ujIOJG/HqMr88R@mit.edu> <CA1BD917-22BD-4AAD-877D-BDF41B36D945@dilger.ca>
Subject: Re: [PATCH] ext4: Don't leak old mountpoint samples
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: ext4: Don't leak old mountpoint samples
Thread-Index: 5/agPCILI9+Z5tj3UF1N6yN+vCIJ5Q==
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

----- Ursprüngliche Mail -----
>>    Fix this by using strncpy() instead of strlcpy().  The superblock
>>    field is defined to be a fixed-size char array, and it is already
>>    marked using __nonstring in fs/ext4/ext4.h.  The consumer of the field
>>    in e2fsprogs already assumes that in the case of a 64+ byte mount
>>    path, that s_last_mounted will not be NUL terminated.
>> 
>>    Reported-by: Richard Weinberger <richard@nod.at>
>>    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Color me confused, but I don't see how this change makes any difference?
> If "cp" is only "/" then it will *still* not overwrite "edia/johnjdeveloper"
> at the end of the s_last_mounted array.  To my mind, the only difference
> between using strlcpy() and strncpy() would be whether the last byte in
> the array can be used or not, but doesn't affect the remaining bytes.

strncpy() zeros all remaining bytes.

Thanks,
//richard
