From: thanumalayan mad <madthanu@gmail.com>
Subject: Re: e2fsck exit codes
Date: Wed, 15 Feb 2017 13:44:15 -0800
Message-ID: <CAJ6LpRop10zedV_ZGkBNfzTUVTMHZmndWOqbxBNtnEW1oD==Kw@mail.gmail.com>
References: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
 <20170214170101.irgf4uvvvbbepmip@thunk.org> <CAJ6LpRpe6KfwoWvCw6cDwWg6=BxtcbXnSjLN358OgZ2obGcxsQ@mail.gmail.com>
 <20170215154427.26pb74jy6ynrdqvo@thunk.org>
Reply-To: madthanu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33356 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbdBOVoh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Feb 2017 16:44:37 -0500
Received: by mail-oi0-f50.google.com with SMTP id w204so93826362oiw.0
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 13:44:36 -0800 (PST)
In-Reply-To: <20170215154427.26pb74jy6ynrdqvo@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thank you for replying, again.

On Wed, Feb 15, 2017 at 7:44 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> What are you trying to _do_ by, at the high level?
>
> It should do what you want, but at this point I'm wondering _why_ you
> want to do it, and whether or not it is something you _should_ be
> doing.

I probably have an odd usecase. I am trying to evaluate whether a new
storage stack (i.e., a virtual disk) is good enough for running an
application service; the service can frequently encounter crash
reboots, and the storage stack should be reliable enough. After
testing the service out on the new stack for a while with induced
crash-reboots, I began to suspect corruption in the stack, probably
caused during crashes. I was hoping I could catch the corruption
early-on, and make the testcase more repeatable, if I used "fsck -f"
during the testing. The other ideas I tried out to detect corruption
(like adding data checksums within the service) were funnily even
harder to get right.

Thanks,
Thanu
