From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH FOR DISCUSSION] add delalloc debugging
Date: Wed, 26 Jun 2013 09:39:13 -0400
Message-ID: <20130626133913.GD3875@thunk.org>
References: <20130620164249.GC4982@thunk.org>
 <20130625035002.GA2896@gmail.com>
 <alpine.LFD.2.00.1306261414000.5729@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33069 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3FZNjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 09:39:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306261414000.5729@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 02:31:14PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > 1. Now when we read /proc/fs/ext4/{$DEV}/delalloc_debug, it will pr=
int
> > the result in console.  IMHO, I don't think it is a good choice.  I
> > prefer to print this result in debugfs or in sysfs.
>=20
> I would prefer to print this info in debug_delalloc_show() so we can
> simply read the file instead of read the file + read the log.

This turns out to be tricky because we would need to grab all of this
information and stash it in kernel allocated memory, since otherwise
it might change out from under us if we need to read the information
across multiple read requests to the /proc file.

> I think that having this enabled only is EXT4_DEBUG is set is just
> fine. However if you want to be able to use it even without EXT4_DEBU=
G
> option we could just set proper permissions on the
> /proc/fs/ext4/{$DEV}/delalloc_debug so that only privileged user can
> open it.

The file is mode 400 readable by root already.

> > 3. Maybe we can provide a interface to let the user indicate which =
inode
> > they want to observe.
>=20
> you can grep for it, I do not think it's a big deal.

If we wanted to release the delalloc information for an inode, that's
actually easier; we could do this via an ioctl.

> > Finally, the patch itself still has two minor problems.  We forget
> > to call remove_proc_entry() in ext4_put_super().  Another problem i=
s
> > compile warnings.

This were alrady fixed in the version which is in the ext4 patch
queue.  I noticed those issues shortly after I sent out the patch for
discussion.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
