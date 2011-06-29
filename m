From: Sean McCauliff <Sean.D.McCauliff@nasa.gov>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Wed, 29 Jun 2011 16:16:58 -0700
Message-ID: <4E0BB26A.8030801@nasa.gov>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>,<20110627030539.GF3064@thunk.org> <341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov> <F044C41A-A585-4626-8E56-6E4BB189FAD9@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ndjsnpf03.ndc.nasa.gov ([198.117.1.123]:55337 "EHLO
	ndjsnpf03.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1F2XRA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 19:17:00 -0400
In-Reply-To: <F044C41A-A585-4626-8E56-6E4BB189FAD9@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 06/28/2011 01:17 PM, Andreas Dilger wrote:

> Note that you need to be careful with FIEMAP for copying files...  There were
> some problems reported to this list with this, if the file was newly written.
> It is safest to always pass FIEMAP_FLAG_SYNC before copying the file to ensure
> the blocks are mapped to disk.

Thanks!

>
>> The copy has completed.  This is a snipped from top I had saved.  This machine has 4 cores and 8G of ram.  There are 32 threads doing copies.  At any time each has a directory to itself.
>>
>>     % cpu
>> 0573 root 20 0 7574m 1.9g 1356 S 204.3 24.9 3054:22 java
>> 27702 root 20 0 0 0 0 R 70.5 0.0 689:01.73 flush-253:2
>> 22467 root 20 0 0 0 0 S 22.6 0.0 7:55.98 kworker/3:1
>> 22351 root 20 0 0 0 0 S 21.6 0.0 9:42.58 kworker/1:3
>> 22686 root 20 0 0 0 0 S 21.3 0.0 0:26.19 kworker/2:0
>> 22679 root 20 0 0 0 0 S 13.8 0.0 0:29.14 kworker/0:1
>>    38 root 20 0 0 0 0 S 9.2 0.0 91:21.19 kswapd0
>> 22700 root 20 0 0 0 0 S 7.9 0.0 0:04.64 kworker/0:0
>> 10566 root 20 0 0 0 0 S 3.6 0.0 17:14.77 jbd2/dm-2-8
>>
>> If I remember correctly top said that: 97% of time was sys time.  So even the time used by Java was still almost all kernel time.    Only a few megabytes was actually swapped.
>
> Looking at the above, "java" is using by far the most memory/CPU, unless this
> program is not just doing the copy?

It does walk down the directory tree.  When it finds a directory it 
creates a new object in the thread work queue for the directory it 
found.  Threads read off the the queue creating directories in the 
destination and copying files to the destination.

>
> You could run oprofile to see where the CPU cycles are being used.
I will do this next time I'm running the copy.

Thanks,
Sean
