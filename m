From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Thu, 17 Nov 2011 10:11:07 -0500
Message-ID: <8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu> <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com> <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com> <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:60902 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757785Ab1KQPLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Nov 2011 10:11:06 -0500
In-Reply-To: <CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 17, 2011, at 12:35 AM, NamJae Jeon wrote:

> We prevent one node being concentrating workload from redundant
> alloc/free by balancing workload to other nodes in performance side.
> and we can avoid reclaim probability a little by allocation from only
> local node also.

Can you say more about this?   I'm afraid I don't understand what you
are trying to do here.

What I'm worried about is systems where the memory latency time for
local versus remote nodes might be 2-3 to 1.  That is, it takes 2-3 times
as much time to access memory on a remote node.   (On older machines,
the memory access time ratio's could have been as bad as 12:1 or 15:1.)

So accessing non-local memory can be a really, really big deal.  And this
isn't just theoretical, but have you considered what might happen on a 8
core AMD machine?

Regards,

-- Ted

