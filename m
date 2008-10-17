From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 15:39:57 +0200
Message-ID: <20081017153957.28a4dd67.taeuber@bbaw.de>
References: <20081017120852.1f04dc36.taeuber@bbaw.de>
	<ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com>
	<20081017143311.52d50a23.taeuber@bbaw.de>
	<20081017132443.GA8755@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:47511 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbYJQNio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 09:38:44 -0400
In-Reply-To: <20081017132443.GA8755@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,


Theodore Tso <tytso@mit.edu> schrieb:
> On Fri, Oct 17, 2008 at 02:33:11PM +0200, Lars T=C3=A4uber wrote:
> > Is the space of the file on the underlying block device already
> > marked as free? Or does this happen after all processes have closed
> > all file descriptors pointing to the file?
>=20
> No, the space on the file is not yet marked as free.  *However* for
> ext3 and ext4, the inode has been placed on the orphaned inode list,
> so that if the system crashes, part of the journal recovery process
> will at that point free the blocks.

not that it is a way I would go, but theoretically: I could provoke a c=
rash and mount the ext3 filesystem as ext2 and restore the file?

> > I really want to undo the deletion. (get a link/name connected to
> > the root inode of the file again) Is there a way to do this?
>=20
> Not currently using ext3/ext4, no.  There would have to be an entirel=
y
> new system call or other userspace interface for something like this.

Is this planned?

But a solution should be independent of the real filesystem. Because th=
e file is still somewhere in the ram and represented in linux vfs, isn'=
t it?
It only needs to be copied/recreated on to a (different) filesystem som=
ehow.

Regards
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
