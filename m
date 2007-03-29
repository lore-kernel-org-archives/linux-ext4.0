From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch
Date: Thu, 29 Mar 2007 14:07:23 -0400
Message-ID: <20070329180723.GA12666@thunk.org>
References: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45961 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030588AbXC2SHZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2007 14:07:25 -0400
Content-Disposition: inline
In-Reply-To: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

FYI,

I have appled patches to fix all of the Coverity problems reported
except for cid-02.diff, for which the correct fix is to rewrite
ss_current_request() to be a function with proper testing of ss_idx
instead of patching out the error check.

						- Ted
