From: Theodore Tso <tytso@mit.edu>
Subject: Re: What to do when the journal checksum is incorrect
Date: Wed, 4 Jun 2008 19:40:57 -0400
Message-ID: <20080604234057.GA9641@mit.edu>
References: <E1K02Jh-0002wf-2e@closure.thunk.org> <1212488533.3272.23.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45789 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbYFDXlS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 19:41:18 -0400
Content-Disposition: inline
In-Reply-To: <1212488533.3272.23.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2008 at 03:52:13PM +0530, Girish Shilamkar wrote:
> I went through the code and also re-ran the e2fsprogs tests which we had
> sent upstream for journal checksum. And found that if the transaction is
> bad it is marked as info->end_transaction which indicates a bad
> transaction and is not replayed.

You're correct; my apologies.  I had misplaced or misfiled your
patches, and recreated the patch to support async checksums, and I
screwed up the patch by missing this change at the end of
do_one_pass()

	if (pass == PASS_SCAN) {
-		info->end_transaction = next_commit_ID;
+		if (!info->end_transaction)
+			info->end_transaction = next_commit_ID;
	} else {
		/* It's really bad news if different passes end up at
		 * different places (but possible due to IO errors). */

My patch to fix the buffer head leak is still relevant, though, and
I've created a patch to reflect the error up to ext4.

> > Worse yet, no indication of any problems is
> > sent back to the ext4 filesystem code.
> This definitely is not present and needs to be incorporated. 
> 

I will send the patches that I've placed into the ext4 patch queue
relevant to the journal checksum code on this thread.

	    			      	      - Ted
