Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39170 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbeLIUKq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 9 Dec 2018 15:10:46 -0500
Date: Sun, 9 Dec 2018 15:10:43 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
Message-ID: <20181209201043.GA1840@mit.edu>
References: <20181206230903.30011-1-krisman@collabora.com>
 <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <20181209050326.GA28659@mit.edu>
 <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgLYy3pRFDxwXB1THf4ev2C6VOmK5m7tfSwwv+EC9pM3Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 09, 2018 at 09:41:13AM -0800, Linus Torvalds wrote:
> But if you only support ascii or utf-8, then why are you messing with
> the nls part? That makes no sense.
> 
> You can't have it both ways.
> 
> Either you have a horrible fundamental design mistake that has
> different per-filesystem locales, or you don't.
> 
> If you don't, you shouldn't be touching any of the nls code.
> 
> Whatever unicode tables you use for case folding shouldn't be in the nls code.

Gabriel added the Unicode tables for case folding to the fs/nls
directory.  If you'd prefer that we put them somewhere else, we
can; do you have a preference?

					- Ted
