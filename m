From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Fwd: [Bug 9732] New: oops in extent code via ext4_fallocate]
Date: Sat, 12 Jan 2008 22:01:44 +0530
Message-ID: <20080112163144.GA6546@skywalker>
References: <4787D498.1050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52581 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYALQby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2008 11:31:54 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0CGVQtC007894
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 03:31:26 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0CGVqsx1265788
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 03:31:52 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0CGVrVk015557
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2008 03:31:53 +1100
Content-Disposition: inline
In-Reply-To: <4787D498.1050202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2008 at 02:42:00PM -0600, Eric Sandeen wrote:

> 
> The BUG_ON is:
> 
>         BUG_ON(*logical < le32_to_cpu(ex->ee_block) + le16_to_cpu(ex->ee_len));
> 
> where these were the values:
> 
>         logical 8 ee_block 0 ee_len 32776
> 
> Haven't looked further into it yet.
> 

Not able to reproduce. Why is it calling ext4_ext_search_left for that
value of logical ? ext4_ext_get_blocks should have found that the
logical belong to an already existing extent and return from there. It
should have returned from

2365      if (create == EXT4_CREATE_UNINITIALIZED_EXT)
2366               goto out;


root@qemu-image:/ext4# /root/testfallocate  -f a 0 100
# FALLOCATE TEST REPORT #
        New blocks preallocated = 0.
        Number of bytes preallocated = 0
        Old file size = 100, New file size 100.
        Old num blocks = 4, New num blocks 4.


### TESTS PASSED ###
root@qemu-image:/ext4# ls -alh a
-rw-r--r-- 1 root root 100 Jan  9 16:23 a
root@qemu-image:/ext4# /root/truncate  ./a 50
root@qemu-image:/ext4# ls -alh a
-rw-r--r-- 1 root root 50 Jan  9 16:23 a
root@qemu-image:/ext4# /root/testfallocate  -f a 0 100
# FALLOCATE TEST REPORT #
        New blocks preallocated = 0.
        Number of bytes preallocated = 0
        Old file size = 50, New file size 100.
        Old num blocks = 4, New num blocks 4.


### TESTS PASSED ###
root@qemu-image:/ext4# ls -alh a
-rw-r--r-- 1 root root 100 Jan  9 16:23 a
root@qemu-image:/ext4# more /proc/mounts  | grep ext4dev
/dev/hdc /ext4 ext4dev rw,nodelalloc,data=writeback 0 0
root@qemu-image:/ext4#

The third fallocate should result in calling ext4_ext_get_blocks two
times. The first call with logical 0 and max 100 and it will return with
allocated 50. Then call again with logical 50 and max 50.

Something else is wrong.

-aneesh
