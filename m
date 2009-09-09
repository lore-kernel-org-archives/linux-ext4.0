From: Theodore Tso <tytso@mit.edu>
Subject: Re: Odd "leak" of extent info into data blocks?
Date: Wed, 9 Sep 2009 11:19:11 -0400
Message-ID: <20090909151911.GX22901@mit.edu>
References: <6601abe90908221610p60629809qcde6848308b8affe@mail.gmail.com> <20090908175605.GB7801@shell> <6601abe90909081121p17b154a4s2e6852da2b71951f@mail.gmail.com> <20090908194045.GQ22901@mit.edu> <6601abe90909081418k5de55938mfe411fccfe10a258@mail.gmail.com> <20090908233644.GV22901@mit.edu> <6601abe90909082100n48afdba9qee087ff46bfe4e3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Valerie Aurora <vaurora@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35845 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbZIIPTS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 11:19:18 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90909082100n48afdba9qee087ff46bfe4e3f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 09:00:50PM -0700, Curt Wohlgemuth wrote:
>=20
> >=A0In ext3 and ext4, metadata blocks (such as
> > extent tree blocks), aren't stored in the page cache.
>=20
> Hmm.  You're saying that in the absence of a journal, all metadata
> writes go direct to disk?  Where should I look for this in the code?

Sorry, let me be more precise.  All metadata writes, regardless of
whether a journal is present or not, are written via the buffer head
(bh) abstraction.  They have to, because that's how we do our
journalling; the jbd/jbd2 layer is built on top of the bh I/O request
layer, and even when a journal is not present, we are still doing our
metadata I/O via the submit_bh and ll_rw_block interface.

It used to be the case (in Linux 2.4) that the buffer cache was stored
separately from the page cache.  In Linux 2.6, the buffer cache is
implemented on top of the page cache, so technically, the metadata
blocks are stored in the page cache; however, they are only *accessed*
via the buffer cache abstraction.

> The problem is that I've seen this in real life.  And the patch below
> seems to fix it.  (Unfortunately, I haven't been able to recreate thi=
s
> in a simple example, after several days work.  I've only seen this in
> a *very* small number of cases on heavily loaded machines.)

I believe that you have a problem.  The problem is you have a dirty bh
which is getting written out after the block gets reallocated for use
as a data block.  But a bforget() call should have the problem just as
as well.  In fact, I think the real fix should be this.

commit 1b58b00e02893b4bbab2b5f137316b82feadac52
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Sep 9 11:18:42 2009 -0400

    ext4: Use bforget() in no journal mode when in ext4_journal_forget(=
)
   =20
    When ext4 is using a journal, a metadata block which is deallocated
    must be passed into the journal layer so it can be "revoked".  The
    jbd2_journal_forget() function is also responsible for calling
    bforget().  Without a journal, ext4_journal_forget() must call
    bforget(), to avoid a race from a dirty metadata block getting writ=
ten
    back after it has been reallocated and reused for another inode's d=
ata
    block.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index eb27fd0..d4f4b39 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -44,7 +44,7 @@ int __ext4_journal_forget(const char *where, handle_t=
 *handle,
 						  handle, err);
 	}
 	else
-		brelse(bh);
+		bforget(bh);
 	return err;
 }
=20

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
