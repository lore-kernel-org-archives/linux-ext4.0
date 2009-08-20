From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC -V2 3/4] ext4: Fix bugs in mballoc's stream
	allocation mode
Date: Thu, 20 Aug 2009 14:20:05 -0400
Message-ID: <20090820182005.GG7076@mit.edu>
References: <1249874635-24250-1-git-send-email-tytso@mit.edu> <1249874635-24250-4-git-send-email-tytso@mit.edu> <20090820072238.GA26977@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57679 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbZHTSUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 14:20:10 -0400
Content-Disposition: inline
In-Reply-To: <20090820072238.GA26977@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:52:38PM +0530, Aneesh Kumar K.V wrote:
> 
> This would give bad allocation pattern for large files. We should be
> using global goal only for small files not for large files. 

Huh?  Small files should be allocated within their flex_bg close to
their parent directories, right?  Large files are supposed to
allocated globally, potentially outside of the flex_bg so they won't
chew up all of the space in the local flex_bg.  

Also, the comments ext4.h for s_mb_last_group and s_mb_last_start
indicate: "where last allocation was done - for stream allocation".
If your interpretation was correct, the comment would be wrong.

> Large files should be using neighbour allocated extent block as the
> goal, so that we get contiguous blocks.

We do use the neighbour allocated extent block as the goal.  The code
in question here is used only when the ext4_mb_find_by_goal() has
failed.

This brings up the larger problem which is the mballoc code is
extremely hard to understand, and not sufficiently documented, where
the algorithm is broken up so many pieces that unless you spend a long
time mind-melding with the code, it's sometimes very hard to get a
mental map of the forest versus the trees.

					- Ted
