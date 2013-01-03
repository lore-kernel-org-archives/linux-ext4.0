From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_free_inode:319: comm krunner: bit already cleared for inode
 6293718
Date: Thu, 3 Jan 2013 13:22:35 -0500
Message-ID: <20130103182235.GA5941@thunk.org>
References: <50E5C4C5.9040701@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41563 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab3ACSWj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 13:22:39 -0500
Content-Disposition: inline
In-Reply-To: <50E5C4C5.9040701@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 03, 2013 at 06:49:57PM +0100, Toralf F=F6rster wrote:
> For the following 3 errors I think the last 2 are related to the fact=
,
> that I'm booting a Gentoo Linux (kernel 3.7.1) from an external USB 2=
=2E0 drive,
> but the first error, is that related too to the external drive itslef=
 ? :
>=20
> 2013-01-03T16:28:04.305+01:00 n22 kernel: EXT4-fs error (device sdb3)=
: ext4_free_inode:319: comm krunner: bit already cleared for inode 6293=
718
> 2013-01-03T16:28:07.426+01:00 n22 kernel: EXT4-fs error (device sdb3)=
 in ext4_new_inode:942: IO failure
> 2013-01-03T16:28:10.683+01:00 n22 kernel: EXT4-fs error (device sdb3)=
 in ext4_new_inode:942: IO failure

Well, what the error message means is that the kernel has detected an
inconsistency in the inode allocation bitmap.

Could this be called by an error to the external drive?  Certainly.
It could also be caused by the drive getting pulled before it was
cleanly unmounted at some point in the past, and (especially if this
drive was using flash) the inode allocation bitmap got corrupted.


-- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
