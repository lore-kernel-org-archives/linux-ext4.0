From: Matthias Koenig <mkoenig@suse.de>
Subject: [PATCH] libuuid: don't use unitialized variable
Date: Tue, 06 May 2008 13:38:31 +0200
Message-ID: <n7xhcdbd5mw.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:60210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYEFLfY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2008 07:35:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

tv is not initialized before the assigment to last.

Signed-Off-By: Matthias Koenig <mkoenig@suse.de>

Index: e2fsprogs-1.40.8/lib/uuid/gen_uuid.c
===================================================================
--- e2fsprogs-1.40.8.orig/lib/uuid/gen_uuid.c
+++ e2fsprogs-1.40.8/lib/uuid/gen_uuid.c
@@ -316,7 +316,7 @@ static int get_clock(uint32_t *clock_hig
 	if ((last.tv_sec == 0) && (last.tv_usec == 0)) {
 		get_random_bytes(&clock_seq, sizeof(clock_seq));
 		clock_seq &= 0x3FFF;
-		last = tv;
+		gettimeofday(&last, 0);
 		last.tv_sec--;
 	}
 


