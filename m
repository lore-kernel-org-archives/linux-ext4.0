From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] fscrypt: use 32 bytes of encrypted filename
Date: Wed, 19 Apr 2017 15:41:33 +0200
Message-ID: <CAFLxGvzFLkLAhgE3ZEzH_80=onrdSHN0ue7Qjv17mkMv+eRSEQ@mail.gmail.com>
References: <20170418210642.6039-1-gwendal@chromium.org> <CAFLxGvz+kODD+8s9aPw_DeYtf3Gjv0aQBC=UfoBFx3Wn2b=wxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kinaba@chromium.org,
        hashimoto@chromium.org
To: Gwendal Grignou <gwendal@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34927 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763705AbdDSNle (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Apr 2017 09:41:34 -0400
In-Reply-To: <CAFLxGvz+kODD+8s9aPw_DeYtf3Gjv0aQBC=UfoBFx3Wn2b=wxQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 19, 2017 at 3:37 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> Can the code still be able to read filenames which have been encrypted
> using the "old" scheme?

Bah, typing is hard.
Should be read: Will the code still be able to read ...

-- 
Thanks,
//richard
