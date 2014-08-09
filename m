From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/6] e2fsprogs Summer 2014 patchbomb, part 5
Date: Fri, 08 Aug 2014 21:26:10 -0700
Message-ID: <20140809042610.2441.6868.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18602 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIE0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 00:26:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is part 5 of the Summer 2014 e2fsprogs patchset.  Whereas all the
patches I've sent previously were to fix problems in the library and
e2fsck uncovered by the e2fuzz metadata fuzzer, we're now to the part
of the patch set that includes new features.  I'm only posting things
that have been discussed recently; the other "new" features (that have
been out for review for quite some time) haven't changed since May.
They'll be in part 6, which I'm holding onto until Ted has a chance to
look at the inline data pile of stuff.

The first new feature was suggested by Pu Hou -- the ability to create
inline data symlinks.  That's patch 1, and it requires the patches in
part 4 + the v2 patches I sent out today.

Patch 2 fixes a number of gcc warnings.

Patch 3-6 implement v2 of the e2fsck readahead functionality, which
promises to reduce fsck runtime by 10-30%.  You might want to read
the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
("e2fsck readahead speedup performance report") for all the juicy
details!

I've tested these e2fsprogs changes against the -next branch as of
8/4.  The patches follow the end of "Summer 2014 patchbomb part 4",
and have been tested against the 'make check' suite.

Comments and questions are, as always, welcome.

--D
