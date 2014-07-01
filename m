From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help with bug_on on ext4 mount
Date: Tue, 1 Jul 2014 11:39:14 -0400
Message-ID: <20140701153914.GB2775@thunk.org>
References: <6d9f68dc2278627dbe8d5e5434cf5a78.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Tanya Brokhman <tlinder@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>, kdorfman@codeaurora.org,
	lsusman@codeaurora.org
To: Dolev Raviv <draviv@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39128 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbaGAPjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jul 2014 11:39:22 -0400
Content-Disposition: inline
In-Reply-To: <6d9f68dc2278627dbe8d5e5434cf5a78.squirrel@www.codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2014 at 06:44:45AM -0000, Dolev Raviv wrote:
>=20
> Crash description:
> I saw a BUG_ON assertion failure in function ext4_clear_journal_err()=
=2E The
> assertion that fails is:  !EXT4_HAS_COMPAT_FEATURE(sb,
> EXT4_FEATURE_COMPAT_HAS_JOURNAL).
> The strange thing is, that the same BUG_ON assertion is called at the
> start of the function that calls ext4_clear_journal_err(), which is
> ext4_load_journal(). This means that the capability flag is changed i=
n
> ext4_load_journal, before the call for journal_err().
>=20
> I=92m not too familiar with ext4 code unfortunately. From analyzing t=
he
> journal path I came to the below conclusions:
> This scenario is possible, if during journal replay, the super_block =
is
> restored or overridden from the journal.
> I have noticed a case where the sb is marked as dirty and later, it i=
s
> evicted through the address_space_operations .writepage =3D ext4_writ=
epage
> cb. This cb is using the journal and can cause the dirty sb appear on=
 the
> journal. If during the journal write operation a power cut occurs, an=
d the
> sb copy in the journal is corrupted, it may cause the BUG_ON assertio=
n
> failure above.

Yes, this is possible --- but if the journal has been corrupted,
something pretty disastrous has happened.  Indeed, if that has
happenned, it may be that some other portions of the file system will
also have been wiped out.  So I'd ask the question of whether you have
a bigger issue, such as crappy flash that is either not properly
implementing the CACHE FLUSH operation, or which does not have proper
transaction handling for its FTL metadata, so that even if the data
blocks were correctly saved, if power gets removed while the SSD or
eMMC flash is doing a GC operation, some data or metadata blocks
(potentially including blocks written days or months ago) can get
corrupted.  Unfortunately, there does seem to be a huge number of
crappy flash out there, and there's not much the file system can do
about it.

> Is the scenario described above even possible (or am I missing someth=
ing)?
> Has anyone encountered similar issues? Are there any known fixes for =
this?

We do have journal checksums, but the reason why it hasn't been
enabled by default is that e2fsck doesn't have good recovery from a
corrupted journal.  So it will detect a bad journal block, but we
don't have good recovery strategies implemented yet.

We could add a sanity check to make sure that, in the absense of
journal checksums, if we are replaying the superblock and the journal
copy of the superblock looks insane, to abort the journal replay.
It's not going to help you recover the bad file system, but it will
prevent the BUG_ON.

Personally, I'd focus on why the journal got corrupted in the first
place.  A BUG_ON is transient; you reboot, and move on.  Data
corruption (at least in the absense of backups, and you *have* been
doing backups, right?) is forever....

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
