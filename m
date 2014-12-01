From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: xfstests failures w/ metadata_csum
Date: Mon, 1 Dec 2014 12:20:45 -0800
Message-ID: <20141201202045.GR10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41152 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAUUv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 15:20:51 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

Could you remind me which xfstests are failing in 3.18-rc3+ with metadata_csum
enabled?  I think you said generic/034, generic/321, and generic/322, but were
there more?

AFAICT the ext4 mount fails because it can't load the journal, and the journal
can't replay because jbd2_descr_block_csum_verify() fails; the 034 test appears
to drop all the writes related to the umount.  recovery.c doesn't say anything
when the journal descriptor block fails csum verification, though it should.
Not sure why we end up with corrupt-looking descriptor blocks.

The reason why this appears in -rc3 is because that's when we added the patch
that forces journal_checksum on whenever metadata_csum is on, and I guess
few people were testing journal_checksum with xfstests before that.

--D
