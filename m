From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Tue, 2 Nov 2010 14:29:11 -0400
Message-ID: <20101102182911.GE25614@thunk.org>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
 <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35339 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab0KBS3Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 14:29:25 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 01, 2010 at 04:27:26PM +0100, Lukas Czerner wrote:
> 
> thank you for noticing this, because I actually do not see the warning
> (I wonder why...), but it is definitely a bug, so the trivial patch below
> should fix that.

This is a slightly less trivial fix that eliminates the need for the
"ret" variable entirely.

						- Ted

commit e048924538f0c62d18306e2fea0e22dac0140f6e
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Nov 2 14:19:30 2010 -0400

    ext4: "ret" may be used uninitialized in ext4_lazyinit_thread()
    
    Newer GCC's reported the following build warning:
    
       fs/ext4/super.c: In function 'ext4_lazyinit_thread':
       fs/ext4/super.c:2702: warning: 'ret' may be used uninitialized in this function
    
    Fix it by removing the need for the ret variable in the first place.
    
    Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
    Reported-by: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8d1d942..4d7ef31 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2699,7 +2699,6 @@ static int ext4_lazyinit_thread(void *arg)
 	struct ext4_li_request *elr;
 	unsigned long next_wakeup;
 	DEFINE_WAIT(wait);
-	int ret;
 
 	BUG_ON(NULL == eli);
 
@@ -2723,13 +2722,12 @@ cont_thread:
 			elr = list_entry(pos, struct ext4_li_request,
 					 lr_request);
 
-			if (time_after_eq(jiffies, elr->lr_next_sched))
-				ret = ext4_run_li_request(elr);
