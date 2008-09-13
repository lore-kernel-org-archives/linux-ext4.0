From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: YET ANOTHER resend of the fiemap patches
Date: Sat, 13 Sep 2008 14:47:09 -0400
Message-ID: <E1Kea9F-0004L5-Ds@closure.thunk.org>
Cc: Mark Fasheh <mfasheh@suse.com>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39389 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbYIMSrO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 14:47:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


So the last round of the on-going round-and-round of the FIEMAP patches
went to the linux-ext4 mailing list, because of a query there about why
these patches had been stalled for so long.  This resulted in a private
set of e-mails attacking an ext4 developer and putting forward a
conspiracy theory that these patches were trying to be snuck in, despite
the fact that they have been sent on linux-fsdevel at least 4 times
already.

Mark has at this point I believe answered all of Christoph Hellwig's
demands, and put forward a request to Andrew Morton to include them in
-mm (minus the ext4 patch, since the version he had no longer compiled).

As of this writing, Andrew has not put them into -mm, I suspect because
he perceives there is still controversies around these patches, despite
the fact that most of the e-mails and time wasted has been over
individual bitflags and other really tiny nit-picky details.  So I am
re-sending these patches out for review on linux-fsdevel.  The first
three patches are taken from Mark's fiemap branch on the ocfs2 branch.
The last patch is an updated ext4 patch from the ext4 patch queue, which
is provided so that folks can see that the fiemap patches work just fine
on ext4.

Given that filesystem designers seem to love nit-picking tiny details,
and I am personally starting to lose patience, if the fiemap patches
stalls any further, my plan is to take a page from the XFS playbook and
simply take the ext4-fiemap patch and implement an ext4-specific ioctl.
If and when the linux-fsdevel community manages come to consensus on the
fiemap patches, whether it happens in 2.6.28 or Linux 2.6.87, it will be
easy enough to wire the ext4 support to the generic fiemap ioctl.

	"It's *just* an ioctl, folks" --- Andreas Dilger

Yours disgustedly,

						- Ted

