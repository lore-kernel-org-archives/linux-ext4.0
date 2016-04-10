From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sun, 10 Apr 2016 13:32:59 -0700
Message-ID: <CA+55aFxzp-A_E5twKqbOFYgLZH8O7Z0wW3nCAg_U9KWNgHFAXQ@mail.gmail.com>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
	<CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34966 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbcDJUdB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2016 16:33:01 -0400
In-Reply-To: <CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 10, 2016 at 1:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  (b) to get the latency advantage, do something like this:
>
>      +               if (signal_pending)
>      +                       return -EINTR;

That should be

     if (signal_pending())
        return -EINTR;

of course. Missing function call parenthesis..

I'm just testing that people are awake.

           Linus
