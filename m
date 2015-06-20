From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] debugfs/set_fields: fix several errors and add
 assertions
Date: Fri, 19 Jun 2015 22:01:58 -0400
Message-ID: <20150620020158.GD29480@thunk.org>
References: <20150225094728.14523.52763.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46049 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbbFTCCC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2015 22:02:02 -0400
Content-Disposition: inline
In-Reply-To: <20150225094728.14523.52763.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2015 at 12:47:28PM +0300, Konstantin Khlebnikov wrote:
> Fix copy-n-paste errors:
> * remove duplicate "lastcheck" and "min_extra_isize"
> * fix pointer for "first_error_line" and "last_error_line"
> * remove superblock field "inodes_count" from inode fields
> * add null-termination for mmp_fields
> 
> Add assertions for catching such errors in the future.
> Mark true aliases with flag "FLAG_ALIAS" and suppress assert for them.
> 
> v2: check tables in unit test "debugfs/tst_set_fields"
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Applied, thanks.   Apologies for the delay.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
