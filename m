From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix bigalloc regression
Date: Mon, 6 Jan 2014 15:07:05 -0500
Message-ID: <20140106200705.GD28490@thunk.org>
References: <20140106184619.GB2211@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46353 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbaAFUHH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jan 2014 15:07:07 -0500
Content-Disposition: inline
In-Reply-To: <20140106184619.GB2211@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 06, 2014 at 01:46:19PM -0500, Eric Whitney wrote:
> Commit f5a44db5d2 introduced a regression on filesystems created with
> the bigalloc feature (cluster size > blocksize).  It causes xfstests
> generic/006 and /013 to fail with an unexpected JBD2 failure and
> transaction abort that leaves the test file system in a read only state.
> Other xfstests run on bigalloc file systems are likely to fail as well.
> 
> The cause is the accidental use of a cluster mask where a cluster
> offset was needed in ext4_ext_map_blocks().
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
