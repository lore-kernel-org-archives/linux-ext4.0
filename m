From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Mon, 29 Oct 2012 01:04:32 +0000
Message-ID: <87lieqdr6n.fsf@spindle.srvr.nix>
References: <20121026205618.GC8614@thunk.org>
	<87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org>
	<87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org>
	<873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org>
	<87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com>
	<508C633F.4070100@redhat.com> <20121029010012.GE9161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:46824 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2J2BEj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Oct 2012 21:04:39 -0400
In-Reply-To: <20121029010012.GE9161@thunk.org> (Theodore Ts'o's message of
	"Sun, 28 Oct 2012 21:00:13 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 29 Oct 2012, Theodore Ts'o spake thusly:

>     commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31 modified this function
>     such that the inode bitmap was being modified outside a transaction,
>     which could lead to corruption, and was discovered when journal_checksum
>     found a bad checksum in the journal.

Hm. If this could have caused corruption for non-checksum users, it must
be a pretty rare case if nobody's hit it in six months -- or maybe, I
suppose, they hit it and never noticed. (But, hey, this makes me happier
to have reported this despite all the flap, if it's found a genuine bug
that could have hit people not using wierdo mount options.)

Thanks for spending so much time on this fix. Much appreciated.

-- 
NULL && (void)
