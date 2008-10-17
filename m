From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Date: Fri, 17 Oct 2008 13:27:21 -0700
Message-ID: <20081017202721.GE5633@mail.oracle.com>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu> <20081017060424.GA26192@skywalker> <20081017100214.GB11557@mit.edu> <20081017122552.GC21503@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:26189 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYJQU3l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 16:29:41 -0400
Content-Disposition: inline
In-Reply-To: <20081017122552.GC21503@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 08:25:52AM -0400, Theodore Tso wrote:
> On Fri, Oct 17, 2008 at 06:02:14AM -0400, Theodore Tso wrote:
> > Thanks for reminding me about that; I had completely forgotten about
> > Andreas' patch.  Sure, I'll respin the patch to use his extension.
> 
> I looked more closely at Andreas' patch, and it's really not a good
> fit for what we want to do.  The problem is that it is designed to
> attach arbitrary callbacks on a per transaction basis.  Each time you
> add a callback you need to allocate a stucture, and then it gets
> chained onto a inked list.

	Yeah, I looked at a similar scheme for the buffer commit
callbacks, and I realized that it would be a total pain.  So I went with
a static callback.

> What I added was a dead-simple per-journal commit callback, with no
> additional memory allocations (and requirement to do error handling if
> the memory allocation fails), no need to take a spinlock before
> manually adding the call back to each transaction handle, no need to
> search the linked list to see if we have an entry on the linked list
> already, etc.

	And this simple callback can used by a jbd2 client to build
the machinery for per-transaction callbacks if they want.

Joel

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
