From: Theodore Tso <tytso@mit.edu>
Subject: Re: Porting Zfs features to ext2/3
Date: Mon, 28 Jul 2008 08:40:55 -0400
Message-ID: <20080728124055.GD9378@mit.edu>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu> <1217218559.28825.12.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51685 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbYG1MlU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 08:41:20 -0400
Content-Disposition: inline
In-Reply-To: <1217218559.28825.12.camel@telesto>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 10:15:59PM -0600, Eric Anopolsky wrote:
> It's true that ZFS on FUSE performance isn't all it could be right no=
w.
> However, ZFS on FUSE is currently not taking advantage of mechanisms
> FUSE provides to improve performance. For an example of what can be
> achieved, check out http://www.ntfs-3g.org/performance.html .

Yes... and take a look at the metadata operations numbers.  FUSE can
do things to accellerate bulk read/write, but metadata-intensive
operations will (I suspect) always be slow.  I also question whether
the FUSE implementation will have the safety that has always been the
Raison d'=EAtre of ZFS.  Have you or the ZFS/FUSE developers done tests
where you are writing to the filesystem, and then someone pulls the
plug on the fileserver while ZFS is writing?  Does the filesystem
recovery cleanly from such a scenario?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
