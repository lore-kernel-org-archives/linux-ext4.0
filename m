From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: semi-stable page writes
Date: Fri, 26 Oct 2012 03:19:09 -0700
Message-ID: <20121026101909.GB19617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46525 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2JZKTO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 06:19:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

Are people still annoyed about writes taking unexpectedly long amounts of tme
due to the stable page write patchset?  I'm guessing yes...

I'm close to posting a patchset that (a) gates the wait_on_page_writeback calls
on a flag that you can set in the bdi to indicate that you need stable writes
(which blk_integrity_register will set); (b) (ab)uses a page flag bit (PG_slab)
to indicate that a page is actually being sent out to disk hardware; and (c)
changes the three calls to wait_on_page_writeback()s that were in the original
patchset to only wait if the bit in (b) is set.  Sort of a hack, but it'll fix
some of the latency complaints.

I guess I should let that run overnight, and clean up/mail out the set tomorrow.

--D
