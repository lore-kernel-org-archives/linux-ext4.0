Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E812C282CE
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 05:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30742073F
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 05:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ioIki42a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfDOFn7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 01:43:59 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40982 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfDOFn7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Apr 2019 01:43:59 -0400
Received: by mail-lf1-f66.google.com with SMTP id t30so12027006lfd.8;
        Sun, 14 Apr 2019 22:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/c+Hw5+k/azU8PvnxKFqYmJEScc8yTKsIrOq90KcNSI=;
        b=ioIki42aQJHfE8Z4YokPbljBrYNgoYz9Nf0Cc206GZusD6gjAIzI28wJbEZBUIKR0x
         PsSFzKpzb9INhNuwNO+nBgVpGJ1uqna8NrizyAbxNfGbUI2LkkhlraXK3tnM/qpaKrzD
         bGe8jQ9oRCQB5i+kZ/dwlOP62bXCQBJrNA021hAJJe78QJ/fwHvH9yf7NyGI5fPxBOty
         oBdQz0JqexEk5ZAzaCVCmujySd0vzIT3mi6HCeFfv9ZFsJVqV/vs7BPjstAmOy5wMd59
         wbKXEEvKPJ273T+F4phTZUAiqeRrVLAAICwnq8VmmoGODBWLXdq1ITD/CZVR5fjUsKkt
         A+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/c+Hw5+k/azU8PvnxKFqYmJEScc8yTKsIrOq90KcNSI=;
        b=Poo36XdHiCWAT7JTmJv3cjGNctUbI3jh36ge3JMGLn2qftBtXf+ZcVAyxUV0xkEDqf
         oP6SfYfZ7gZoSUY90HL2GSc2JXVgUQk7K3FC1WA1jkogEYXYJF+l8FHoujDSuadF3/0S
         u7l+KgtFxtYCS5SB2VxUs3W7sh4A4booXaZSXwlBwcfCqrB0+46YweFzPUZ4RJdIL8oh
         1qN/TjQkZcvX3Vl+ERkubdMYZHB9Cv9mDGGErLb8vhQwhMpkcRH77hBOjKhQXNcBMFdE
         37y3TbW6qbJRfU9DdVXB0TRpDa3RzpCsbepN4nwUEqWeNXaLUhe/M7Cl5XQuPeWuNZIa
         pgMw==
X-Gm-Message-State: APjAAAWCggU093PIkzt617iL1vYvDIK216eOV3bQ+yMVwfJ0hcq+tEd5
        4NHXP1EQf9JtawUTx1z4NG0FXgm9bnRMrNhPRRM=
X-Google-Smtp-Source: APXvYqz5KJTKzNAp0YVyNvmQJpO1OyGfuUarw6cWCWeFUfRpXA51WDRxn5UL/u/lq4P5E+TmUPismgSWGwO2+n4/ick=
X-Received: by 2002:ac2:59db:: with SMTP id x27mr32758509lfn.108.1555307036239;
 Sun, 14 Apr 2019 22:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
In-Reply-To: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 14 Apr 2019 22:43:44 -0700
Message-ID: <CAADnVQKx5WrUYxr_gSc5ai=fJh2cM9e26NZL1mRPkoSVQxAd0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] include: linux: Regularise the use of FIELD_SIZEOF macro
To:     Shyam Saini <shyam.saini@amarulasolutions.com>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Network Development <netdev@vger.kernel.org>,
        linux-ext4@vger.kernel.org, devel@lists.orangefs.org,
        linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org,
        mayhs11saini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 14, 2019 at 2:15 AM Shyam Saini
<shyam.saini@amarulasolutions.com> wrote:
>
> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
>
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h
>
> Signed-off-by: Shyam Saini <shyam.saini@amarulasolutions.com>
> ---
>  arch/arm64/include/asm/processor.h                 | 10 +++++-----
>  arch/mips/cavium-octeon/executive/cvmx-bootmem.c   |  2 +-
>  drivers/gpu/drm/i915/gvt/scheduler.c               |  2 +-
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |  4 ++--
>  fs/befs/linuxvfs.c                                 |  2 +-
>  fs/ext2/super.c                                    |  2 +-
>  fs/ext4/super.c                                    |  2 +-
>  fs/freevxfs/vxfs_super.c                           |  2 +-
>  fs/orangefs/super.c                                |  2 +-
>  fs/ufs/super.c                                     |  2 +-
>  include/linux/kernel.h                             |  9 ---------
>  include/linux/slab.h                               |  2 +-
>  include/linux/stddef.h                             | 11 ++++++++++-
>  kernel/fork.c                                      |  2 +-
>  kernel/utsname.c                                   |  2 +-
>  net/caif/caif_socket.c                             |  2 +-
>  net/core/skbuff.c                                  |  2 +-
>  net/ipv4/raw.c                                     |  2 +-
>  net/ipv6/raw.c                                     |  2 +-
>  net/sctp/socket.c                                  |  4 ++--
>  tools/testing/selftests/bpf/bpf_util.h             | 11 ++++++++++-

tools/ directory is for user space pieces that don't include kernel's include.
I bet your pathes break the user space builds.
