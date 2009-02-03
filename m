From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Coccinelle/spatch patches for e2fsprogs
Date: Tue, 3 Feb 2009 13:49:20 -0500
Message-ID: <20090203184920.GE20654@shell>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZBCStY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 13:49:24 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n13InKKE032467
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 13:49:20 -0500
Received: from shell.devel.redhat.com (shell.devel.redhat.com [10.10.36.195])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n13InMmb002380
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 13:49:22 -0500
Received: from shell.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by shell.devel.redhat.com (8.13.8/8.13.8) with ESMTP id n13InKdZ001034
	for <linux-ext4@vger.kernel.org>; Tue, 3 Feb 2009 13:49:20 -0500
Received: (from vaurora@localhost)
	by shell.devel.redhat.com (8.13.8/8.13.8/Submit) id n13InKEv001033
	for linux-ext4@vger.kernel.org; Tue, 3 Feb 2009 13:49:20 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I began using Coccinelle towards the end of the e2fsprogs 64bit
conversion and thought my scripts might be useful to share.  I have
made no effort to clean them up and at best they did not cover all
cases, but they made life much easier for me.  They might make a good
starting point for other people converting to new interfaces in
e2fsprogs.

You can get spatch/Coccinelle here:

http://www.emn.fr/x-info/coccinelle/#download

A brief tutorial is here:

http://lwn.net/Articles/315686/

-VAL
--FCuugMFkClbJLl1L
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="e2fsprogs_cocci.tar.gz"
Content-Transfer-Encoding: base64

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

--FCuugMFkClbJLl1L--
