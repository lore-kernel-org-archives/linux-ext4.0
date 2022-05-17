Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5BCC433F5
	for <linux-ext4@archiver.kernel.org>; Tue, 17 May 2022 19:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343897AbiEQT5P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 17 May 2022 15:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347718AbiEQT5N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2022 15:57:13 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C5C522C2
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2022 12:57:10 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 594B31F4404A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652817428;
        bh=OWXF6pN1PKCgd1hX+us24uD4Px7KYa/a9N/AE+rwvM4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MNzP6OhNLXZ5yDXAQu5rueURwO2Uxu1GS86MzOjPufuvaNR9Q7nnkzH0RcByRFwAL
         XMfTwYuZ7UM3DgKVUwqlWcNvFs/vrPrzssPlBcjIY11866UwSxMHJcETkHJH+cwYcW
         MNBqilZDb+k5CZqGqVFjGwQRbY7EQ9QOEC0gjUB1t8her9T3p0PusulQScw8ffCHud
         bmEsilcAsOBVfaMoKtmtZ8Wk1eD7UCX8dKX9s2UNiqAN52rb00tWSPEO4tOkI8r61u
         qMfna+TLKoTGVPqOJJ/HP/1rP/wdwIrilQhv7AIKTYuOFPgxOnv5HFyy0gza8edrTi
         q1AadYCLotVbA==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        ebiggers@kernel.org, kernel@collabora.com
Subject: Re: [PATCH v4 00/10] Clean up the case-insensitive lookup path
Organization: Collabora
References: <20220511193146.27526-1-krisman@collabora.com>
        <YoP5jH5axe9ltX2Y@mit.edu>
Date:   Tue, 17 May 2022 15:57:05 -0400
In-Reply-To: <YoP5jH5axe9ltX2Y@mit.edu> (Theodore Ts'o's message of "Tue, 17
        May 2022 15:37:48 -0400")
Message-ID: <87y1z0vsoe.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

"Theodore Ts'o" <tytso@mit.edu> writes:

> On Wed, May 11, 2022 at 03:31:36PM -0400, Gabriel Krisman Bertazi wrote:
>> The case-insensitive implementations in f2fs and ext4 have quite a bit
>> of duplicated code.  This series simplifies the ext4 version, with the
>> goal of extracting ext4_ci_compare into a helper library that can be
>> used by both filesystems.  It also reduces the clutter from many
>> codeguards for CONFIG_UNICODE; as requested by Linus, they are part of
>> the codeflow now.
>> 
>> While there, I noticed we can leverage the utf8 functions to detect
>> encoded names that are corrupted in the filesystem. Therefore, it also
>> adds an ext4 error on that scenario, to mark the filesystem as
>> corrupted.
>
> Gabriel, are you planning on doing another version of this patch
> series?
> It looks like the first two patches for ext4 are not controversial, so
> I could take those, while some of the other patches have questions
> which Eric has raised.

Hi Ted,

I'll be reworking the series to apply Eric's comments and I might render
patch 1 unnecessary.  I'd be happy to send a v5 for the whole thing
instead of applying the first two now.

Thanks, 


-- 
Gabriel Krisman Bertazi
