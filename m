From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Need to potentially watch stack usage for ext4 and AIO...
Date: Fri, 19 Jun 2009 13:59:23 -0400
Message-ID: <E1MHiN1-0002TX-Cu@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34261 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZFSR7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2009 13:59:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a 32-bit system, while running aio-stress, I got the following kernel
message:

aio-stress used greatest stack depth: 372 bytes left

That's a bit close for comfort; we may want to see if we have some
especially piggy on-stack allocations on the AIO code paths.

	   	 	  	      	     - Ted


