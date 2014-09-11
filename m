From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/25] e2fsck: fix minor errors in journal handling
Date: Thu, 11 Sep 2014 16:58:40 -0400
Message-ID: <20140911205840.GD8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231248.25904.70007.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51963 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbaIKU6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:58:43 -0400
Content-Disposition: inline
In-Reply-To: <20140908231248.25904.70007.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:48PM -0700, Darrick J. Wong wrote:
> The journal superblock's s_sequence field seems to track the tid of
> the tail (oldest) transaction in the log.  Therefore, when we release
> the journal, set the s_sequence to the tail_sequence, because setting
> it to the transaction_sequence means that we're setting the tid to
> that of the head of the log.  Granted, for replay these two are
> usually the same (and s_start == 0 anyway) so thus far we've gotten
> lucky and nobody noticed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

(Actually, for e2fsck for replay it will always be the same because
the journal *must* be completely replaied cleared before the rest of
e2fsck can be allowed to proceed.)

					- Ted

