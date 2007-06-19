From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated patches for journal checksums.
Date: Tue, 19 Jun 2007 13:06:46 -0600
Message-ID: <20070619190645.GT5181@schatzie.adilger.int>
References: <1182239437.3784.11.camel@dhcp7.linsyssoft.com> <46778DBE.3090801@clusterfs.com> <1182240928.3784.18.camel@dhcp7.linsyssoft.com> <20070619085141.GR5181@schatzie.adilger.int> <46779D9D.2090109@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:39990 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbXFSTGt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 15:06:49 -0400
Content-Disposition: inline
In-Reply-To: <46779D9D.2090109@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 19, 2007  13:10 +0400, Alex Tomas wrote:
> Andreas Dilger wrote:
> >I _think_ Alex is asking "what happens if during a transaction undergoing
> >checkpoint of blocks to filesystem (not the last one in the journal) is
> >interrupted by a crash and upon restart the partially-checkpointed
> >transaction is found to have a checksum error?"
> 
> yup, thanks for clarification.
> 
> >>>what do we do if transaction in the journal is found with wrong
> >>>checksum? leave partial transaction in-place?
> >>The sanity of the transaction is checked in PASS_SCAN. And if checksum
> >>is found to be incorrect for nth transaction then last transaction which
> >>is written to disk is (n - 1).
> >
> >The recovery.c code (AFAIK) does not do replay for any transaction that
> >does not have a valid checksum, or transactions beyond that.  If the
> >bad transaction had already started chekpoint (i.e. isn't the last
> >committed transaction) then the journal _should_ return an error up to
> >the filesystem, so it can call ext4_error() at startup.  For e2fsck
> >(which normally does journal replay & recovery) it can do a full
> >filesystem check at this point.
> 
> hmm. it actually can be last transaction (following no activity?)

The current implementation is that if you are running with sync commits
(i.e. the current 2-phase write {data blocks} {wait} {commit block}
{wait}) and you detect a checksum error in the last transaction this
SHOULD result in the filesystem being marked in error (I haven't
verified this is in the most recent version of the code).  This is
what JBD_FEATURE_COMPAT_CHECKSUM does - it only adds checksums to the
commit blocks.

However, in the case of async commits (JBD_FEATURE_INCOMPAT_ASYNC_COMMIT
- write {data blocks} {commit block} {wait}, which is what gives the
performance gain) there isn't any way to tell the difference between a
checksum error in the last transaction and the case of an interrupted
commit.  In the case of an interrupted commit there would not have been
any checkpointing into the filesystem yet, so this case shouldn't matter.

This leaves only the "last transaction, finished async commit, started
checkpoint, crash, corruption, checksum error" case.  I agree this could
cause data corruption.  One possibility is to limit the corruption to
at most a single block by adding checksums to the transaction descriptor
blocks (which already hold the transaction ID to verify they are not
stale) and cover the block numbers.  This would seem to be the only place
that we could get error "fan out" and then we would limit the corruption
to the block(s) that were actually corrupted.  This wouldn't be any
different than having random corruption of disk blocks inside the fs.
This would probably be a separate INCOMPAT flag.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
