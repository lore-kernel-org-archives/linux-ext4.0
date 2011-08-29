From: Ted Ts'o <tytso@mit.edu>
Subject: KVM-based xfstests appliance
Date: Mon, 29 Aug 2011 09:32:48 -0400
Message-ID: <20110829133248.GC12187@thunk.org>
References: <20110828235437.GA12187@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54532 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab1H2Ncv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Aug 2011 09:32:51 -0400
Content-Disposition: inline
In-Reply-To: <20110828235437.GA12187@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 28, 2011 at 07:54:37PM -0400, Ted Ts'o wrote:
> Has anyone else noticed failures with xfstests #74?  What I'm finding
> is that if compile the fstest program so that it is statically linked,
> I can't get it to fail:

I've put up an my KVM-based xfstests appliance here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/V-xfstests.tar.gz

Hopefully this will be useful for other people who are trying to do QA
work for ext4.  I find it's much more convenient to test out a kernel
by running "kvm-xfstests smoke", or "kvm-xfstests full".

BTW, I've found that the xfstests 74 test failure is very timing
dependent.  It doesn't fail when I use another system which has faster
disks than dm-crypt'ed laptop drives, and where writeback mode is
enabled with lots of memory available for caching purposes.  It seems
to require memory pressure and slower disks.  I should check and see
whether it involves ext4_writepage() getting invoked out of the direct
reclaim path...

	     	     	    	      	  	  - Ted
