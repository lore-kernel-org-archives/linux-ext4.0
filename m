From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a write error
Date: Mon, 23 Jun 2008 22:36:30 +1000
Message-ID: <200806232236.30961.nickpiggin@yahoo.com.au>
References: <485F8822.5030205@hitachi.com> <200806232146.28379.nickpiggin@yahoo.com.au> <20080623123116.GL26743@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	akpm@linux-foundation.org, sct@redhat.com, adilger@sun.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:34504 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754274AbYFWMgr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 08:36:47 -0400
In-Reply-To: <20080623123116.GL26743@duck.suse.cz>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 23 June 2008 22:31, Jan Kara wrote:
> On Mon 23-06-08 21:46:27, Nick Piggin wrote:

> > I don't know why it was done like this, or if anybody actually tested
> > any of it, but AFAIKS the best way to fix this is to simply not
> > clear any uptodate bits upon write errors.
>
>   That would be non-trivial effort because there are lots of places which
> do things like:
>   wait_on_buffer(bh);
>   if (!buffer_uptodate)
>     /* IO error handling */
>
>   But what you say sounds like a reasonable thing from a logical
> perspective.

For reads, that's obviously a common pattern, although even that's
broken in some cases where it is used. But definitely uptodate should
not be set on a read error (although does it need to be explicitly
cleared? I would hope we don't submit a read anyway if the page/buffer
is already uptodate).

But you're right, even changing this for writes would not be a trivial
effort.
