From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: building ext2simg
Date: Mon, 9 Oct 2017 08:59:02 -0400
Message-ID: <20171009125902.66u7hsgxsueedquq@thunk.org>
References: <CAP71WjzSUxbK1mpv_bTuZd6W4xV2zNEEQN0GtmEp7iMTyhi9zA@mail.gmail.com>
 <20171008212752.ljga227riyq7exzb@thunk.org>
 <CAP71WjwVdqmLEq1NGWK36JkEd-i05YcAu4jeY6GFjsk6TS=Mtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52080 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754049AbdJIM7F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Oct 2017 08:59:05 -0400
Content-Disposition: inline
In-Reply-To: <CAP71WjwVdqmLEq1NGWK36JkEd-i05YcAu4jeY6GFjsk6TS=Mtg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 09, 2017 at 10:24:46AM +0200, Nicolas Dechesne wrote:
> 
> The problems appears as soon as I upgrade from e2fsprogs 1.42.12-2+b1
> (the version in Jessie) to either the version in Stretch or the
> version in jessie-backport. So it looks like e2fsprogrs 1.43, breaks
> something with existing ext2simg (I am using ext2simg from
> android-tools-fsutils, so the 'old' one).

So *that* shouldn't have happened.  I do try to keep the ABI/API of
the libext2fs shared library stable, even across major version
numbers.  That being said, I suspect ext2simg was doing something that
made it highly dependent on the internal implementation detalis of
libext2fs.  It would be interesting to know what in the world that
was, so I can try to avoid that in the future.  But I've always viewed
many of these tools to be quite highly fragile, so I'm not sure
there's much we can do to fix this in terms of changing what libext2fs
is doing.  But if I can fix/improve the backwards compatibility
problem from libext2fs's side, I'm certainly willing to entertain that
notion.

						- Ted
