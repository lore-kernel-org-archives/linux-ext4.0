From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Tue, 28 Jun 2011 14:17:50 -0600
Message-ID: <F044C41A-A585-4626-8E56-6E4BB189FAD9@whamcloud.com>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>,<20110627030539.GF3064@thunk.org> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]"
	<sean.d.mccauliff@nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62758 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1F1URy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 16:17:54 -0400
Received: by pzk26 with SMTP id 26so409338pzk.10
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2011 13:17:53 -0700 (PDT)
In-Reply-To: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-28, at 12:37 PM, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:
> uname -a
> Linux sasr200-2.arc.nasa.gov 2.6.38.7-30.fc15.x86_64 #1 SMP Fri May 27 05:15:53 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> There are about 10M files.  Many are small.  There are about 2M files that are sparse files.  It's hen the copy program gets to these files that the cpu usage gets very high.  There are no links of any kind.
> 
> The copy program is written in Java, but uses the fiemap to get the logical address ranges that have actually been allocated.  It merges any contiguous logical address ranges when it reads and writes to the new file.

Note that you need to be careful with FIEMAP for copying files...  There were
some problems reported to this list with this, if the file was newly written.
It is safest to always pass FIEMAP_FLAG_SYNC before copying the file to ensure
the blocks are mapped to disk.

> The copy has completed.  This is a snipped from top I had saved.  This machine has 4 cores and 8G of ram.  There are 32 threads doing copies.  At any time each has a directory to itself.
> 
>    % cpu
> 0573 root 20 0 7574m 1.9g 1356 S 204.3 24.9 3054:22 java
> 27702 root 20 0 0 0 0 R 70.5 0.0 689:01.73 flush-253:2
> 22467 root 20 0 0 0 0 S 22.6 0.0 7:55.98 kworker/3:1
> 22351 root 20 0 0 0 0 S 21.6 0.0 9:42.58 kworker/1:3
> 22686 root 20 0 0 0 0 S 21.3 0.0 0:26.19 kworker/2:0
> 22679 root 20 0 0 0 0 S 13.8 0.0 0:29.14 kworker/0:1
>   38 root 20 0 0 0 0 S 9.2 0.0 91:21.19 kswapd0
> 22700 root 20 0 0 0 0 S 7.9 0.0 0:04.64 kworker/0:0
> 10566 root 20 0 0 0 0 S 3.6 0.0 17:14.77 jbd2/dm-2-8 
> 
> If I remember correctly top said that: 97% of time was sys time.  So even the time used by Java was still almost all kernel time.    Only a few megabytes was actually swapped.

Looking at the above, "java" is using by far the most memory/CPU, unless this
program is not just doing the copy?

You could run oprofile to see where the CPU cycles are being used.

> ________________________________________
> From: Ted Ts'o [tytso@mit.edu]
> Sent: Sunday, June 26, 2011 8:05 PM
> To: Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: High CPU Utilization When Copying to Ext4
> 
> On Sun, Jun 26, 2011 at 12:33:16PM -0500, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:
>> Sorry if this is not the correct mailing list for ext4 questions.
> 
> -ext3-users, +linux-ext4
> 
>> I'm copying terabytes of data from an ext3 file system to a new ext4
>> file system.  I'm seeing high CPU usage from the processes
>> flush-253:2, kworker-3:0, kworker-2:2, kworker-1:1, and kworker-0:0.
>> Does anyone on the list have any idea what these processes do, why
>> they are consuming so much cpu time and if there is something that
>> can be done about it?  This is using Fedora 15.
> 
> You're using Fedora 15, so you're using a 2.6.38 kernel, right?
> 
> How are you copying the files?  Are you using cp?  rsync?  NFS?  CIFS?
> 
> what sort of files are you copying?  Are they large files, many of
> small files?   Are there lots of hard links?  etc.
> 
>                                      - Ted
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



