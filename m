From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: be explicit if external journal device is not found
Date: Thu, 01 Apr 2010 14:26:30 -0500
Message-ID: <4BB4F366.9030404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Richard W.M. Jones" <rjones@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0DAT0f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 15:26:35 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o31JQYD6011136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 15:26:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This for RH bug #572935 -
RFE: Misleading error message from mke2fs -J option

If the journal device UUID is typo'd or otherwise not found,
the error message looks like it's a usage() type of problem.

It'd be helpful to explicitly say that the device requested
could not be found.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/util.c b/misc/util.c
index b8a3cac..51bdb60 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -207,6 +207,10 @@ void parse_journal_opts(const char *opts)
 		if (strcmp(token, "device") == 0) {
 			journal_device = blkid_get_devname(NULL, arg, NULL);
 			if (!journal_device) {
+				if (arg)
+					fprintf(stderr, _("\nCould not find "
+						"journal device matching %s\n"),
+						arg);
 				journal_usage++;
 				continue;
 			}

