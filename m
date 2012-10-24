From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 12:22:28 -0500
Message-ID: <508823D4.4010407@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com> <87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com> <20121024052351.GB21714@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	=?UTF-8?B?VG9yYWw=?= =?UTF-8?B?ZiBGw7Zyc3Rlcg==?=
	<toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab2JXRWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2012 13:22:43 -0400
In-Reply-To: <20121024052351.GB21714@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2012 12:23 AM, Theodore Ts'o wrote:
> On Tue, Oct 23, 2012 at 11:27:09PM -0500, Eric Sandeen wrote:
>>
>> Ok, fair enough.  If the BBU is working, nobarrier is ok; I don't trust
>> journal_async_commit, but that doesn't mean this isn't a regression.
> 
> Note that Toralf has reported almost exactly the same set of symptoms,
> but he's using an external USB stick --- and as far as I know he
> wasn't using nobarrier and/or the journal_async_commit.  Toralf, can
> you confirm what, if any, mount options you were using when you saw
> it.
> 
> I've been looking at this some more, and there's one other thing that
> the short circuit code does, which is neglects setting the
> JBD2_FLUSHED flag, which is used by the commit code to know when it
> needs to reset the s_start fields in the superblock when we make our
> next commit.  However, this would only happen if the short circuit
> code is getting hit some time other than when the file system is
> getting unmounted --- and that's what Eric and I can't figure out how
> it might be happening.  Journal flushes outside of an unmount does
> happen as part of online resizing, the FIBMAP ioctl, or when the file
> system is frozen.  But it didn't sound like Toralf or Nix was using
> any of those features.  (Toralf, Nix, please correct me if my
> assumptions here is wrong).

If I freeze w/ anything in the log, then s_start !=0 and we proceed
normally.  If I re-freeze w/o anything in the log, it's already set to
FLUSHED (which makes sense) so not re-setting it doesn't matter.  So I
don't see that that's an issue.

As for FIBMAP I think we only do journal_flush if it's data=journal.

In other news, Phoronix is on the case, so expect escalating freakouts ;)

-Eric
