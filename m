From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: e2fsprogs make check fails
Date: Mon, 4 May 2015 22:48:18 -0700
Message-ID: <20150505054818.GI11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34067 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbEEFsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2015 01:48:24 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Uhh... I pulled the latest e2fsprogs -next and tried to run 'make check'.
I think tst_sha256 (and maybe tst_sha512?) need to be pulled out of the
Makefiles?

--D
