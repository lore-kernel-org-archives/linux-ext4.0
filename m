From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Thu, 25 Oct 2012 00:05:17 +0200
Message-ID: <5088661D.20608@web.de>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <20121023221913.GC28626@thunk.org> <k69ejs$vt2$1@ger.gmane.org> <20121024213129.GB5484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:53363 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab2JXWFU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2012 18:05:20 -0400
In-Reply-To: <20121024213129.GB5484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 24.10.2012 23:31, schrieb Theodore Ts'o:
> On Wed, Oct 24, 2012 at 09:13:01PM +0200, Jannis Achstetter wrote:
>>
>> As a "normal linux user" I'm interested in the practical things to do
>> now to avoid data loss. I'm running several systems with 3.6.2 and ext4.
>> Fearing loss of data:
>> - Is there a way to see whether the journal of a specific partition has
>> been wrapped (since mounting) so that umounting and mounting (or doing a
>> reboot to downgrade the kernel) is safe?
> [...]
> (Keep in mind this is why commercial software corporations like
> [...]
> can all work towards finding the best answer.)

I really appreciate this and I like it since although the root-cause
hasn't been found for sure yet, it is a transparent process.
And it's great good thing that we can directly talk to the involved devs
w/o going through 200 layers of marketing and spokesmen (as it were with
the two companies you mentioned).

> It's a little bit too early for this meme:
>     http://memegenerator.net/instance/28936247

That's a good one :)

> But do please note that that Fedora !7 users have been using 3.6.2 for
> [...]
> with trailing edge kernel sources.  :-)

Yes, the downside of running Gentoo unstable. But even the "stable" tree
used 3.5.7 and this is the one my NAS uses where I do store my backups.
Nevertheless, your reply eased my mind to a great extend and I'm
thankful for it.
Time for bed now :)

	Jannis

