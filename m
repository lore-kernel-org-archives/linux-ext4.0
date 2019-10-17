Return-Path: <SRS0=wmfg=YK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAC3CA9EC8
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Oct 2019 23:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB8F21D7C
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Oct 2019 23:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="krIzKB/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438548AbfJQX1m (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Oct 2019 19:27:42 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38971 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389107AbfJQX1m (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Oct 2019 19:27:42 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so3574637qki.6
        for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2019 16:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUuoIZ98ONzVxfZS360lAsjvw5uM1s/8vVWt8csbw30=;
        b=krIzKB/TPn8CMuxiyBnwuMhxR6abLWjMDKtwJrFup5JXCkSb/NQ5BFJ6iKDc8yC4cp
         LufEjo1SWjFO4T4TG2W7Sp6JHCi/mupjh3DPW51H+XGnvdB15Xu8N2PfAlUhjC8SuD0t
         uJW+F/6l827WxRyNV8IwjphvxM0iTELgXGwRimEpdnzBn7fkW8Uj4i6+d9DMJHv4A2qw
         McBDgNOFTb+6MgYq3tF0mZVZWVQHYs3zYY8ERKodcncc/qNgcJu0tEY6jMkuc0f/xgdO
         gcZ0KxtjBfwkuVcEo8+mOF3m84qqwjIMVqYodP08/BRGLQLyBwd9HoZYcriUdOsP/07n
         r/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUuoIZ98ONzVxfZS360lAsjvw5uM1s/8vVWt8csbw30=;
        b=YtCAGTjsRt7cz181ZhBhSLl0/5jDMRJsTPZJ9B6ShKZbRU6h2UASFABlMf7lrqYzqj
         /P9sbaV6WA2sml1yTpnRUO7FsxHl6ooTyqMFcxTL+fEEvmP7MmFPPkRGxh8+U80lVCRb
         jEFi0nc6MdYNtOU2vqac/+rUUOtSam1hEKkmjFgv+rLAbalDRcAKqtDg2oPyJLc3ipsw
         ZPzif1wbk6kbezAbyosDvANuR8buAj38eWvbw+WXr0UTEzCBGuzE7t3CIGkzogb6KUOi
         dJCyqnjsQWwyAwg5guDTft8TEFkAXWSXPVTb2LfJza96ZDePaQRwA4xxbRQXS/PyMXbD
         SIWA==
X-Gm-Message-State: APjAAAXP8LkBIzSJqwj5jtUwMi0Rpke7kiwQXjlLZpmuC60CKQ7L3zVQ
        AxsvRejnhvW4s1GL9JeTSddA8mviCUD5Q1DSGewq
X-Google-Smtp-Source: APXvYqxS4kj6UtGvMthKpyYl6i9PIh7TxBerdY9osXCoPDYr5kZ2vghq8fb1Dr2WCGRfW3tBX17PKgHAy+zLPkJzg/4=
X-Received: by 2002:a37:348:: with SMTP id 69mr5900509qkd.28.1571354861410;
 Thu, 17 Oct 2019 16:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191010023931.230475-1-yzaikin@google.com> <2f2ea7b0-f683-1cdd-f3f2-ecdf44cb4a97@linuxfoundation.org>
 <CAAXuY3qtSHENgy3S168_03ju_JwAucOAt5WEJGQ+pi5PfurP6g@mail.gmail.com>
 <CAFd5g46RcFV0FACuoF=jCSLzf7UFmEYn4gddaijUZ+zR_CFZBQ@mail.gmail.com>
 <20191011131902.GC16225@mit.edu> <CAFd5g45s1-=Z4JwJn4A1VDGu4oEGBisQ_0RFp4otUU3rKf1XpQ@mail.gmail.com>
 <1e6611e6-2fa6-6f7d-bc7f-0bc2243d9342@linuxfoundation.org>
 <20191017120833.GA25548@mit.edu> <957434b6-32cc-487f-f48e-f9c4416b3f60@linuxfoundation.org>
 <CAAXuY3r7Eu+o-td8MRvexGYmONPgd8FvHr+7mF84Q4ni1G3URg@mail.gmail.com> <40073fc9-1de1-9253-e2f9-9cf9ee4308d4@linuxfoundation.org>
In-Reply-To: <40073fc9-1de1-9253-e2f9-9cf9ee4308d4@linuxfoundation.org>
From:   Iurii Zaikin <yzaikin@google.com>
Date:   Thu, 17 Oct 2019 16:27:05 -0700
Message-ID: <CAAXuY3r7QKSuwVYDQhF8-zC75ZRVHr+4pzpGXeNbPaEdbM3h4Q@mail.gmail.com>
Subject: Re: [PATCH linux-kselftest/test v2] ext4: add kunit test for decoding
 extended timestamps
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Brendan Higgins <brendanhiggins@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca,
        KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> You can do all of this and allow users to supply another set of data.
> It doesn't gave to be one or the other.
>
What is the use case for running a unit test on a different data set than
what it comes with?
