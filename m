From: Brad Figg <brad.figg@canonical.com>
Subject: Ubuntu Ext4 regression testing
Date: Wed, 12 Sep 2012 15:52:49 -0700
Message-ID: <50511241.2090603@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2ILWwx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2012 18:52:53 -0400
Received: from static-50-53-107-235.bvtn.or.frontiernet.net ([50.53.107.235] helo=[192.168.1.4])
	by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <brad.figg@canonical.com>)
	id 1TBvnf-0006zO-Ks
	for linux-ext4@vger.kernel.org; Wed, 12 Sep 2012 22:52:51 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The Ubuntu kernel team has been putting some automated testing
infrastructure in place. We are very interested in engaging with
the appropriate upstream developers. We have been running the
xfstests that come as part of the autotest testing framework.
Some of these tests fail or never complete when run against an
Ext4 file-system. Our initial questions are:

1. Is this an appropriate set of tests to be run as regression
   tests?

2. Is there a list of the xfstests that are appropriate for
   Ext4?

3. Are there additional regression tests that would be beneficial
   to the Linux community for us to be running?


Test results can be found at:
    http://kernel.ubuntu.com/testing/index.html


Thanks
Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
