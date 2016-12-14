From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for 4.10
Date: Wed, 14 Dec 2016 09:20:43 -0800
Message-ID: <CA+55aFzpr1r7MywLFGNyxRSkzwj7G8N2AdGNM22-poLMMv5QQw@mail.gmail.com>
References: <20161213200007.jczekmqmtknxkfix@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34737 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933086AbcLNRUo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Dec 2016 12:20:44 -0500
In-Reply-To: <20161213200007.jczekmqmtknxkfix@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ Johannes added to participants due to radix tree changes ]

On Tue, Dec 13, 2016 at 12:00 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> This merge request includes the dax-4.0-iomap-pmd branch which is
> needed for both ext4 and xfs dax changes to use iomap for DAX.  It
> also includes the fscrypt branch which is needed for ubifs encryption
> work as well as ext4 encryption and fscrypt cleanups.

Can you double-check my merge resolution with the radix tree changes
wrt the DAX changes, please? It looked straightforward, but it's an
area where I'd really like people to actually look again and test..

Thanks,

               Linus
