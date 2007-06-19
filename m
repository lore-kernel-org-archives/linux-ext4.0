From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated patches for journal checksums.
Date: Tue, 19 Jun 2007 02:51:41 -0600
Message-ID: <20070619085141.GR5181@schatzie.adilger.int>
References: <1182239437.3784.11.camel@dhcp7.linsyssoft.com> <46778DBE.3090801@clusterfs.com> <1182240928.3784.18.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45511 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXFSIvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 04:51:43 -0400
Content-Disposition: inline
In-Reply-To: <1182240928.3784.18.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 19, 2007  13:45 +0530, Girish Shilamkar wrote:
> On Tue, 2007-06-19 at 12:03 +0400, Alex Tomas wrote:
> > say, at mount time we fund transaction logged. this means part of it can be
> > on a disk. 
>
> I am not sure I understand this completely. Still I hope the following
> answers your question.

I _think_ Alex is asking "what happens if during a transaction undergoing
checkpoint of blocks to filesystem (not the last one in the journal) is
interrupted by a crash and upon restart the partially-checkpointed
transaction is found to have a checksum error?"

> > what do we do if transaction in the journal is found with wrong
> > checksum? leave partial transaction in-place?
>
> The sanity of the transaction is checked in PASS_SCAN. And if checksum
> is found to be incorrect for nth transaction then last transaction which
> is written to disk is (n - 1).

The recovery.c code (AFAIK) does not do replay for any transaction that
does not have a valid checksum, or transactions beyond that.  If the
bad transaction had already started chekpoint (i.e. isn't the last
committed transaction) then the journal _should_ return an error up to
the filesystem, so it can call ext4_error() at startup.  For e2fsck
(which normally does journal replay & recovery) it can do a full
filesystem check at this point.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
