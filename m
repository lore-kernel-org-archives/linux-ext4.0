From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/74] debugfs: handle 64bit block numbers
Date: Thu, 12 Dec 2013 12:49:47 -0500
Message-ID: <20131212174947.GK13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011948.30655.17965.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39395 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3LLRtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:49:49 -0500
Content-Disposition: inline
In-Reply-To: <20131211011948.30655.17965.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:48PM -0800, Darrick J. Wong wrote:
> debugfs should use strtoull wrappers for reading block numbers from
> the command line.  "unsigned long" isn't wide enough to handle block
> numbers on 32bit platforms.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
