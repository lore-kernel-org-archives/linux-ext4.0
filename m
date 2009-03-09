From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
	extent trees.
Date: Mon, 9 Mar 2009 07:36:19 -0400
Message-ID: <20090309113619.GH5578@mit.edu>
References: <49B18CAB.5020605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45361 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZCILgX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 07:36:23 -0400
Content-Disposition: inline
In-Reply-To: <49B18CAB.5020605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 06, 2009 at 02:50:51PM -0600, Eric Sandeen wrote:
> This should resolve kernel.org bugzilla 12821
> 
> I've not actually crafted a workload to exercise this code; 
> this is from inspection...

Hmm, so I've been trying to create a test case, but the test cases
I've created (which e2fsck say are fine) aren't causing complaints by
the kernel.

Please see:

       http://master.kernel.org/~tytso/deep-tree/

deep-tree.img.gz contains an extent tree of depth 3, and
deep-tree-2.img.gz contains an extent tree of depth 4....

		   	       	      - Ted
