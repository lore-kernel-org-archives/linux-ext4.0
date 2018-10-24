Return-Path: <SRS0=Qv/7=NE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-ed1-f41.google.com ([209.85.208.41]:34104 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbeJYBN4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2018 21:13:56 -0400
Received: by mail-ed1-f41.google.com with SMTP id w19-v6so5719020eds.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2018 09:45:08 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id f3-v6sm1862465edb.58.2018.10.24.09.45.06
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 09:45:06 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id s10-v6so4047684wmc.5
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2018 09:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20181024144735.GA28816@thunk.org>
In-Reply-To: <20181024144735.GA28816@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Oct 2018 17:44:47 +0100
Message-ID: <CAHk-=wgtz3Xamn_RT0hzBbEhsXyB2yWJ_M4vCRnJRT1du-otdw@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 4.20-rc1
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 24, 2018 at 3:47 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Further restructure ext4 documentation; fix up ext4's delayed
> allocation for bigalloc file systems; fix up some syzbot-detected
> races in EXT4_IOC_MOVE_EXT, EXT4_IOC_SWAP_BOOT, and ext4_remount; and
> a few other miscellaneous bugs and optimizations.

Thanks, pulled,

               Linus
