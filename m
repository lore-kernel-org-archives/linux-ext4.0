From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 15:06:23 +0200
Message-ID: <1240232783.6154.5.camel@marge.simson.net>
References: <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
	 <20090417180906.GA8363@amit-x200.pnq.redhat.com>
	 <20090417201342.GF26479@mit.edu>
	 <20090418060312.GA10943@amit-x200.pnq.redhat.com>
	 <1240039701.6298.12.camel@marge.simson.net>
	 <20090419062448.GA13272@amit-x200.pnq.redhat.com>
	 <1240218437.7005.27.camel@marge.simson.net>
	 <20090420092604.GB14699@duck.suse.cz>
	 <1240229714.6469.33.camel@marge.simson.net>
	 <20090420125653.GA28858@amit-x200.pnq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amit Shah <amit.shah@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55730 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752519AbZDTNG2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 09:06:28 -0400
In-Reply-To: <20090420125653.GA28858@amit-x200.pnq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-04-20 at 18:26 +0530, Amit Shah wrote:

> I'll re-run the tests later tonight..

I ran ext3 in all journaling modes (one run), and there was spit
difference.

(the mmap test is a bit slow and unfriendly)

marge:..tmp/tmp # ./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=ordered,acl,user_xattr
posix-fallocate run time:
        seconds:microseconds: 1240230249:280060
        seconds:microseconds: 1240230303:989879
        (approx 54s)
mmap run time:
        seconds:microseconds: 1240230304:67286
        seconds:microseconds: 1240230363:882957
        (approx 59s)
4096-sized chunk run time:
        seconds:microseconds: 1240230363:989225
        seconds:microseconds: 1240230419:242924
        (approx 56s)
8192-sized chunk run time:
        seconds:microseconds: 1240230419:365540
        seconds:microseconds: 1240230473:307148
        (approx 54s)
marge:..tmp/tmp # ./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=writeback,acl,user_xattr
posix-fallocate run time:
        seconds:microseconds: 1240230511:276152
        seconds:microseconds: 1240230565:40419
        (approx 54s)
mmap run time:
        seconds:microseconds: 1240230571:139959
        seconds:microseconds: 1240230633:254590
        (approx 62s)
4096-sized chunk run time:
        seconds:microseconds: 1240230639:300132
        seconds:microseconds: 1240230693:95665
        (approx 54s)
8192-sized chunk run time:
        seconds:microseconds: 1240230698:655975
        seconds:microseconds: 1240230753:902749
        (approx 55s)
marge:..tmp/tmp # ./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=guarded,acl,user_xattr
posix-fallocate run time:
        seconds:microseconds: 1240230802:594939
        seconds:microseconds: 1240230856:602117
        (approx 54s)
mmap run time:
        seconds:microseconds: 1240230862:792587
        seconds:microseconds: 1240230924:985089
        (approx 62s)
4096-sized chunk run time:
        seconds:microseconds: 1240230930:827949
        seconds:microseconds: 1240230985:663422
        (approx 55s)
8192-sized chunk run time:
        seconds:microseconds: 1240230991:483085
        seconds:microseconds: 1240231046:601340
        (approx 55s)
marge:..tmp/tmp # ./test-file-zero-alloc-speed 4 /dev/sdf3 /media/root ext3 rw,_netdev,noatime,data=journal,acl,user_xattr
posix-fallocate run time:
        seconds:microseconds: 1240231074:745621
        seconds:microseconds: 1240231128:740106
        (approx 54s)
mmap run time:
        seconds:microseconds: 1240231134:830362
        seconds:microseconds: 1240231193:939029
        (approx 59s)
4096-sized chunk run time:
        seconds:microseconds: 1240231199:800554
        seconds:microseconds: 1240231254:600778
        (approx 55s)
8192-sized chunk run time:
        seconds:microseconds: 1240231260:386834
        seconds:microseconds: 1240231315:121745
        (approx 55s)



