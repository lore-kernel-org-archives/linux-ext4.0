From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Remove failed journal checksum check
Date: Wed, 18 Nov 2009 11:10:01 +0100
Message-ID: <20091118100936.GA13268@pobox.suse.cz>
References: <20091114202755.GC4221@mit.edu> <1258316900-20808-1-git-send-email-tytso@mit.edu> <20091117160542.GB1923@atrey.karlin.mff.cuni.cz> <20091118035014.GA10380@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZKRKJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2009 05:09:56 -0500
Content-Disposition: inline
In-Reply-To: <20091118035014.GA10380@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-11-09 22:50:14, tytso@mit.edu wrote:
> On Tue, Nov 17, 2009 at 05:05:42PM +0100, Jan Kara wrote:
> >   But shouldn't we set the EXT4_ERROR_FS flag? We don't semm to do this
> > in ext4_load_journal() when jbd2_journal_load() fails.
> 
> No, we don't need to set the EXT4_ERROR_FS flag.  When
> jbd2_journal_load() fails, we are leaving the journal in place and we
> are refusing the mount.  In the case of a root file system with this
> problem, this will lead to a panic, and the user will have to use a
> rescue CD.
> 
> In any case, when e2fsck runs, the current version will report the
> error, abort the journal playback, and then force a full check of the
> file system.  So this actually does what we want without setting the
> EXT4_ERROR_FS flag.  In fact setting the flag will likely be
> pointless, since if the superblock is journalled, it will get
> overwritten during the journal replay.
  Ah, you're right. Thanks for explanation.

> In fact, what I think e2fsck should do as the default option is to
> *skip* the journal transaction with the failed checksum, but *not*
> abort the journal replay, and to replay the rest of the journal
> transactions with correct checksums, and then force a full fsck.
> Aborting a journal transaction and abandoning 10 or more transactions
> after the failed transaction is likely to do far more damage.  We're
> better off replaying the transactions, hope that some or all of the
> blocks in the skipped, failed transaction, are contained in subsequent
> transaction, and then clean up the file system afterwards.
  I agree, Replaying all transactions with correct checksum seems like a
better option. Of course, having per-block checksums and replaying all
blocks that have correct checksum is even better.

> E2fsck should have a (non-default) option to replay the failed
> transaction anyway, and a really paranoid system administrator,
> though, could try it both ways.  Using a LVM snapshot would allow the
> sysadmin to try both ways quite efficiently.
  Yes, possibly this can be useful as well.

> Here's an excerpt from journal of a file system that was aborted
> during an fs_mark run.  (Generated using "logdump -a" in debugfs):
> 
> Found expected sequence 5735, type 2 (commit block) at block 1977
> Found expected sequence 5736, type 1 (descriptor block) at block 1978
> Dumping descriptor block, sequence 5736, at block 1978:
>   FS block 277 logged at journal block 1979 (flags 0x0)
>   FS block 2 logged at journal block 1980 (flags 0x2)
>   FS block 1009 logged at journal block 1981 (flags 0x2)
>   FS block 547 logged at journal block 1982 (flags 0x2)
>   FS block 4433 logged at journal block 1983 (flags 0x2)
>   FS block 267 logged at journal block 1984 (flags 0xa)
> Found expected sequence 5736, type 2 (commit block) at block 1985
> Found expected sequence 5737, type 1 (descriptor block) at block 1986
> Dumping descriptor block, sequence 5737, at block 1986:
>   FS block 277 logged at journal block 1987 (flags 0x0)
>   FS block 2 logged at journal block 1988 (flags 0x2)
>   FS block 1009 logged at journal block 1989 (flags 0x2)
>   FS block 547 logged at journal block 1990 (flags 0x2)
>   FS block 4451 logged at journal block 1991 (flags 0x2)
>   FS block 267 logged at journal block 1992 (flags 0xa)
> Found expected sequence 5737, type 2 (commit block) at block 1993
> Found expected sequence 5738, type 1 (descriptor block) at block 1994
> Dumping descriptor block, sequence 5738, at block 1994:
>   FS block 277 logged at journal block 1995 (flags 0x0)
>   FS block 2 logged at journal block 1996 (flags 0x2)
>   FS block 1009 logged at journal block 1997 (flags 0x2)
>   FS block 547 logged at journal block 1998 (flags 0x2)
>   FS block 4680 logged at journal block 1999 (flags 0x2)
>   FS block 267 logged at journal block 2000 (flags 0xa)
> Found expected sequence 5738, type 2 (commit block) at block 2001
> Found expected sequence 5739, type 1 (descriptor block) at block 2002
> Dumping descriptor block, sequence 5739, at block 2002:
>   FS block 277 logged at journal block 2003 (flags 0x0)
>   FS block 2 logged at journal block 2004 (flags 0x2)
>   FS block 1009 logged at journal block 2005 (flags 0x2)
>   FS block 547 logged at journal block 2006 (flags 0x2)
>   FS block 4714 logged at journal block 2007 (flags 0x2)
>   FS block 291 logged at journal block 2008 (flags 0xa)
>
> This is a best case, but note how many blocks can appear multiple
> times in the journal.  If fs blocks 277, 2, 1009, or 547 are corrupted
> in any transaction before #5739, causing a checksum failure in commit
> #5436 (for example), replaying the subsequent transactions will
> recover the damage.  In fact, if blocks 4433 or 267 are intact, we're
> better off replaying commit #5436, even if the journal checksum
> doesn't match, since the corrupted blocks will be repaired by
> subsequent commits, and at least that way we don't lose the updates to
> blocks 4433 and 267.
  Yes, it heavily depends on the load. But you're right that bitmaps, group
descriptors and superblock are likely to be in further transactions. OTOH
inodes, directory blocks or indirect blocks (or however we call such blocks
for extents) and not that likely to be there.

								Honza
