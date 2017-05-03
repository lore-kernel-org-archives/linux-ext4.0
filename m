From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: kernel BUG at fs/buffer.c:3102! (nbd disc.)
Date: Wed, 3 May 2017 11:42:57 +0200
Message-ID: <CAOMGZ=EgYJF-LGBQMi38GDOV9fQLUYO4tYmeYdkgrAJAGrX5UQ@mail.gmail.com>
References: <CAGmahrRy2A2SRFGjObwUcVe3gOnsj0qj3cpADesxbf3ASTKD6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sverd Johnsen <sverd.johnsen@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32852 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdECJnA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 May 2017 05:43:00 -0400
Received: by mail-wr0-f193.google.com with SMTP id w50so21803168wrc.0
        for <linux-ext4@vger.kernel.org>; Wed, 03 May 2017 02:42:59 -0700 (PDT)
In-Reply-To: <CAGmahrRy2A2SRFGjObwUcVe3gOnsj0qj3cpADesxbf3ASTKD6Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3 May 2017 at 11:27, Sverd Johnsen <sverd.johnsen@googlemail.com> wrote:
> Hi. used ext4 via nbd and the client died on me because of a silly
> mistake. Got something in dmesg. Not sure if this is even a "real" bug
> or just sort of expected to happen in this scenario or not but I
> figure i would post it anyway.
>
[...]
> kernel: Aborting journal on device nbd0-8.
> kernel: ------------[ cut here ]------------
> kernel: kernel BUG at fs/buffer.c:3102!

Hi,

I'm thinking this was probably fixed in v4.11 by

commit abbbdf12497d36b001e0865bc5bc6cc363f3a5e1
Author: Ratna Manoj Bolla <manoj.br@gmail.com>
Date:   Fri Mar 24 14:08:29 2017 -0400

    nbd: replace kill_bdev() with __invalidate_device()


Vegard
