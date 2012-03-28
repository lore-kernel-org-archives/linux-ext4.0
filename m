From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT PULL] ext4 updates for 3.4
Date: Wed, 28 Mar 2012 16:36:23 -0700
Message-ID: <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
References: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48125 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2C1Xgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2012 19:36:46 -0400
In-Reply-To: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 26, 2012 at 11:07 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Ext4 commits for 3.3 merge window; mostly cleanups and bug fixes

Ted, is there any chance that the dirty handling (or something else)
has some serious latency bug?

I'm compiling an allmodconfig kernel, and my mouse is (sometimes) very
erratic with bad latency. And the biggest changes in the kernel I'm
running on that machine now (HEAD=529b73fc0a97) and the previous boot
of that machine (HEAD=e22057c85993) are the ext4 changes.

(Sure, there are tons of other changes in between, but they tend to be
ARM changes or drivers that are irrelevant).

It may be that the bad interactive behavior started earlier, but I'd
have expected to notice it - it really is pretty bad, and I've been
doing allmodconfig builds pretty regularly.

(Adding Jan and Fengguang to the cc too, in case it's that
inode_sync_wait() change that *should* be a no-op, but maybe somebody
overlooked something)

NOTE! Latency normally is perfectly fine. Then *occasionally*
something bad happens, and it's horrible for a while. I have no idea
what triggers it. It's a regular "make -j16" of an x86-64 allmodconfig
build, and that should *not* be nearly enough to make this machine
stutter noticeably enough for the mouse pointer to not move smoothly.

I have no real data for this, though - just a "mouse pointer
occasionally freezing up". So I'm looking for a potential "hmm, that
makes me wonder if..." kind of reaction.

                                Linus
