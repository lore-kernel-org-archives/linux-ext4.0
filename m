From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Wed, 19 Oct 2016 10:36:00 -0700
Message-ID: <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, kzak@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36817 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbcJSRgW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2016 13:36:22 -0400
Received: by mail-qt0-f178.google.com with SMTP id m5so29249186qtb.3
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2016 10:36:21 -0700 (PDT)
In-Reply-To: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 19, 2016 at 4:35 AM, Richard Weinberger <richard@nod.at> wrote:
> Hi!
>
> Since file level encryption has more than one user, currently ext4, f2fs and soon ubifs
> it would be nice to have a single tool to control fscrypto from userspace.
>
> For ext4 we have already at least two tools, one as part of e2fsprogs and another
> one on github[0]. IMHO the latter one is much more user friendly and intuitive to use.
> I as unable to find the userspace tool for f2fs.
>
> That said, what about implementing such a tool as part of util-linux to control
> fscrypto? We (David and I) would volunteer.

While discussing several changes we have staged for release (we're
trying to minimize churn by batching a large set of format changes all
at once), we've recently recognized this need on my team and were
planning on starting work on exactly what you propose.

> Thanks,
> //richard
>
> [0] https://github.com/gdelugre/ext4-crypt
