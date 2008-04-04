From: Josef Bacik <jbacik@redhat.com>
Subject: ext4 patch queue needs a patch removed
Date: Fri, 4 Apr 2008 14:06:38 -0400
Message-ID: <20080404180638.GF22429@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760053AbYDDSNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2008 14:13:35 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

It looks like

jbd2-sparse-warnings-in-revokec-journalc.patch

has already been pulled into mainline, when I went to do a quilt push -a from
-rc8 the above patch failed to apply since it was already there.  Thanks much,

Josef
