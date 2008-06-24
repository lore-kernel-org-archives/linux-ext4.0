From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a write error
Date: Tue, 24 Jun 2008 13:17:22 +1000
Message-ID: <200806241317.22470.nickpiggin@yahoo.com.au>
References: <485F8822.5030205@hitachi.com> <20080623191733.52c3491c.akpm@linux-foundation.org> <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
	adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:40184 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756666AbYFXDRe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2008 23:17:34 -0400
In-Reply-To: <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 24 June 2008 13:01, Linus Torvalds wrote:
> On Mon, 23 Jun 2008, Andrew Morton wrote:
> > > I don't know why it was done like this, or if anybody actually tested
> > > any of it, but AFAIKS the best way to fix this is to simply not
> > > clear any uptodate bits upon write errors.
> >
> > There's a plausible-sounding reason for this behaviour which I forgot
> > about three years ago.  Maybe Linus remembers?
>
> We have to drop the data at _some_ point. Maybe some errors are transient,
> but a whole lot aren't. Jank out your USB memory stick, and those writes
> will continue fail. So you can't just keep things dirty - and that also
> implies that the buffer sure as heck isn't up-to-date either.

Depends what semantics you want, I guess. I have the newest copy of the
data... yes you do unless you want to try to say that a write error to
the media somehow invalidates that fact.


> Yes, we could haev a "retry once or twice", but quite frankly, that has
> always been left to the low-level driver. By the time the buffer cache or
> page cache sees the error, it should be considered more than "transient",
> and the data in memory is simply not _useful_ any more.

It could be useful. For example if you have it mmapped (or even just
reading it back from pagecache) and working on it, then you really may
not want to lose all your program just because of the write error.

Keeping it around longer may allow you eg. to "save as something else".

Yes, we have to discard the page at some point, but I don't know if
this is the right place. Maybe a sysctl thing?


> So clearing the uptodate bit seems to be the logical thing to do. But on
> the other hand, it's probably not helping much either, so I don't
> personally care if we keep it "uptodate" - as long as the dirty bit
> doesn't get set, and as long as there is *some* way to get rid of the bad
> buffer later.

What you want to do is not insane, but the way it is currently being
done is. As I said, just clearing the uptodate bit might blow up your
kernel pretty quickly from assertions in the vm. It should be going
through the whole truncate or invalidate page machinery in order to
do that.
