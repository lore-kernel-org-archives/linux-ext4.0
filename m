From: Theodore Tso <tytso@mit.edu>
Subject: Re: a question for i_inode's i_size in ext2
Date: Fri, 26 Sep 2008 10:41:54 -0400
Message-ID: <20080926144154.GD11413@mit.edu>
References: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com> <20080920032522.GB9633@atrey.karlin.mff.cuni.cz> <20080920063502.GB12762@mit.edu> <2014bcab0809252152i6fef9babx242e821c4f0d5a7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59571 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752258AbYIZOl6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 10:41:58 -0400
Content-Disposition: inline
In-Reply-To: <2014bcab0809252152i6fef9babx242e821c4f0d5a7b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 26, 2008 at 01:52:13PM +0900, =ED=99=8D=EC=8B=A0 shin hong =
wrote:
>   Thank you for the answering.
>=20
>   In ext2, it seems to me that inode's i_size field can be accessed w=
ithout
> holding i_mutex
>   nor thorugh i_size_read function.
>=20
>   For example, in ext2_update_inode() can be invoked without holding
> i_mutex.
>   However, it freely access i_size field.
>=20
>   Are these accesses can race with each others?
>=20

ext2_update_inode() is responsible for writing the contents of the
inode to disk.  So it simply saves the current version of the object
to persistent storage.  If the inode happens to be in the middle of
being modified, the inode will be redirtied (the rule for modifying
objects like inodes is you modify them first, *then* set the dirty bit
after you are done modifying the object).  So if another kernel thread
is in the middle of updating the object, it's not a big deal; the
updated version of the inode will get written to disk later.

Ext2 has no guarantees about filesystem consistency after a crash (you
have to run fsck after a crash), so this is OK.

     	    	       	 	    	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
