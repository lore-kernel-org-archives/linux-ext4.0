From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Tue, 30 Aug 2016 17:03:11 +0200
Message-ID: <8bcabb36-468a-f801-99a5-5bbf2339c026@physik.fu-berlin.de>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
 <20160830145810.rgms25xlnatnyxir@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Anatoly Pugachev <matorola@gmail.com>, linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:54325 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755534AbcH3PDQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Aug 2016 11:03:16 -0400
In-Reply-To: <20160830145810.rgms25xlnatnyxir@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted!

On 08/30/2016 04:58 PM, Theodore Ts'o wrote:
> Since you are able to provke this in a debugger, can you have gdb
> print out the value of bh->b_data and offset, so we can be sure what's
> going on?

Since you're a Debian Developer yourself, you have access to the sparc64
porterbox I have set up. If you're interested, please feel free to use
notker [1] for any tests and debugging sessions.

Although I'm sure that Anatoly will follow up with your questions anyway.

Thanks,
Adrian

> [1] https://db.debian.org/machines.cgi?host=notker

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
