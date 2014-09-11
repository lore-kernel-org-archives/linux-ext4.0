From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/25 v2] tests: test e2fsck recovery of corrupt
 descriptor blocks
Date: Thu, 11 Sep 2014 18:34:54 -0400
Message-ID: <20140911223454.GI17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231355.25904.14661.stgit@birch.djwong.org>
 <20140911193141.GQ10351@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52253 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaIKWe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 18:34:57 -0400
Content-Disposition: inline
In-Reply-To: <20140911193141.GQ10351@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:31:41PM -0700, Darrick J. Wong wrote:
> Test e2fsck' ability to deal with (a) corrupt descriptor block
> checksum; (b) obviously bad journal block tid; and (c) corrupt journal
> blocks.  These should exercise the journal recovery infinite loop
> bugfix earlier in this patchset.
> 
> This test also ensures that (with metadata_csum and journal_csum_v3)
> journal replay continues past a corrupt journal block.
> 
> v2: Update j_corrupt_journal_block after a clarification of what
> revoke records actually do.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Oops, forgot to ack this earlier.

Thanks, applied.

						- Ted
