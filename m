From: "Kosta Kliakhandler" <kostak@gmail.com>
Subject: Re: fsck 1.39 segfaults while fixing a corrupt inode
Date: Sat, 11 Aug 2007 03:02:54 +0300
Message-ID: <a73860e00708101702v409fd357kd0ffd8179d116a8@mail.gmail.com>
References: <a73860e00708100541v59628f6dn491327b6d3097e5b@mail.gmail.com>
	 <20070810140341.GA1093@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:60086 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbXHKACz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 20:02:55 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1056670wah
        for <linux-ext4@vger.kernel.org>; Fri, 10 Aug 2007 17:02:54 -0700 (PDT)
In-Reply-To: <20070810140341.GA1093@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 8/10/07, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Aug 10, 2007 at 03:41:32PM +0300, Kosta Kliakhandler wrote:
> >
> > I have a severe problem - I was a fool and made / (root) ext4 (at
> > least not /home, thank god) and somehow some corruption occured.
> > While running fsck, it keeps segfaulting, complaining about fast
> > memory corruption (segfaults always at the same inode, always when I
> > tell it to fix it). I *think* the issue was addressed in
> > e2fsprogs-1.40.2 (from what I understood in the changelog)
>
> What, you mean this one?
>
>    A recent change to e2fsck_add_dir_info() to use tdb files to check
>    filesystems with a very large number of filesystems had a typo which
>    caused us to resize the wrong data structure.  This would cause a
>    array overrun leading to malloc pointer corruptions and segfaults.
>    Since we normally can very accurately predict how big the the dirinfo
>    array needs to be, this bug only got triggered on very badly corrupted
>    filesystems.
>
> If so, it couldn't be, since the tdb support was only added in
> e2fsprogs 1.40, and you're using the 1.39 patchset, right?  So it has
> to be some other problem, and probably a bug which gets triggered when
> it runs across a corrupted extent entry.
>
> How big is your root filesystem image?  Unfortunately e2image hasn't
> been updated support extents yet (there's a reason I keep telling
> people ext4 isn't quite ready for prime time yet...), so we can't use
> a compressed e2image file.
>
>                                                         - Ted
>

Yes, this was what I thought about... Well, maybe it wasn't that bug,
but what happened to me certainly seemed similar - especially since
after applying the extents patch which andreas supplied, it worked
well.

When I ran the new one, it reported that the problematic inode is in
position -1 and not 0, so I guess this is what caused the problems in
1.39.

Anyway, thanks for the help.

Regards,
Kosta.

-- 
Kosta.tk
