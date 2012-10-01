From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] ext3_bread usage audit due non-initialized variable
Date: Mon,  1 Oct 2012 16:50:53 -0300
Message-ID: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2JATtP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2012 15:49:15 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q91JnFjE013434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2012 15:49:15 -0400
Received: from hades.maiolino.org.com (ovpn-113-128.phx2.redhat.com [10.3.113.128])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q91JnEF5013279
	for <linux-ext4@vger.kernel.org>; Mon, 1 Oct 2012 15:49:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a backport from ext4 to fix a possible non-initialized variable and
wrong behaviour of ext3_bread() callers caused due this.

Carlos Maiolino (2):
  ext3: fix possible non-initialized variable on
    htree_dirblock_to_tree()
  ext3: ext3_bread usage audit

 fs/ext3/namei.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 10 deletions(-)

-- 
1.7.11.4

