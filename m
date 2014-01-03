From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 filesystem bad extent error review
Date: Fri, 03 Jan 2014 11:23:54 -0600
Message-ID: <52C6F22A.4040202@redhat.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com> <20140102184211.GC10870@thunk.org> <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com> <20140103154846.GB31411@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaACRYE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 12:24:04 -0500
In-Reply-To: <20140103154846.GB31411@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/14, 9:48 AM, Theodore Ts'o wrote:
> On Fri, Jan 03, 2014 at 11:16:02AM +0800, Huang Weller (CM/ESW12-CN) wrote:
>>
>> It sounds like the barrier test. We wrote such kind test tool
>> before, the test program used ioctl(fd, BLKFLSBUF, 0) to set a
>> barrier before next write operation.  Do you think this ioctl is
>> enough ? Because I saw the ext4 use it. I will do the test with that
>> tool and then let you know the result.
> 
> The BLKFLSBUF ioctl does __not__ send a CACHE FLUSH command to the
> hardware device.  It forces all of the dirty buffers in memory to the
> storage device, and then it invalidates all the buffer cache, but it
> does not send a CACHE FLUSH command to the hardware.  Hence, the
> hardware is free to write it to its on-disk cache, and not necessarily
> guarantee that the data is written to stable store.  (For an example
> use case of BLKFLSBUF, we use it in e2fsck to drop the buffer cache
> for benchmarking purposes.)

Are you sure?  for a bdev w/ ext4 on it:

BLKFLSBUF
	fsync_bdev
		sync_filesystem
			sync_fs
				ext4_sync_fs
					blkdev_issue_flush


-Eric

