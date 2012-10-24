From: Hugh Dickins <hughd@google.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 00:00:46 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1210232359180.29283@eggly.anvils>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com> <20121024052351.GB21714@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	=?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48814 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab2JXHAx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 03:00:53 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so227975iea.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2012 00:00:53 -0700 (PDT)
In-Reply-To: <20121024052351.GB21714@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Oct 2012, Theodore Ts'o wrote:
> Journal flushes outside of an unmount does
> happen as part of online resizing, the FIBMAP ioctl, or when the file
> system is frozen.  But it didn't sound like Toralf or Nix was using
> any of those features.  (Toralf, Nix, please correct me if my
> assumptions here is wrong).

I believe it also happens at swapon of a swapfile on the filesystem.

Hugh
