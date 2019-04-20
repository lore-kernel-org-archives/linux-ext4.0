Return-Path: <SRS0=ddXr=SW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6ACC282E2
	for <linux-ext4@archiver.kernel.org>; Sat, 20 Apr 2019 10:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C651C2087F
	for <linux-ext4@archiver.kernel.org>; Sat, 20 Apr 2019 10:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwO+gArl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfDTKvO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 20 Apr 2019 06:51:14 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43770 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfDTKvN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Apr 2019 06:51:13 -0400
Received: by mail-qk1-f194.google.com with SMTP id p19so1762402qkm.10;
        Sat, 20 Apr 2019 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kaS+veCYE7ao8csQbi/ZAdwFn2xeuMRJDTxk7kh9MmQ=;
        b=EwO+gArlEBVQK/nJT5vZKE02dfSFFoeHd/43vZOndrjFwkjrhjJgbW66CULGd/qp8M
         CAKK4/fa+yfKDft5ldNSlPt0B6rGPqndRHkFtb4MayLgZRwIeW+bjjxZxoS2RPm+NmrM
         5J8qu7sm0tvit9z1Ptm9VeGVZYEOilIUa4FqMFKftvJ8C1sr9isBTWCvBqkSLuRkQFnC
         /JfrzCUu4i4VMVxMXiNW5Pt1t1KcV3H7PonI7MF2Vn8rgAvwSZzAmsvqnBS5yxoNSCFk
         Cki0HCuHLWy/0V7zOngTErhlDLx+7wgLUrHt9aXGhXBRdZrcx1OCpXV7iZBdhZmXdUlW
         Hvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kaS+veCYE7ao8csQbi/ZAdwFn2xeuMRJDTxk7kh9MmQ=;
        b=h9tMq1rT3zIKjiFSfQs4Fc7ZxbpRAZuPUxAp8xJfDC8aIa1spnUR6LIPs4pfVA3SDn
         Sej76RQ2aXoaKkRoRx+GNVwpt88m8C/M0elJn89D34I/LJkflfzqEQERw6p4PYxEzIwU
         oEu2mWZcgRKqey6Lo3/dXHcXRb/Ze9dJo9ZkhcKtNXkkZssWeVdMhPj68ApjD3iHPdMn
         PshhtX1tiXEgqxauhBZBsbwYa2Zj3vmdOlgnFLvBQZ61l+RsLIZ4j3s6ARUD9eKYjjEx
         QwyjQ+/znKxwvC+o93Q/JMNuV3094rxdqAoKyHZRdCyNDwH4NZH6CKrsMFhkRbfWVeUt
         h/bQ==
X-Gm-Message-State: APjAAAWULUlE87g9p7a7GnkpjZupZPsqTqrCc2IrWvr/zq79XPTaKAKj
        qg6Up6xFCh0UgQesjQCfpD5iTaqs1mEmGtqfAIc=
X-Google-Smtp-Source: APXvYqwATcAIlW4nr9QShhMxeCWgd4J//S9gB2/UnHehq87+pPLyQ1o9lMaZFrSTSc7CUnr7ubTUZZuLbaGHeINqWkU=
X-Received: by 2002:a37:6886:: with SMTP id d128mr907042qkc.158.1555757472269;
 Sat, 20 Apr 2019 03:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com> <C398B8C9-6A54-4590-AA88-58D514BAEB71@oracle.com>
In-Reply-To: <C398B8C9-6A54-4590-AA88-58D514BAEB71@oracle.com>
From:   Shyam Saini <mayhs11saini@gmail.com>
Date:   Sat, 20 Apr 2019 16:21:00 +0530
Message-ID: <CAOfkYf7vn7UnYzZDh9==agVu61sYyFWzvo6hQBt3KfaKrWC-6Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] include: linux: Regularise the use of FIELD_SIZEOF macro
To:     William Kucharski <william.kucharski@oracle.com>
Cc:     Shyam Saini <shyam.saini@amarulasolutions.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-ext4@vger.kernel.org, devel@lists.orangefs.org,
        linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi William,

Sorry for the late reply.

> > Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> > and FIELD_SIZEOF which are used to calculate the size of a member of
> > structure, so to bring uniformity in entire kernel source tree lets use
> > FIELD_SIZEOF and replace all occurrences of other two macros with this.
> >
> > For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> > tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> > include/linux/kernel.h
>
>
> > --- a/include/linux/stddef.h
> > +++ b/include/linux/stddef.h
> > @@ -20,6 +20,15 @@ enum {
> > #endif
> >
> > /**
> > + * FIELD_SIZEOF - get the size of a struct's field
> > + * @t: the target struct
> > + * @f: the target struct's field
> > + * Return: the size of @f in the struct definition without having a
> > + * declared instance of @t.
> > + */
> > +#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
> > +
> > +/**
> >  * sizeof_field(TYPE, MEMBER)
> >  *
> >  * @TYPE: The structure containing the field of interest
> > @@ -34,6 +43,6 @@ enum {
> >  * @MEMBER: The member within the structure to get the end offset of
> >  */
> > #define offsetofend(TYPE, MEMBER) \
> > -     (offsetof(TYPE, MEMBER) + sizeof_field(TYPE, MEMBER))
> > +     (offsetof(TYPE, MEMBER) + FIELD_SIZEOF(TYPE, MEMBER))
>
> If you're doing this, why are you leaving the definition of sizeof_field() in
> stddef.h untouched?

I have removed definition of sizeof_field in [1/2] patch.

> Given the way this has worked historically, if you are leaving it in place for
> source compatibility reasons, shouldn't it be redefined in terms of
> FIELD_SIZEOF(), e.g.:
>
> #define sizeof_field(TYPE, MEMBER) FIELD_SIZEOF(TYPE, MEMBER)

Actually, never thought this way. So,Thanks a lot for this valuable feedback.

I'll re-spin and post again.
