From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Sat, 19 Nov 2011 16:06:58 -0500
Message-ID: <710B9EAE-A4C8-4E8F-9AA1-F6CBDC84FD54@mit.edu>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu> <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com> <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	Namjae Jeon <linkinjeon@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:45430 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1KSVHF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Nov 2011 16:07:05 -0500
In-Reply-To: <CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 17, 2011, at 12:11 AM, Amit Sahrawat wrote:
> We looked for the details regarding the introduction of
> SLAB_MEM_SHARED(http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-02/msg01409.html
> - provide the slab cache infrastructure to support cpuset memory
> spreading), and further the changes were introduced across all
> filesystems - http://lwn.net/Articles/173654/.

The main thing I see when I look at this list was it was focused only on the file system's inode structures, or other structures which were long lived and likely to be accessed from many NUMA nodes other than the one where it was originally allocated.

It's unfortunate that this has gotten turned into a much broader generalization that all slab caches should have this flag set.   Perhaps it might be interesting to reflect on the fact that if it was always good to do this, that a flag wouldn't be used to control this behavior, but rather it would be done conditionally?

It's all very good to send  lots of clean up patches, perhaps as a way to learn how to submit kernel patches.   But I would ask people who do this to understand a bit more deeply what is going on.  What's most important for people who are getting started with kernel development is not so much the mechanics of submitting patches, but understanding why things work the way they do.

Best regards,

-- Ted

