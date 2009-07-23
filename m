From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Thu, 23 Jul 2009 11:05:01 -0700
Message-ID: <1248372301.31323.2.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <4A67D36D.20708@redhat.com>
	 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <4A689723.7000805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:9770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZGWSFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 14:05:24 -0400
In-Reply-To: <4A689723.7000805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-07-23 at 12:00 -0500, Eric Sandeen wrote:
> Sorry I skimmed to fast, skipped over the fsck part.  But:
> 
> # mkfs.ext4 /dev/sdb3
> mke2fs 1.41.5 (23-Apr-2009)
> ...
> # mount /dev/sdb3 /mnt/test
> # touch /mnt/test/testfile
> # /root/fallocate -n -l 16m /mnt/test/testfile
> # ls -l /mnt/test/testfile
> -rw-r--r-- 1 root root 0 Jul 23 12:13 /mnt/test/testfile
> # du -h /mnt/test/testfile
> 16M	/mnt/test/testfile
> # umount /mnt/test
> # e2fsck -f /dev/sdb3
> e2fsck 1.41.5 (23-Apr-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sdb3: 12/244800 files (0.0% non-contiguous), 37766/977956 blocks
> 
> there doesn't seem to be a problem in fsck w/ block past EOF, or am I
> missing something else?

I was taking Andreas' word for it but now that you mention it, I see the
same thing.  Andreas, did you have a specific case in mind?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

