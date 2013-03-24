From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Type of filesystem block
Date: Sun, 24 Mar 2013 15:00:55 -0400
Message-ID: <20130324190055.GB26792@thunk.org>
References: <CAEUQcegWM0d3tmpNXVmeOSKAJUPzthk8uH96XMN+Ax_5ex5H5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55458 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3CXTA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Mar 2013 15:00:58 -0400
Content-Disposition: inline
In-Reply-To: <CAEUQcegWM0d3tmpNXVmeOSKAJUPzthk8uH96XMN+Ax_5ex5H5Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 24, 2013 at 10:05:12PM +0530, Subranshu Patel wrote:
> But I don=E2=80=99t find any  debugfs command which can show similar =
block
> usage information about metadata blocks, whether it is a superblock,
> or inode bitmap block or block group descriptor, etc.
> Is there any way to extract the usage information of metadata blocks
> in ext4 filesystem ?

There isn't one today.  Normally I'll just look it up using the output
of dumpe2fs.

What's the use case where you need to get that information?  We could
add that as a new feature into debugfs, but it might be helpful to
understand the circumstances where you're needing that feature to
understand how best to add it into debugfs (or maybe some other
e2fsprogs command, such as e2fsck --- although in many cases e2fsck
has some of this already).

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
