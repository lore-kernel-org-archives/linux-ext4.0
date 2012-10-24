From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 12:46:33 +0100
Message-ID: <87hapkks86.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org>
	<alpine.LNX.2.00.1210232359180.29283@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:58534 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab2JXLqq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 07:46:46 -0400
In-Reply-To: <alpine.LNX.2.00.1210232359180.29283@eggly.anvils> (Hugh
	Dickins's message of "Wed, 24 Oct 2012 00:00:46 -0700 (PDT)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Hugh Dickins verbalised:

> On Wed, 24 Oct 2012, Theodore Ts'o wrote:
>> Journal flushes outside of an unmount does
>> happen as part of online resizing, the FIBMAP ioctl, or when the file
>> system is frozen.  But it didn't sound like Toralf or Nix was using
>> any of those features.  (Toralf, Nix, please correct me if my
>> assumptions here is wrong).
>
> I believe it also happens at swapon of a swapfile on the filesystem.

I'm not using swapfiles, only swap partitions (on separate LVM LVs).
So that's not it either.

-- 
NULL && (void)
