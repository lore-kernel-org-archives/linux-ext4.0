From: Andreas Dilger <adilger@sun.com>
Subject: Re: Of block allocation algorithms, fsck times, and file	fragmentation
Date: Wed, 06 May 2009 05:50:29 -0600
Message-ID: <20090506115029.GF3209@webber.adilger.int>
References: <E1M1fIm-0001Hw-0f@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56159 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZEFLul (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 May 2009 07:50:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n46BofXA003139
	for <linux-ext4@vger.kernel.org>; Wed, 6 May 2009 04:50:41 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KJ800B000S7AD00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 06 May 2009 04:50:41 -0700 (PDT)
In-reply-to: <E1M1fIm-0001Hw-0f@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 06, 2009  07:28 -0400, Theodore Ts'o wrote:
> So that's the good news.  However, the block allocation shows that we
> are doing something... strange.  Running an e2fsck -E fragcheck report,
> the large files seem to be written out in 8 megabyte chunks:
> 
>   1313(f): expecting  51200 actual extent phys  53248 log 2048 len 2048
>   1351(f): expecting  53248 actual extent phys  57344 log 2048 len 2048
>   1351(f): expecting  59392 actual extent phys  67584 log 4096 len 4096
>   1351(f): expecting  71680 actual extent phys  73728 log 8192 len 2048
>   1351(f): expecting  75776 actual extent phys  77824 log 10240 len 2048
>   1574(f): expecting  77824 actual extent phys  81920 log 6144 len 2048
>   1574(f): expecting  83968 actual extent phys  86016 log 8192 len 12288
>   1574(f): expecting  98304 actual extent phys 100352 log 20480 len 32768

Two things might be involved here:
- IIRC mballoc limits its extent searches to 8MB, so that it doesn't
  waste a lot of cycles looking for huge free chunks when there aren't
  any.  For Lustre that didn't make much difference since the largest
  possible IO size at the server is 1MB.  That said, if we have huge
  delalloc files it might make sense to do some checking for more space,
  possibly whole free groups for files > 128MB in size.  Scanning the
  buddy bitmaps isn't very expensive, but loading some 10000's of them
  in a large filesystem IS.
- it might also relate to pdflush limiting the background writeout from 
  a single file, and flushing the delalloc pages in round-robin manner.
  Without delalloc the blocks would already have been allocated, so the
  writeout speed didn't matter.  With delalloc now we might have an
  unpleasant interaction between how pdflush writes out the dirty pages
  and how the files are allocated on disk.

> Thinking this was perhaps rsync's fault, I tried the experiment where I
> copied the files using tar:
> 
>        tar -cf - -C /mnt2 . | tar -xpf - -C /mnt .
> 
> However, the same pattern was visible.  Tar definitely copies files
> using one at a time, so this must be an artifact of the page writeback
> algorithms.

If you can run a similar test with fsync after each file I suspect the
layout will be correct.  Alternately, if the kernel did the equivalent
of "fallocate(KEEP_SIZE)" for the file as soon as writeout started, it
would avoid any interaction between pdflush and the file allocation.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

