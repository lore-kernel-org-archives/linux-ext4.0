From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 12:45:40 +0100
Message-ID: <87liewks9n.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:58520 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2JXLp6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 07:45:58 -0400
In-Reply-To: <20121024052351.GB21714@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 01:23:51 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Theodore Ts'o stated:

>                         Journal flushes outside of an unmount does
> happen as part of online resizing, the FIBMAP ioctl, or when the file
> system is frozen.  But it didn't sound like Toralf or Nix was using
> any of those features.

Quite so -- the corrupted filesystems have space reserved for resizing,
and one of them has been resized, years ago, but I haven't resized
either of them with this kernel, or with any kernel numbered 3.x for
that matter.

> Toralf, Nix, if you could try applying this patch (at the end of this
> message), and let me know how and when the WARN_ON triggers, and if it
> does, please send the empty_bug_workaround plus the WARN_ON(1) report.
> I know about the case where a file system is mounted and then
> immediately unmounted, but we don't think that's the problematic case.
> If you see any other cases where WARN_ON is triggering, it would be
> really good to know....

I'll give it a test later today, after another backup has finished.
Daily backups are normally overkill, but I don't think they are right
now.

-- 
NULL && (void)
