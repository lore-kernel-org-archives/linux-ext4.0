From: Ted Ts'o <tytso@mit.edu>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Thu, 18 Aug 2011 17:03:13 -0400
Message-ID: <20110818210313.GA4602@thunk.org>
References: <86aab94mfg.fsf@gray.siamics.net>
 <20110817183101.GC6901@thunk.org>
 <86mxf7yirb.fsf@gray.siamics.net>
 <20110817220953.GD6901@thunk.org>
 <86ei0jxtt9.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51081 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1HRVDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 17:03:16 -0400
Content-Disposition: inline
In-Reply-To: <86ei0jxtt9.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 10:49:38AM +0700, Ivan Shmakov wrote:
>  > For this, I'd suggest that you use the ext2fs library.  That will
>  > take care of byte swapping, etc.  It also means that you don't hav=
e
>  > to worry about parsing the extent trees.  If you had used the ext2=
fs
>  > library before ext4 had shipped, you wouldn't have had to make any
>  > changes to support extents, since the ext2fs library wraps and
>  > provides abstract interfaces for most of what you would need for
>  > e2dis project.
>=20
> 	I don't seem to understand.  I've scanned through the
> 	(libext2fs.info) Function Index section (as per the Debian's
> 	e2fslibs-dev package, 1.41.12-2), and I see no mention of a
> 	function that I can use for that.

Sorry, the documentation is not necessarily complete; my apologies.

> 	Thus, I've ended up writing my own one, which takes an
> 	ext2_filsys handle, and references, via its =E2=80=98super=E2=80=99 =
member, the
> 	=E2=80=98s_blocks_count=E2=80=99 and =E2=80=98s_blocks_count_hi=E2=80=
=99 members of the
> 	superblock structure.

The function to do this is in the 1.42 dev branch which is in Debian
unstable, and it's called ext2fs_block_count().

> 	However, I was concerned that I don't seem to find the
> 	documentation for these structures' contents anywhere.  (Sans
> 	the source, of course), and wondered, if the interface I use is
> 	at least stable?

I make a very strong effort to ensure that interfaces which are
exposed via the shared library are stable.  If you're not sure, please
feel free to ask on the ext4 list.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
