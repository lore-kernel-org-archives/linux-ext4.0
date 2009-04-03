From: "Nick Hennenfent (nhennefe)" <nhennefe@cisco.com>
Subject: EXT4 in embedded systems
Date: Fri, 3 Apr 2009 11:01:15 -0400
Message-ID: <2FE093E39DAE7D498A29AF6BE01F267B04E42DE6@xmb-rtp-20c.amer.cisco.com>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "Ext4 Developers List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:7591 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZDCPBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 11:01:17 -0400
Received: from sj-core-2.cisco.com (sj-core-2.cisco.com [171.71.177.254])
	by sj-dkim-2.cisco.com (8.12.11/8.12.11) with ESMTP id n33F1FMl028745
	for <linux-ext4@vger.kernel.org>; Fri, 3 Apr 2009 08:01:15 -0700
Received: from xbh-rtp-211.amer.cisco.com (xbh-rtp-211.cisco.com [64.102.31.102])
	by sj-core-2.cisco.com (8.13.8/8.13.8) with ESMTP id n33F1DEb013790
	for <linux-ext4@vger.kernel.org>; Fri, 3 Apr 2009 15:01:15 GMT
Content-class: urn:content-classes:message
In-Reply-To: <1238742067-30814-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi all,

I am currently running kernel 2.6.15 on an embedded mips system.

I really would like to be able to use the ext4 file system.

I can easily upgrade to kernel 2.6.22 but not any further.

I would like to get the latest and greatest stable ext4 code onto this
box.

Is it possible to back-port the latest ext4 code to the 2.6.22 kernel?

Or, is there a better way to go about it?

Thanks,
Nick Hennenfent
Cisco IPTV
 

-----Original Message-----
From: linux-ext4-owner@vger.kernel.org
[mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of Theodore Ts'o
Sent: Friday, April 03, 2009 3:01 AM
To: torvalds@linuxfoundation.org
Cc: Linux Kernel Developers List; Ext4 Developers List
Subject: [GIT PULL] Ext3 latency fixes

Hi Linus, 

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
ext3-latency-fixes

I posted these patches a while back, and with your "overwrite.c" test
case, I decided to see how they did.  The results were spectacular
enough (see below) that I've decided to request that they be included
in 2.6.30.  I've posted the critical patches below for review before,
and Jan Kara has acked them, and there have been no complaints about
them.

I've also added two patches which add replace-via-truncate and
replace-via-rename workarounds to ext3's data=writeback mode.  They
only change the behavior in the (currently non-default) data=writeback
mode.

The benchmark which I used was Linus's overwrite.c as the background
workload, and my fsync-tester as the foreground tester.  The
fsync-tester writes a megabyte to a file and then times how long it
takes to fsync that file, and then sleeps a second before repeating.

Using an unpatched 2.6.29, fsync-tester shows the following times:

fsync time: 3.4732
fsync time: 2.4338
fsync time: 5.9496
fsync time: 6.2402
fsync time: 4.3375
fsync time: 6.3283
fsync time: 3.6930
fsync time: 3.1848
fsync time: 3.3231

The final report of overwrite.c is:

       1.984 GB written in 82.75 (24 MB/s)           

With these patches applied, the fsync-tester times are:

fsync time: 1.4538
fsync time: 1.6328
fsync time: 1.4632
fsync time: 1.4550
fsync time: 0.2932
fsync time: 1.6986
fsync time: 0.3787
fsync time: 1.3380
fsync time: 1.8145
fsync time: 0.4050
fsync time: 1.3880

... and the final report of overwrite.c is:

       1.984 GB written in 93.77 (21 MB/s)           

By having the fsync-related I/O fixed to be posted using WRITE_SYNC,
instead of WRITE, it prioritizes the fsync-related I/O so that it gets
done ahead of the streaming write.  This does slow down the background
write process, but it speeds up the worst-case fsync() latency from
6.2 seconds to 1.8 seconds.  (Measurements done on a 5400 rpm laptop
drive.)

All aside from the benchmark improvements, if the writes are coming
from fsync(), they really are synchronous operations, and they should
be marked that way just from a correctness point of view.

	       		 	       	    - Ted

Theodore Ts'o (4):
      block_write_full_page: Use synchronous writes for WBC_SYNC_ALL
writebacks
      ext3: Use WRITE_SYNC for commits which are caused by fsync()
      ext3: Add replace-on-truncate hueristics for data=writeback mode
      ext3: Add replace-on-rename hueristics for data=writeback mode

 fs/buffer.c             |    5 +++--
 fs/ext3/file.c          |    4 ++++
 fs/ext3/inode.c         |    3 +++
 fs/ext3/namei.c         |    6 +++++-
 fs/jbd/commit.c         |   23 +++++++++++++++--------
 fs/jbd/transaction.c    |    2 ++
 include/linux/ext3_fs.h |    1 +
 include/linux/jbd.h     |    5 +++++
 8 files changed, 38 insertions(+), 11 deletions(-)




--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
