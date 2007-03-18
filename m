From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-03.diff>
Date: Sun, 18 Mar 2007 10:09:24 -0400
Message-ID: <20070318140924.GC14519@thunk.org>
References: <200702100211.l1A2BQRE007265@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60222 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbXCROJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2007 10:09:48 -0400
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2BQRE007265@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:11:26PM -0800, Brian D. Behlendorf wrote:
> blkid_dev_has_tag() will immediately return -1 (an error if value is NULL. Thus
> at the test later on value cannot be NULL. There are two possible ways to go
> about fixing this. The first would be to remove the first NULL check for value.
> The second one would be to remove the second check (and the deadcode). I could
> be persuaded either way, but to preserve existing functionality I will opt to
> remove the second check.

Better to do this the other way, I think.  It exposes more
functionality, and there shouldn't be any code that depends on
blkid_dev_has_tag returning an error is value is NULL.

					- Ted
