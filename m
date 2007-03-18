From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-02.diff>
Date: Sun, 18 Mar 2007 10:04:21 -0400
Message-ID: <20070318140421.GB14519@thunk.org>
References: <200702100211.l1A2BHsG007115@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47901 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXCROEk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2007 10:04:40 -0400
Content-Disposition: inline
In-Reply-To: <200702100211.l1A2BHsG007115@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:11:17PM -0800, Brian D. Behlendorf wrote:
> Looks like ss_current_request is a macro that will set code to 0. This test
> will always be false. I will remove this error case.

The ss library is pretty stable, yes, but it's a bad idea to remove an
error check which is mandated by the interface defintion; what if the
implementation changes in the future?

Probably the better way to shut up coverity in this case is to replace
the current implementation of ss_current_request with a C version
which checks to make sure sci_idx is valid (as opposed to blindly
indexing off the array and potentially causing a seg fault), and
returning EINVAL if sci_idx is invalid.

I will NOT do this fixup now, but I will queue it in a future
(low-priority) TODO list.  Fixes to do this are welcome.

					- Ted
