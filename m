From: Andrew Morton <akpm@linux-foundation.org>
Subject: ext4-mm-delalloc-ext4.patch
Date: Fri, 29 Feb 2008 01:05:55 -0800
Message-ID: <20080229010555.21ab9c77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbYB2JG2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 04:06:28 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1T95tFx019865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 01:05:56 -0800
Received: from box (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id m1T95tG9014705
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 01:05:55 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


generic_commit_write() is scheduled for removal in 2.6.26 and is
removed already from -mm.

Please switch to the new write_begin/write_end interface.
