From: Theodore Tso <tytso@mit.edu>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Tue, 8 Sep 2009 15:40:45 -0400
Message-ID: <20090908194045.GQ22901@mit.edu>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com> <20090908175605.GB7801@shell> <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Aurora <vaurora@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49867 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIHTkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 15:40:49 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 11:21:11AM -0700, Curt Wohlgemuth wrote:
> Hi Valerie:
>=20
> On Tue, Sep 8, 2009 at 10:56 AM, Valerie Aurora<vaurora@redhat.com> w=
rote:
> > Hey, did you figure this out? =A0If not, I want to have a bug open
> > somewhere.
>=20
> Yes, sorry.  I was going to post a patch for this, but have been
> waiting to verify that it really fixes the issue.  And see the thread
> started by Frank Mayhar about fsync issues as well...
>=20
> The problem is a race, between the last write to a to-be-freed
> metadata block (to update the extent header) and the block being
> marked free in the on-disk/buddy bitmaps.  Note that this only happen=
s
> without a journal, since *with* a journal the ordering is done
> correctly.

Just to clarify, this a race that shows up even without an unclean
shutdown, right?

> Without a journal, the block buffer_head is written to, the
> buffer_head is marked dirty, and the bitmaps are updated via
> ext4_free_blocks().  In rare cases, the block is re-allocated for
> another inode and written to -- subsequently, the writeback mechanism
> will then flush the dirty extent header back to disk.  That's why it
> looks like "leaked extent data" in the data block.

If this shows up even without an unclean shutdown, then it sounds like
the problem is a missing bforget() call.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
