From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/25] debugfs: add the ability to write transactions to
 the journal
Date: Thu, 11 Sep 2014 16:58:50 -0400
Message-ID: <20140911205850.GE8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231254.25904.66246.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51969 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaIKU6w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 16:58:52 -0400
Content-Disposition: inline
In-Reply-To: <20140908231254.25904.66246.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:54PM -0700, Darrick J. Wong wrote:
> Extend debugfs with the ability to create transactions and replay the
> journal.  This will eventually be used to test kernel recovery and
> metadata_csum recovery.
> 
> v2: Find the FS context without using j_inode, since it won't always
> be valid; allow user to specify external journal file; start writing
> transactions at j_first.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
