From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 09:38:03 -0400
Message-ID: <20080815133803.GL13048@mit.edu>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38616 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753452AbYHONiT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 09:38:19 -0400
Content-Disposition: inline
In-Reply-To: <20080814231816.GA13048@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's an interesting data point.  Using Chris Mason's compilebench:

http://oss.oracle.com/~mason/compilebench

If I use:

./compilebench  -D /mnt -i 2 -r 0

on a 4GB machine such that I have plenty of memory (and nothing gets
forced disk due to memory pressure), I don't see hardly any of the
small file fragmentation problem (0.8% of the inodes in use on the
filesystem.  This is with your patch applied.

However, if I use:

./compilebench  -D /mnt -i 10 -r 0

so that data blocks are getting pushed out due to memory pressure,
then I see plenty of non-contiugous inodes (8.1% of the inodes in use
on the filesystem).  So with your patch applied, it seems that we
still have a problem related to delayed allocation and how the VM
system is doing its page cleaning.

						- Ted
