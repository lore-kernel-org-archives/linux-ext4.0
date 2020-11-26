Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C5DC63798
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Nov 2020 06:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F2DE20B80
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Nov 2020 06:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ezaCvQHN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387783AbgKZGUt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Nov 2020 01:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732141AbgKZGUt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Nov 2020 01:20:49 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09730C0613D4
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2020 22:20:49 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id a130so1143319oif.7
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2020 22:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2R4BbQCpkO9YBouwmBRKUyTxHnROMBCPNNTzvr+bTs=;
        b=ezaCvQHNP4rXVlX6xgXScBgYsPbPPYeNewlmWmduFOZEwCAQiePxmYmVXxRNWIAKBj
         npE5+8DtXXxl5lIDZZS0EJDFMin+cuNhqnF9GVWXdwt95ToczUH17XgI/N/f5RDdgVTk
         K20LAvN4Q8KwIAWKWxz7lhuudgoUDjDQNgOQ9wCJS5pv4UlJ8k6N+hip7il4Tw3qlp8b
         FAv350pYhHk1L7GaNKcFbR2Ti54nHn0eqb/zzb9ABRY2bdSGl5MHh8QN5HMKW/YmAQsN
         F/W7hV8uygULP8RYNfy2hBUXjRLteBmuEIR1j5uixtkiJBAM3lzJbujbvujPp0OydxG5
         21dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2R4BbQCpkO9YBouwmBRKUyTxHnROMBCPNNTzvr+bTs=;
        b=O4qRZNcPOiSIw2Iq1IBrg8bjo5Zm1WFXJKsvKYC2q2IuMhLNDyScNLqcZQ/lM+RJNr
         1NZSARbfgZGlsLZ6WYCkkf0ltuEwrMeLRlFRCb35Buolyqq9l0nHNKUEqIGOkILVneXZ
         PY9Du0OSc2K6a+cn4ANy1K9FlX2wsM/o7LRvSstV91Z4AsDc1aa5cCekhQddTXJlQjxf
         Wn/l9yIzRXbrjMi9CYvpMcQeglW0MXoSevzeHe/P51HgECAYpIW528fHlv9YTUxG3BRd
         eZeQTaoO4bfkjE04UlYbZFDbBZLXafK6nUXjh2qDK3px+M6Z1uy2MhDoz+HGY7+Bp7BO
         LD/A==
X-Gm-Message-State: AOAM530TN7yqUzyNDigFB8h/ujsXqIZJDE+q5U9/2ev85X9/9l9M/p8G
        XKJl8ndpQeNmbe6hPHvC/LyYRgDQxYRQnK80Gj5ZZQ==
X-Google-Smtp-Source: ABdhPJyKkUGNp5ptVTQH/y3fdaO8WHD96bnV/Avp1SQ7JFU5f6ksIk+NGtCwlONjNfoJPAp1skv4dkqV7brJ0Qje4qs=
X-Received: by 2002:a05:6808:8c8:: with SMTP id k8mr1163796oij.84.1606371648249;
 Wed, 25 Nov 2020 22:20:48 -0800 (PST)
MIME-Version: 1.0
References: <20201119060904.463807-1-drosen@google.com> <20201119060904.463807-3-drosen@google.com>
 <20201122051218.GA2717478@xiangao.remote.csb> <X7w9AO0x8vG85JQU@sol.localdomain>
 <877dqbpdye.fsf@collabora.com>
In-Reply-To: <877dqbpdye.fsf@collabora.com>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Wed, 25 Nov 2020 22:20:37 -0800
Message-ID: <CA+PiJmQ8-Qxu7yNWBvRLAeGa31PT5=hsYCcoW9QKsKnJQXqnMQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] fscrypt: Have filesystems handle their d_ops
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

>
> This change has the side-effect of removing the capability of the root
> directory from being case-insensitive.  It is not a backward
> incompatible change because there is no way to make the root directory
> CI at the moment (it is never empty). But this restriction seems
> artificial. Is there a real reason to prevent the root inode from being
> case-insensitive?

> I don't have a use case where I need a root directory to be CI.  In
> fact, when I first implemented CI, I did want to block the root directory
> from being made CI, just to prevent people from doing "chattr +F /" and
> complaining afterwards when /usr/lib breaks.
>
> My concern with the curent patch was whether this side-effect was
> considered, but I'm happy with either semantics.
>
> --
> Gabriel Krisman Bertazi

That's just from the lost+found directory right? If you remove it you
can still change it, and then add the lost+found directory back. Isn't
that how it works currently? I definitely didn't intend to change any
behavior around non-encrypted casefolding there.

I should look at what fsck does if you do that and have a LoSt+fOuNd folder...


-Daniel Rosenberg
