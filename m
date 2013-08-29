From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH v1 0/6] e2fsprogs 8/2013 patchbomb
Date: Wed, 28 Aug 2013 17:43:44 -0700
Message-ID: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3H2Anv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:43:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a pile of random patches that I've been working on.  They're not really
related to each other, though there are some bugfixes at the start.  The first
two patches were sent to linux-ext4 on July 22nd and August 12th and haven't
changed substantially.

The first patch fixes a double-free crash when resize2fs'ing a MMP filesystem.

The next two fix blk_t overflow problems by widening the fields to blk64_t.
One of the patches fixes something that Eric Sandeen was complaining about.

The fourth patch makes it so you can sparse-check e2fsprogs with make C=[12].
Offhand it looks like there are more than a few spots where we should have
converted things to blk64_t but haven't yet.  There are also nastier spots
where 64-bit values get crammed into 32-bit fields (or so sparse thinks) that I
will triage later.

The fifth patch experimentally enables zeroing of inode tables when disabling
checksumming in tune2fs.

The sixth patch modifies resize2fs to toggle 64bit support, with all the
necessary block migrations that might arise from that.  It will probably eat
your data.

I've lightly tested these e2fsprogs changes against the head branch as of a few
days ago.  After a longish while I think I've managed to reconstruct my old
metadata checksumming test program from the old days, so I've posted that
version here:
https://gist.github.com/djwong/6372995

Comments and questions are, as always, welcome.

--D
