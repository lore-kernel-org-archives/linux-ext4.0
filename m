Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D43CC10F0E
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 07:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B8820693
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 07:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrwGDgB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfDOHNw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 03:13:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40634 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfDOHNw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Apr 2019 03:13:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id w20so9222115qka.7;
        Mon, 15 Apr 2019 00:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3kbi0uMsvxuG8GVHcYa0jx5Oj3tt+hVtJy5E3Znkxk=;
        b=JrwGDgB5paFkpvAjGR+HpKqcels7xSMDLHDkKHKBTJAoS/z6H9fgmh3RNxZqzc3Mbm
         QqSqZhVlA9zZVYfzKoS2GakuhjjZtcmjdzIMdIlu0qNsfmJX1jziQcZhLbENNuRRuB0U
         LHuvdr+q6ZqkE4bfgrFNqV2eswVxaVeO6uNJevx033Hh/Rd+UoimJ7G+gYtHuIeYPMWD
         X5VMK38WMr6pT61Rl5cUQWfx7lNFGQPHPF+tQM99t/6d8XLQkopXcinifQM05fzvN5bG
         Rj4dnQxCOvY7n+f5zJtyj3G9LiHzyXy1mZL7LeIKSbHI3hryRq3UU6NxFxyXvuohYpgZ
         GDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3kbi0uMsvxuG8GVHcYa0jx5Oj3tt+hVtJy5E3Znkxk=;
        b=CmI1h0q5jRfI7B6CQtMOBYAPgipGAxvfyia1v+ku+q46+tceZCLvrizUpK0QBx/f0x
         U/R0v9zGwrH+zfilu9ZuCwmdcVG5kiIE/bcrXJ9xGmx1K4FyHP1qkoqj0gPorwXTBrOG
         1c+ZFzz3i6CS+tXYjl6pE6osqH9DfuqDxIIpryTtECx/nrBjOan7d0a+dvCEI0qM7Pfq
         WuUTBq0KwAcAnDlBu8LXnTYX2VY/X/+5F5kksGCtmUcQCxAhHz/F3o70ZIvQK3inXtLG
         MbVGanqR49r6N8h8L+/V4gKdTM9MMWVUDdA7UgHOkvuR84mrxRlL0JaRmrJiugu6CUag
         6N8Q==
X-Gm-Message-State: APjAAAVi1n4spk1u+VfekM1123pFlBcF6jy1NLhZ5m/SdXDK8OD46CPt
        +UCOUd0lNzzIz3F14yi/01C1nBeEX937pdhqrss=
X-Google-Smtp-Source: APXvYqy7BiJy6sUxQsLMNeqGjVsNKTqXYv8xm887nUujgxsP1xwvfSah5gmuWcJIRxcv3C225rHZNDuC/Qf7KE3MLFo=
X-Received: by 2002:a37:4e4d:: with SMTP id c74mr56333890qkb.230.1555312430704;
 Mon, 15 Apr 2019 00:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com> <CAADnVQKx5WrUYxr_gSc5ai=fJh2cM9e26NZL1mRPkoSVQxAd0Q@mail.gmail.com>
In-Reply-To: <CAADnVQKx5WrUYxr_gSc5ai=fJh2cM9e26NZL1mRPkoSVQxAd0Q@mail.gmail.com>
From:   Shyam Saini <mayhs11saini@gmail.com>
Date:   Mon, 15 Apr 2019 12:43:39 +0530
Message-ID: <CAOfkYf5FZdN3v9pkcdNmyJM5O=789bKwFmFsMTp20RE=gVgwqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] include: linux: Regularise the use of FIELD_SIZEOF macro
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

Hi,

On Mon, Apr 15, 2019 at 11:13 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Apr 14, 2019 at 2:15 AM Shyam Saini
> <shyam.saini@amarulasolutions.com> wrote:
> >
> > Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> > and FIELD_SIZEOF which are used to calculate the size of a member of
> > structure, so to bring uniformity in entire kernel source tree lets use
> > FIELD_SIZEOF and replace all occurrences of other two macros with this.
> >
> > For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> > tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> > include/linux/kernel.h
> >
> > Signed-off-by: Shyam Saini <shyam.saini@amarulasolutions.com>
> > ---
> >  arch/arm64/include/asm/processor.h                 | 10 +++++-----
> >  arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  2 +-
> >  drivers/gpu/drm/i915/gvt/scheduler.c               |  2 +-
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |  4 ++--
> >  fs/befs/linuxvfs.c                                 |  2 +-
> >  fs/ext2/super.c                                    |  2 +-
> >  fs/ext4/super.c                                    |  2 +-
> >  fs/freevxfs/vxfs_super.c                           |  2 +-
> >  fs/orangefs/super.c                                |  2 +-
> >  fs/ufs/super.c                                     |  2 +-
> >  include/linux/kernel.h                             |  9 ---------
> >  include/linux/slab.h                               |  2 +-
> >  include/linux/stddef.h                             | 11 ++++++++++-
> >  kernel/fork.c                                      |  2 +-
> >  kernel/utsname.c                                   |  2 +-
> >  net/caif/caif_socket.c                             |  2 +-
> >  net/core/skbuff.c                                  |  2 +-
> >  net/ipv4/raw.c                                     |  2 +-
> >  net/ipv6/raw.c                                     |  2 +-
> >  net/sctp/socket.c                                  |  4 ++--
> >  tools/testing/selftests/bpf/bpf_util.h             | 11 ++++++++++-
>
> tools/ directory is for user space pieces that don't include kernel's include.
> I bet your pathes break the user space builds.

I think it shouldn't because I haven't included any kernel header in
tool/ files, instead
I have introduced definition of macro in tool/ , so this patch doesn't
create any dependency
on kernel headers.

Thanks a lot,
Shyam
