From: Markus <M4rkusXXL@web.de>
Subject: Re: Dirty ext4 blocks system startup
Date: Tue, 08 Apr 2014 16:25:08 +0200
Message-ID: <1452787.GTL29L0o32@web.de>
References: <1459400.cqhC1n3S74@f209> <20140407124820.GB8468@thunk.org> <2164274.jmlex94sWc@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64376 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131AbaDHOZK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 10:25:10 -0400
In-Reply-To: <2164274.jmlex94sWc@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I patched e2fsck as mentionied below.
./e2fsck /dev/md5
e2fsck 1.43-WIP (4-Feb-2014)
/dev/md5: recovering journal
JBD: Invalid checksum recovering block 1152 in log
JBD: Invalid checksum recovering block 1156 in log
Setting free inodes count to 366227296 (was 366241761)
Setting free blocks count to 652527218 (was 730998757)
/dev/md5: clean, 41120/366268416 files, 2277606286/2930133504 blocks

So two blocks were bad. But the the recovery worked and the last few files all were intact.

A full check did not find any errors:
./e2fsck -f -n /dev/md5
e2fsck 1.43-WIP (4-Feb-2014)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md5: 41120/366268416 files (4.5% non-contiguous), 2277606286/2930133504 blocks

So I think that fs is now fine again.


But still, e2fsck should not be trapped in an endless loop.


Thanks,
Markus


Markus wrote on 07.04.2014:
> Theodore Ts'o wrote on 07.04.2014:
> > On Mon, Apr 07, 2014 at 12:58:40PM +0200, Markus wrote:
> > > 
> > > Finally e2image finished successfully. But the produced file is way too 
> big for a mail.
> > > 
> > > Any other possibility?
> > > (e2image does dump everything except file data and free space. But the 
> problem seems to be just in the bitmap and/or journal.)
> > > 
> > > Actually, when I look at the code around e2fsck/recovery.c:594
> > > The error is detected and continue is called.
> > > But tagp/tag is never changed, but the checksum is always compared to the 
> one from tag. Intended?
> > 
> > What mount options are you using?  It appears that you have journal
> > checksums enabled, which isn't on by default, and unfortunately,
> > there's a good reason for that.  The original code assumed that the
> > most common case for journal corruption would be caused by an
> > incomplete journal transaction getting written out if one were using
> > journal_async_commit.  This feature has not been enabled by default
> > because the qeustion of what to do when the journal gets corrupted in
> > other cases is not an easy one.
> 
> Normally just "noatime,journal_checksum", but with the corrupted journal I use 
> "ro,noload".
> 
> The "man mount" reads well about that "journal_checksum" option ;)
> 
> 
> > If some part of a transaction which is not the very last transaction
> > in the journal gets corrupted, replaying it could do severe damage to
> > the file system.  Unfortunately, simply deleting the journal and then
> > recreating it could also do more damage as well.  Most of the time, a
> > bad checksum happens because the last transaction hasn't fully made it
> > out to disk (especially if you use the journal_async_commit option,
> > which is a bit of a misnomer and has its own caveats[1]).  But if the
> > checksum violation happens in a journal transaction that is not the
> > last transaction in the journal, right now the recovery code aborts,
> > because we don't have good automated logic to handle this case.
> 
> The recovery does not seem to abort. It calles continue and is caught in an 
> endless loop.
> 
> 
> > I suspect if you need to get your file system back on its feet, the
> > best thing to do is to create a patched e2fsck that doesn't abort when
> > it finds a checksum error, but instead continues.  Then run it to
> > replay the journal, and then force a full file system check and hope
> > for the best.
> 
> The code calls "continue". ;)
> So I just remove the whole if clause:
>   /* Look for block corruption */
>   if (!jbd2_block_tag_csum_verify(
>   		journal, tag, obh->b_data,
>   		be32_to_cpu(tmp->h_sequence))) {
> - 	brelse(obh);
> - 	success = -EIO;
>   	printk(KERN_ERR "JBD: Invalid "
>   			"checksum recovering "
>   			"block %lld in log\n",
>   			blocknr);
> - 	continue;
>   }
> 
> It would then ignore the checksum and just issue a message. Right?
> 
> 
> > What has been on my todo list to implement, but has been relatively
> > low priority because this is not a feature that we've documented or
> > encouraged peple to use, is to have e2fsck skip the transaction has a
> > bad checksum (i.e., not replay it at all), and then force a full file
> > system check.  This is a bit safer, but if you make e2fsck ignore the
> > checksum, it's no worse than if journal checksums weren't enabled in
> > the first place.
> > 
> > The long term thing that we need to add before we can really support
> > journal checksums is to checksum each individual data block, instead
> > of just each transaction.  Then when we have a bad checksum, we can
> > skip just the one bad data block, and then force a full fsck.
> > 
> > I'm sorry you ran into this.  What I should do is to disable these
> > mount options for now, since users who stumble across them, as
> > apparently you have, might be tempted to use them, and then get into
> > trouble.
> > 
> >      	      	      	   	      	   	 - Ted
> > 
> > [1] The issue with journal_async_commit is that it's possible (fairly
> > unlikely, but still possible) that the guarantees of data=ordered will
> > be violated.  If the data blocks that were written out while we are
> > resolving a delayed allocation writeback haven't made it all the way
> > down to the platter, it's possible for all of the journal writes and
> > the commit block to be reordered ahead of the data blocks.  In that
> > case, the checksum for the commit block would be valid, but some of
> > the data blocks might not have been written back to disk.
> 
> Thanks so far,
> Markus
