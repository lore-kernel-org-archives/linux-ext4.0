From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sat, 15 Dec 2012 22:51:50 -0500
Message-ID: <20121216035150.GA6104@thunk.org>
References: <kainf9$btc$1@ger.gmane.org>
 <20121216022753.GD9016@thunk.org>
 <50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38662 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2LPDvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Dec 2012 22:51:54 -0500
Content-Disposition: inline
In-Reply-To: <50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 16, 2012 at 01:00:25AM -0200, D=E2niel Fraga wrote:
>=20
> 	Hi Ted! Yes, I get the same EXT4-fs message when I try to
> access teh file. Here's the requested output:

Um, really?  **Exactly** the same error message?  That doesn't make
any sense.  The error message you quoted happens when the kernel
complains that the block numbers in the inode in question are invalid
(i.e., are too big for the inode in question, or point at file system
metadata).

However, debugfs is not showing any extents --- which would be the
case after e2fsck repaired the file system (it would have zapped the
extent tree for the inode).

So (a) you did run e2fsck on an unmounted file system right?

(b) Can you send me the output of:

	debugfs -R "extents <9311628>" /dev/sda2

just to be sure we aren't missing anything.

Also, if you are using a really new kernel such as 3.6.x or 3.7.x, you
***really*** shouldn't be using an ancient version of e2fsprogs such
as 1.41.12.  You really should be using e2fsprogs 1.42.x, preferably
the latest e2fsprogs 1.42.6.  I wonder if you are seeing a similar
message indicating that the file system had previously found an error,
and which wasn't cleared because you are using an ancient version of
e2fsprogs....

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
