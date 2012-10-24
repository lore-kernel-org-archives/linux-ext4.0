From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Thu, 25 Oct 2012 00:47:49 +0100
Message-ID: <87liev77q2.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix>
	<20121023221913.GC28626@thunk.org> <k69ejs$vt2$1@ger.gmane.org>
	<20121024213129.GB5484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jannis Achstetter <jannis_achstetter@web.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:35645 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab2JXXrw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 19:47:52 -0400
In-Reply-To: <20121024213129.GB5484@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 17:31:29 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Theodore Ts'o uttered the following:
> (Keep in mind this is why commercial software corporations like
> Microsoft or Apple generally don't make discussions as they are trying
> to root cause a problem public; sometimes the initial theories can be
> incorrect, and it's unfortunate when misinformation ends up on
> Phoronix or Slashdot, leading to people to panic...  but this is open
> source, so that means we do everything in the open, since that way we
> can all work towards finding the best answer.)

Quite. The first few days of any problem diagnosis are often a process
of taking something from 'oh my god it might be the end of the world' to
'oh look it's really obscure, no wonder nobody has ever seen it before'.

This is quite *definitely* such a problem.

> It's a little bit too early for this meme:
>
>     http://memegenerator.net/instance/28936247

It appears I have taken up a new post as the Iraqi Information Minister.
This is why I was disturbed to see the thing hitting Phoronix and then
Slashdot: as the guy whose FSes are being eaten, this is probably not an
easy bug to hit! If it hits, the consequences are serious, but it
doesn't seem to be easy to hit. (I should perhaps have phrased the
subject line better, but I'd just had my $HOME eaten and was rather
stressed out...)

> But do please note that that Fedora !7 users have been using 3.6.2 for
> a while, so if this were an easily triggered bug, (a) Eric and I would
> have managed to reproduce it by now, and (b) lots of people would be
> complaining, since the symptoms of the bug are not subtle.

Quite.

-- 
NULL && (void)
