From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/3] ext4: misc 3.18-rc2 bugfixes
Date: Mon, 27 Oct 2014 18:19:16 -0700
Message-ID: <20141028011916.30103.50751.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40713 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaJ1BTU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 21:19:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here are three patches against 3.18-rc2 to fix some problems that I
found in ext4.  The first fix turns on journal checksumming whenever
metadata checksumming is enabled; the second prohibits changing the
journal_checksumming feature during a remount; and the third fixes a
resource leak in extent status procfs files when the journal load
fails.

Comments and questions are, as always, welcome.  I'm done sending
patches for now.  Hopefully.

--D
