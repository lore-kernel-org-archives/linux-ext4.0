From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck exit codes
Date: Wed, 15 Feb 2017 10:44:27 -0500
Message-ID: <20170215154427.26pb74jy6ynrdqvo@thunk.org>
References: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
 <20170214170101.irgf4uvvvbbepmip@thunk.org>
 <CAJ6LpRpe6KfwoWvCw6cDwWg6=BxtcbXnSjLN358OgZ2obGcxsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: thanumalayan mad <madthanu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36622 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdBOPo2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 15 Feb 2017 10:44:28 -0500
Content-Disposition: inline
In-Reply-To: <CAJ6LpRpe6KfwoWvCw6cDwWg6=BxtcbXnSjLN358OgZ2obGcxsQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 14, 2017 at 11:00:51AM -0800, thanumalayan mad wrote:
> Thank you for the quick reply! (I was curious about the free-blocks
> 
> Would this be the way to proceed? I am hoping "-E journal_only" also
> takes care of clearing orphan inodes and still exits with a 0. (Note:
> The output I pasted above is derived from a file system created with
> default options, and does not switch off uninit_bg or
> lazy_itable_init.)

What are you trying to _do_ by, at the high level?

It should do what you want, but at this point I'm wondering _why_ you
want to do it, and whether or not it is something you _should_ be
doing.

						- Ted
