From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Mon, 1 Nov 2010 16:27:26 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0KAP1k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Nov 2010 11:27:40 -0400
In-Reply-To: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 31 Oct 2010, Stefan Richter wrote:

> Commit bfff68738f1c "ext4: add support for lazy inode table
> initialization" added the following build warning:
> 
> fs/ext4/super.c: In function 'ext4_lazyinit_thread':
> fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function
> 
> This warning is due to an actual bug.  But I don't know what the fix is.
> 

Hi Stefan,

thank you for noticing this, because I actually do not see the warning
(I wonder why...), but it is definitely a bug, so the trivial patch below
should fix that.

Thanks!
-Lukas

>From 3594c17e3f724356ea8cc0a1579ab09990a771ac Mon Sep 17 00:00:00 2001
From: Lukas Czerner <lczerner@redhat.com>
Date: Mon, 1 Nov 2010 15:44:54 +0100
Subject: [PATCH] ext4: fix using uninitialized variable

The ret variable might be used uninitialized. Fix this by  initializing
it in definition.

Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
Reported-by: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8d1d942..aff17cf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2699,7 +2699,7 @@ static int ext4_lazyinit_thread(void *arg)
 	struct ext4_li_request *elr;
 	unsigned long next_wakeup;
 	DEFINE_WAIT(wait);
-	int ret;
+	int ret = 0;
 
 	BUG_ON(NULL == eli);
 
-- 
1.7.2.3

