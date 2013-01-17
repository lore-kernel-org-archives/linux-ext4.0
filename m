From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Ext4 developers get-together at the Collab Summit
Date: Thu, 17 Jan 2013 21:15:00 +0800
Message-ID: <20130117131500.GA19272@gmail.com>
References: <nsxzk0blt27.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40649 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3AQNBJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2013 08:01:09 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so1464423pad.6
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2013 05:01:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <nsxzk0blt27.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted,

On Mon, Jan 14, 2013 at 09:48:00AM -0500, Theodore Ts'o wrote:
> Hi,
> 
> 	The Linux Foundation's Collaboration Summit is April 15-17th,
> and the Linux Storage, File System, and MM Summit is April 18-19th in
> San Francisco (at the Parc 55 hotel).
> 
> 	I'd like to organize an ext4 developer's meeting during the
> Collab Summit sometime April 15-17th, since so many of us will hopefully
> be attending LSF.  (The CFP will hopefully be coming soon for LSF.)
> 
> 	If you're interested in attending, please reply to this thread,
> and include some suggested topics that you'd be interested in
> discussing.  Based on the number of topics and the number of people who
> are planning on attending, I'll know how much time we need to reserve
> and how big of a room to request.
> 
> 	Also, if you need a invitation letter for Visa purposes, also
> please let me know.  I can arrange for the Linux Foundation to get that
> letter sent, so that folks have enough time to get a Visa.

Tao and I would like to attend the ext4 workshop this year.  Here are some
topics that we want to discuss with other folks at this meeting.

* Optimization for different devices
  We can consume more resources (e.g. Memory) for Flash/SSD device to get a
better performance.  Meanwhile we want to reduce the consumption and provide
a best effort performance for HDD in a low-end server with a ARM CPU, only 1G
memory, and 4 x 3T disks.  This are two different directions of optimization.

* Stable tree and long-term tree
  I remember that Ted has talked about ext4 stable and long-term tree.  So we
can discuss in this meeting how to maintain them and other detail.

* Extent tree disk layout
  In this mail [1], Ted metioned that extent structure could be extented to
support larger file, such as 64-bits physical block, bigger logical block, and
using cluster-size as unit in extent.  All these can make us better support
large filesystem.

1. http://comments.gmane.org/gmane.comp.file-systems.ext4/35490

* Block allocation hint
  An interface (e.g. ioctl(2)) is provided to let the app give a block
allocation hint.  Filesystem can allocate some blocks that can be read/written
faster than other blocks for a file, such as allocating blocks on outter track
in HDD.

* Latency
  Chris had presented a proposal that is 'data=guarded', which aims at imporving
the latency of sync.  We can discuss how to provide stable latency in ext4.
Forgive me that I compare two filesystems here, but the result of the following
test case shows that the latency of ext4 is higher than xfs's.  So maybe we can
improve it.

I use 'fio' to do the following test.  I revert the patches of stable page write
for avoiding the impact of it.  Meanwhile I disable delalloc feature in ext4.  I
repeat the test case serveral times, but the result of ext4 is higher than xfs.

[global]
iodepth=1
directory=/mnt/sda3
direct=0
group_reporting
thread
fallocate=0
runtime=120

[log-append]
ioengine=sync
rw=write
bs=4k
size=10g
filesize=10g
rate=5m
numjobs=1

I pick the best result of two filesystems and paste them here.

[ext4]
  write: io=614404KB, bw=5119.2KB/s, iops=1279 , runt=120001msec
    clat (usec): min=11 , max=149 , avg=14.12, stdev= 1.73
     lat (usec): min=11 , max=150 , avg=14.54, stdev= 1.81

[xfs]
  write: io=614404KB, bw=5119.2KB/s, iops=1279 , runt=120001msec
    clat (usec): min=4 , max=89 , avg= 8.42, stdev= 1.85
     lat (usec): min=4 , max=89 , avg= 8.80, stdev= 1.94


BTW, Tao and I need a invitation letter for applying our visa.  Please let me
know if there are something we need to do.

Thanks,
						- Zheng
