From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6 (when rebooting during umount)
Date: Thu, 25 Oct 2012 00:42:44 +0100
Message-ID: <87txtj77yj.fsf@spindle.srvr.nix>
References: <20121023013343.GB6370@fieldses.org>
	<87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<20121024210819.GA5484@thunk.org> <87y5iv78op.fsf_-_@spindle.srvr.nix>
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
Received: from icebox.esperi.org.uk ([81.187.191.129]:60977 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab2JXXm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 19:42:57 -0400
In-Reply-To: <87y5iv78op.fsf_-_@spindle.srvr.nix> (nix@esperi.org.uk's message
	of "Thu, 25 Oct 2012 00:27:02 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 25 Oct 2012, nix@esperi.org.uk said:
> Even though my own system relies on the possibility of rebooting during
> umount to reboot reliably, I'd be inclined to say 'not a bug, don't do
> that then' -- except that this renders it unreliable to use umount -l to
> unmount all the filesystems you can, skipping those that are not
> reachable due to having unresponsive servers in the way.

It's worse than that. If you're using filesystem namespaces, how can
*any* shell script loop, or anything in userspace, reliably unmount all
filesystems before reboot? It seems to me this is impossible. There is
no process that necessarily has access to all namespaces, and when you
bring PID namespaces into the picture there is no process that can even
kill all userspace processes in order to zap their filesystems.

I suspect we need a new blocking 'umountall' syscall and a command that
calls it, which umounts everything it can in every filesystem namespace
it can, skipping those that are (unreachable?) network mounts, and
returns only when everything is done. (Possibly it should first kill
every process it sees in every PID namespace other than that of the
caller, too.)

Then shutdown scripts can just call this, and get the right behaviour
immediately.

-- 
NULL && (void)
