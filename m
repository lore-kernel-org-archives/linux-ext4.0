From: Ted Ts'o <tytso@mit.edu>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Wed, 17 Aug 2011 18:09:53 -0400
Message-ID: <20110817220953.GD6901@thunk.org>
References: <86aab94mfg.fsf@gray.siamics.net>
 <20110817183101.GC6901@thunk.org>
 <86mxf7yirb.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51959 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1HQWJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 18:09:56 -0400
Content-Disposition: inline
In-Reply-To: <86mxf7yirb.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 01:50:48AM +0700, Ivan Shmakov wrote:
> >>>>> Ted Ts'o <tytso@mit.edu> writes:
> >>>>> On Tue, Aug 16, 2011 at 06:37:23PM +0700, Ivan Shmakov wrote:
>=20
>  >> How do I get the Ext2+ filesystem size (in blocks)?
>=20
>  > I assume you need the exact numbers, so you can't use statfs(2)?
>  > What are you using it for?
>=20
> 	The intent is to process a filesystem image, not a mounted
> 	filesystem.  It's my understanding that I cannot use neither
> 	statfs(2) nor POSIX' statvfs(2) in this case.
>=20
> 	The code I've posted earlier is used in my e2dis [1=E2=80=933] proje=
ct.

=46or this, I'd suggest that you use the ext2fs library.  That will tak=
e
care of byte swapping, etc.  It also means that you don't have to
worry about parsing the extent trees.  If you had used the ext2fs
library before ext4 had shipped, you wouldn't have had to make any
changes to support extents, since the ext2fs library wraps and
provides abstract interfaces for most of what you would need for e2dis
project.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
