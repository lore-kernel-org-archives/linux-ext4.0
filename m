From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Thu, 3 Feb 2011 13:38:55 -0500
Message-ID: <20110203183854.GA2623@thunk.org>
References: <AANLkTinadVSGuoZwtNfahxVYneRDUe_4_qpyuoidHoVd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jon Nelson <jnelson@jamponi.net>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33593 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab1BCSjA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 13:39:00 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinadVSGuoZwtNfahxVYneRDUe_4_qpyuoidHoVd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, added to the ext4 patch queue.

I modified the commit description slightly to give credit to Jon
Nelson, who reported the bug and really helped by devising a
reproduceable test case.  Many thanks, Jon!!

							- Ted

ext4: Fix data corruption with multi-block writepages support

From: Curt Wohlgemuth <curtw@google.com>

This fixes a corruption problem with the multi-block
writepages submittal change for ext4, from commit
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc ("ext4: use bio
layer instead of buffer layer in mpage_da_submit_io").

(Note that this corruption is not present in 2.6.37 on
ext4, because the corruption was detected after the
feature was merged in 2.6.37-rc1, and so it was turned
off by adding a non-default mount option,
mblk_io_submit.  With this commit, which hopefully
fixes the last of the bugs with this feature, we'll be
able to turn on this performance feature by default in
2.6.38, and remove the mblk_io_submit option.)

The ext4 code path to bundle multiple pages for
writeback in ext4_bio_write_page() had a bug: we should
be clearing buffer head dirty flags *before* we submit
the bio, not in the completion routine.

The patch below was tested on 2.6.37 under KVM with the
postgresql script which was submitted by Jon Nelson as
documented in commit 1449032be1.

Without the patch, I'd hit the corruption problem about
50-70% of the time.  With the patch, I executed the
script > 100 times with no corruption seen.

I also fixed a bug to make sure ext4_end_bio() doesn't
dereference the bio after the bio_put() call.

Reported-by: Jon Nelson <jnelson@jamponi.net>
Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
