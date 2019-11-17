Return-Path: <SRS0=rNMj=ZJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE65C432C0
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Nov 2019 01:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FFA206D6
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Nov 2019 01:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573954424;
	bh=TuZEBS3BGkg1+h4fg3BpHM79M3TKTBqF1gE4HKOwcDQ=;
	h=In-Reply-To:References:Cc:To:Subject:From:Date:List-ID:From;
	b=VBFMXkhfb+XgrG2lg4bdyTKwD75DIY8DaG6geFsGg+7G8ea+6ghqs0klEgOMQAxxN
	 GKqGu9/g8fTzz/psuBJI6kOmbTpOtKl76MHWHywUei+/4HnLA2FOa3vmy42BmWMUkK
	 xPUYoKIjagRgOsx6G7p8ghpBp1e4La8duKn0JgW8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfKQBdi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Nov 2019 20:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfKQBdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 16 Nov 2019 20:33:37 -0500
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23F820730;
        Sun, 17 Nov 2019 01:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573954417;
        bh=TuZEBS3BGkg1+h4fg3BpHM79M3TKTBqF1gE4HKOwcDQ=;
        h=In-Reply-To:References:Cc:To:Subject:From:Date:From;
        b=xFHFW1nj7Q6pEsL8oOoBi1KkpYh+XvbwxjZSKWEqInpUsAOvxJSGpWG4IN6lqV5Me
         HBhjWHR2bHWeASsjr22YUskVlvOMUzRB1YpJHLM/HZ43b+G+Mgq2vpQOWsha6eH9Cy
         KbauVRTDrhe6QYuyz50xjbNcBGFu7RunUH75Z/Tc=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1573812972-10529-2-git-send-email-alan.maguire@oracle.com>
References: <1573812972-10529-1-git-send-email-alan.maguire@oracle.com> <1573812972-10529-2-git-send-email-alan.maguire@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com,
        keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, yamada.masahiro@socionext.com,
        catalin.marinas@arm.com, joe.lawrence@redhat.com,
        penguin-kernel@i-love.sakura.ne.jp, schowdary@nvidia.com,
        urezki@gmail.com, andriy.shevchenko@linux.intel.com,
        corbet@lwn.net, tytso@mit.edu, adilger.kernel@dilger.ca,
        mcgrof@kernel.org, changbin.du@intel.com,
        linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>,
        Knut Omang <knut.omang@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>, brendanhiggins@google.com,
        linux-kselftest@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: [PATCH v4 linux-kselftest-test 1/6] kunit: move string-stream.h to lib/kunit
From:   Stephen Boyd <sboyd@kernel.org>
User-Agent: alot/0.8.1
Date:   Sat, 16 Nov 2019 17:33:36 -0800
Message-Id: <20191117013336.F23F820730@mail.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Quoting Alan Maguire (2019-11-15 02:16:07)
> string-stream interfaces are not intended for external use;
> move them from include/kunit to lib/kunit accordingly.
>=20
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Knut Omang <knut.omang@oracle.com>

The sign off chain is incorrect here. Is Knut tag supposed to be
Co-developed-by?=20

> diff --git a/include/kunit/assert.h b/include/kunit/assert.h
> index db6a0fc..ad889b5 100644
> --- a/include/kunit/assert.h
> +++ b/include/kunit/assert.h
> @@ -9,10 +9,11 @@
>  #ifndef _KUNIT_ASSERT_H
>  #define _KUNIT_ASSERT_H
> =20
> -#include <kunit/string-stream.h>
>  #include <linux/err.h>
> +#include <linux/kernel.h>

Why is this included now?

> =20
>  struct kunit;
> +struct string_stream;
> =20
>  /**
>   * enum kunit_assert_type - Type of expectation/assertion.
