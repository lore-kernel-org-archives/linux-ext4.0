From: Greg KH <gregkh@suse.de>
Subject: [patch 19/36] ext4: Dont overwrite allocation_context ac_status
Date: Wed, 18 Feb 2009 14:29:32 -0800
Message-ID: <20090218222932.GT10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756996AbZBRWcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:10 -0500
Content-Disposition: inline; filename="ext4-don-t-overwrite-allocation_context-ac_status.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 032115fcef837a00336ddf7bda584e89789ea498)

We can call ext4_mb_check_limits even after successfully allocating
the requested blocks.  In that case, make sure we don't overwrite
ac_status if it already has the status AC_STATUS_FOUND.  This fixes
the lockdep warning:

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-rc6-autokern1 #1
---------------------------------------------
fsstress/11948 is trying to acquire lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278
.....

stack backtrace:
.....
 [<c04db974>] ext4_mb_regular_allocator+0xbb5/0xd44
.....

but task is already holding lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<c04d9a49>] ext4_mb_load_buddy+0x9f/0x278

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1326,6 +1326,8 @@ static void ext4_mb_check_limits(struct 
 	struct ext4_free_extent ex;
 	int max;
 
+	if (ac->ac_status == AC_STATUS_FOUND)
+		return;
 	/*
 	 * We don't want to scan for a whole year
 	 */

