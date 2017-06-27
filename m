From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 07/12] e2fsck: track ea_inode references
Date: Mon, 26 Jun 2017 18:25:48 -0700
Message-ID: <CAAeU0aMBM0DASLL_WjpNS=hvx9n4ntEJEKs_X=a948oJiHV26w@mail.gmail.com>
References: <20170626134348.1240-1-tahsin@google.com> <20170626134348.1240-7-tahsin@google.com>
 <2822BB00-1A19-4DE4-8532-63FC307E5D7B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34222 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdF0BZu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 21:25:50 -0400
Received: by mail-yw0-f179.google.com with SMTP id s127so6873858ywg.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 18:25:49 -0700 (PDT)
In-Reply-To: <2822BB00-1A19-4DE4-8532-63FC307E5D7B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> +#ifdef EXT2_NO_64_TYPE
>> +             fprintf(f, "%*u", width, ctx->num2);
>> +#else
>> +             fprintf(f, "%*llu", width, (long long)ctx->num2);
>> #endif
>
> Rather than a series of "#ifdef EXT2_NO_64_TYPE" checks, it would be cleaner
> to have a single #define to set the printf type, like:
>
> #ifdef EXT2_NO_64_TYPE
> #define EXT2_64U "%*u"
> #define EXT2_64D "%*d"
> #define EXT2_64X "%*x"
> #else
> #define EXT2_64U "%*llu"
> #define EXT2_64D "%*lld"
> #define EXT2_64X "%*llx"
> #endif

I am trying to figure out the purpose of #ifdef EXT2_NO_64_TYPE checks
now. Who defines it and what problem does it solve?

thanks
