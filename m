From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 3/4] ubifs: don't bother checking for encryption key in ->mmap()
Date: Tue, 23 May 2017 16:14:20 +0200
Message-ID: <CAFLxGvxaiWFKH5L_BwPXGuG9PxA+0BkJ1qMvaDgAeVwBw+nCoQ@mail.gmail.com>
References: <20170523003945.14279-1-ebiggers3@gmail.com> <20170523003945.14279-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fscrypt@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35680 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935930AbdEWOOX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 10:14:23 -0400
In-Reply-To: <20170523003945.14279-4-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 23, 2017 at 2:39 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Since only an open file can be mmap'ed, and we only allow open()ing an
> encrypted file when its key is available, there is no need to check for
> the key again before permitting each mmap().
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
