From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
Date: Thu, 25 Oct 2012 12:06:42 +0100
Message-ID: <871ugm6cal.fsf@spindle.srvr.nix>
References: <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
	<20121025011056.GC4559@thunk.org>
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
Received: from icebox.esperi.org.uk ([81.187.191.129]:34299 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab2JYLG5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 07:06:57 -0400
In-Reply-To: <20121025011056.GC4559@thunk.org> (Theodore Ts'o's message of
	"Wed, 24 Oct 2012 21:10:56 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 25 Oct 2012, Theodore Ts'o stated:
> Also, can you reproduce the problem with the nobarrier and
> journal_async_commit options *removed*?  Yes, I know you have battery
> backup, but it would be interesting to see if the problem shows up in
> the default configuration with none of the more specialist options.
> (So it would probably be good to test with journal_checksum removed as
> well.)

I'm going to spend some time after work today trying to reproduce this
in a virtual machine. If rebooting while umounting is truly all it
takes, as it seems, this should eliminate a bunch of variables and make
it a lot easier to reproduce. (Assuming Eric hasn't already done just
that, that is.)

-- 
NULL && (void)
