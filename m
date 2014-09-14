From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/2] ext4/jbd2: misc 3.17 bugfixes, part 2
Date: Sun, 14 Sep 2014 10:32:53 -0700
Message-ID: <20140914173252.31996.86784.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40512 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaINRc5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2014 13:32:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here are two more patches against 3.17-rc4 to fix some minor problems
in jbd2 and ext4.  Neither of these two depend on each other; they fix
separate small bugs.

The first patch teaches ext4 to check the e_value_offs value in the
extended attribute data structure to avoid data corruption and
kernel crashes resulting from the corruption.  This fixes the crash I
alluded to in the previous 3.17 bugfixes email pile.

The second patch fixes a bh leak in the journal replay code when a
descriptor block fails checksum verification.

Patches are against 3.17-rc4, and have been xfstest'd.

Comments and questions are, as always, welcome.

--D
