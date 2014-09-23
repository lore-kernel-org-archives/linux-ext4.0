From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 3/10] byteorder: Fix some erroneous comments
Date: 23 Sep 2014 06:10:58 -0400
Message-ID: <20140923101058.29652.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: dhowells@redhat.com, linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:40910 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755270AbaIWKK7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:10:59 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The prototypes obviously didn't make sense.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: David Howells <dhowells@redhat.com>
---
I'm not sure who to submit this through.  Obviously, it's
hardly a critical bug fix, but it's potentially confusing.

 include/linux/byteorder/generic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b9..37b3d9d6 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -70,12 +70,12 @@
  *	[bl]eXX_to_cpu(__uXX x)
  *
  * The same, but takes a pointer to the value to convert
- *	cpu_to_[bl]eXXp(__uXX x)
- *	[bl]eXX_to_cpup(__uXX x)
+ *	cpu_to_[bl]eXXp(const __uXX *x)
+ *	[bl]eXX_to_cpup(const __uXX *x)
  *
  * The same, but change in situ
- *	cpu_to_[bl]eXXs(__uXX x)
- *	[bl]eXX_to_cpus(__uXX x)
+ *	cpu_to_[bl]eXXs(__uXX *x)
+ *	[bl]eXX_to_cpus(__uXX *x)
  *
  * See asm-foo/byteorder.h for examples of how to provide
  * architecture-optimized versions
-- 
2.1.0

