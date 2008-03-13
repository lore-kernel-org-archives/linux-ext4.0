From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS PATCH 1/4] e2fsck: Handle a pass 2
 "should never	happen" error gracefully
Date: Wed, 12 Mar 2008 23:42:49 -0600
Message-ID: <20080313054249.GF5851@webber.adilger.int>
References: <1205385147-12855-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: bas@dev.tetra.nl, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47674 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYCMFoc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 01:44:32 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2D5iWF7014545
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 22:44:32 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXN00B01MILVB00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 12 Mar 2008 22:44:31 -0700 (PDT)
In-reply-to: <1205385147-12855-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 13, 2008  01:12 -0400, Theodore Ts'o wrote:
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -708,6 +708,9 @@ struct problem_context {
>  /* i_blocks_hi should be zero */
>  #define PR_2_BLOCKS_HI_ZERO	0x020044
>  
> +/* Unexpected HTREE block */
> +#define PR_2_UNEXPECTED_HTREE_BLOCK	0x020045

Just an FYI - this problem number conflicts with the "uninit groups"
patch.  Not a fatal problem, but I suspect that with patch-fuzz this
might apply without being noticed.  There is also a problem number
added here in the ibadness-counter patch that should be incremented.

Alternately, if you make this one 0x020048 it won't conflict with either.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

