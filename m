From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 11:07:17 +0200
Message-ID: <1240218437.7005.27.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
	 <20090417180906.GA8363@amit-x200.pnq.redhat.com>
	 <20090417201342.GF26479@mit.edu>
	 <20090418060312.GA10943@amit-x200.pnq.redhat.com>
	 <1240039701.6298.12.camel@marge.simson.net>
	 <20090419062448.GA13272@amit-x200.pnq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amit Shah <amit.shah@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751001AbZDTJHW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 05:07:22 -0400
In-Reply-To: <20090419062448.GA13272@amit-x200.pnq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-04-19 at 11:54 +0530, Amit Shah wrote:
> On (Sat) Apr 18 2009 [09:28:21], Mike Galbraith wrote:

> > Probably because you're swapping heavily, and that is perturbing your
> 
> The variance only affects the 4k test; the other times more or less
> remain the same.

My box disagrees.

(bumps ulimits to test 4BG... OS+swap live on sdb btw)

./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=foo,acl,user_xattr

foo=guarded
4k   225  141   80  142  361
8k    74   96  362   78   84
mm    55   57   57   57   57

foo=writeback
4k   179  264  187  125   93
8k    94  161   73  334   84
mm    57   58   57   56   57

foo=ordered
4k    81   74   76   80   75
8k    77   76  224   79   79 
mm    59   56   60   58   59

foo=journal
4k    95  297   69   83  420
8k    73  139  158   80   78
mm    57   58   56   59   56

./test-file-zero-alloc-speed 2 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=foo,acl,user_xattr

foo=guarded
4k    28   27   27   28   28
8k    28   27   27   28   27

foo=writeback
4k    27   27   27   27   27
8k    28   28   27   27   28

All journal modes seem subject to bad throughput under heavy pressure,
though data=ordered seems much less likely to suffer for some reason.
Major difference _seems_ to be that write()+largefile induces very much
swap activity.

	-Mike

