Return-Path: <SRS0=YMbR=ZL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77488C432C3
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 18:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C6D620721
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 18:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCduduS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKSSsN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Nov 2019 13:48:13 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44571 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKSSsN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2019 13:48:13 -0500
Received: by mail-pf1-f193.google.com with SMTP id q26so12606941pfn.11
        for <linux-ext4@vger.kernel.org>; Tue, 19 Nov 2019 10:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=36jpGIQcZ4lU6TqRvBSPN3Oc7gVUnBFQ0lBJ+9WKKcg=;
        b=kCduduS8sUz7ZMjCUdC5gY5VD/uZm5eD+8jxwwMRL6DFz4MIafJkNv4XkD0U2xp20S
         ixo4VwHZtd76EFCFueeKOEIVmlVl5As75mVIQLGELq4LCap/sRuvvfgW2YYrLk9UArvI
         9OdAQgnqi5kYsmFXVB2E6b6NZU6KCSBNtzLNw5D+/rEkgOzgDQ7OefR+PCPXQVBDN3rp
         jVHpMuoRusV1L2X4KhI1ANNExs/nJG8rpdqMNI4wPDUywevajs1M4wQ+P+bxfiPggP/y
         eyVtu7WJHbSxbS09MX8/DvcOf2I51yTSrmKEhgGzN3mpKe4qjtUREEzdGFBDLV0iX5X0
         hktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=36jpGIQcZ4lU6TqRvBSPN3Oc7gVUnBFQ0lBJ+9WKKcg=;
        b=K4F9qlNcY6NSKr3AREx+6JzmmVnIss4dSwSHoRJUn2GavU9fHyup6KGfaLkn+Hcr9r
         kbpO3HP2miQsWTqhUk+8cxrukqt+tS2NEJ6T+XACIGovQgb8WRI24yntU5Kl4xP4p614
         3dQkb/rXuGac9sZwSqbTsqwnYQNCiLLG9lUdf4m1aUzSyDwqcz7yNMOOVjx1627D93QY
         WMeWJCJve941TdgxsDVj1i6jqCKY8zkZZeqNxUs+Tq+2WjGk53N2UyE77e5uziji4h/L
         UU4/8NI/zFkm0bjUvaTDkpRIbudPBzKAES8jIlk8oe7ziymNWA1DbFc7K1APpK82AMRe
         XFLg==
X-Gm-Message-State: APjAAAWBoCjbRgDPSDJAzyrNEJDnHmvpreLwrJ4M/asgoV6StcG+M/kj
        64jQ5Ri6xyC37/ICjGks05OP9bezkd/gmBm1vrmOww==
X-Google-Smtp-Source: APXvYqyO0WMb0y6EdLj/2mxu5pbnY05u1W4YT8PJ6G6+TwoxewCaTUmBLujPNM+Ngg6p0Nx1tBw0sbvWbk6Wp2rW+CA=
X-Received: by 2002:a63:712:: with SMTP id 18mr1286147pgh.384.1574189292526;
 Tue, 19 Nov 2019 10:48:12 -0800 (PST)
MIME-Version: 1.0
References: <1573812972-10529-1-git-send-email-alan.maguire@oracle.com> <1573812972-10529-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1573812972-10529-3-git-send-email-alan.maguire@oracle.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Tue, 19 Nov 2019 10:48:01 -0800
Message-ID: <CAFd5g47f3-k+VxNRAJgfZ=Xr_bMD8huEkKj42U7ybMtb18pbSw@mail.gmail.com>
Subject: Re: [PATCH v4 linux-kselftest-test 2/6] kunit: hide unexported
 try-catch interface in try-catch-impl.h
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        catalin.marinas@arm.com, joe.lawrence@redhat.com,
        penguin-kernel@i-love.sakura.ne.jp, schowdary@nvidia.com,
        urezki@gmail.com, andriy.shevchenko@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        Luis Chamberlain <mcgrof@kernel.org>, changbin.du@intel.com,
        linux-ext4@vger.kernel.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Nov 15, 2019 at 2:17 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Define function as static inline in try-catch-impl.h to allow it to
> be used in kunit itself and tests.  Also remove unused
> kunit_generic_try_catch
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>

Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>

Aside from Stephen's comment, this looks good to me.
