From: Eric Sandeen <sandeen@redhat.com>
Subject: delalloc fragmenting files?
Date: Fri, 26 Oct 2007 16:24:46 -0500
Message-ID: <47225B1E.2060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762581AbXJZVYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2007 17:24:48 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9QLOlOe004234
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 17:24:47 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9QLOl1s028695
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 17:24:47 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9QLOkAW019587
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 17:24:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I was doing a little seekwatchering today, and found something...
interesting.

I was doing an 8G buffered write via dd, on a machine that reports 3G of
memory, in 1M chunks like so:

dd if=/dev/zero of=/mnt/test/foobar bs=1024k count=8192

on a fairly decent hardware raid, ~90G filesystem.

Kernel is 2.6.24-rc1, with all the git patches from a day or so ago applied.

I made the ext4 fs with lustre's e2fsprogs, with -I 256, and mounted with:

mount -t ext4dev -o data=writeback,delalloc,extents,mballoc /dev/sdb7
/mnt/test

The resulting file had over 4k extents.
[root@bear-05 ~]# filefrag -v /mnt/test/foobar  | grep -i extents
File is stored in extents format
/mnt/test/foobar: 4075 extents found

http://people.redhat.com/esandeen/seekwatcher/ext4-dd-write.png

if I don't mount with delalloc:

mount -t ext4dev -o data=writeback,extents,mballoc /dev/sdb7 /mnt/test

and run the same dd, I get 229 extents:

[root@bear-05 ~]# filefrag -v /mnt/test/foobar  | grep -i extents
File is stored in extents format
/mnt/test/foobar: 229 extents found

http://people.redhat.com/esandeen/seekwatcher/ext4-dd-write-nodelalloc.png

It looks like delalloc is dribbling all over the disk....

(note: times & rates look wrong to me, something is up with blktrace I
think, but FIBMAP shouldn't lie about allocation)

-Eric
