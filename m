From: Theodore Tso <tytso@mit.edu>
Subject: Re: a question for i_inode's i_size in ext2
Date: Fri, 19 Sep 2008 19:32:03 -0400
Message-ID: <20080919233203.GA12762@mit.edu>
References: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53841 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752796AbYISXcJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2008 19:32:09 -0400
Content-Disposition: inline
In-Reply-To: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 19, 2008 at 04:21:44PM +0900, =ED=99=8D=EC=8B=A0 shin hong =
wrote:
> Dear ext2 maintainers
>=20
>   I have a question of inode's i_size. I found that it is hard to fin=
d
> any consistent synchronization mechanism that protects inode's i_size
> field.
>   Is there any lock or synchronization mechanism that consistently
> protects i_size fields of inode objects to avoid data race?
>   In inode's definition in /include/linux/fs.h, there is comment that
> i_lock protects i_size but it is not clear.

Yes, there is; the i_size (as well as others) are protected via
i_mutex in ext2.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
