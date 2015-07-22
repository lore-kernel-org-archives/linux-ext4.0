From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: two fsck.ext4's needed to clean filesystem
Date: Wed, 22 Jul 2015 11:33:01 -0500
Message-ID: <55AFC5BD.9000001@redhat.com>
References: <20150722141806.GA21181@amd> <20150722142159.GA21742@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: jack@suse.com, linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965204AbbGVQdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2015 12:33:01 -0400
In-Reply-To: <20150722142159.GA21742@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/22/15 9:21 AM, Pavel Machek wrote:
> Hi!
> 
>> Is that considered ok? Should fsck restart itself or report
>> 'filesystem still has errors' in this case?

It should.

> It definitely should in this case:
> 
> Free inodes count wrong (22999, counted=23011).
> Fix? yes
> 
> 
> delme.fsck.damaged: ***** FILE SYSTEM WAS MODIFIED *****
> delme.fsck.damaged: 2053/25064 files (0.1% non-contiguous),
> 97825/100000 blocks
> Second check...
> e2fsck 1.42.12 (29-Aug-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  +18015
> Fix? yes
> 
> Free blocks count wrong for group #2 (36, counted=35).
> Fix? yes
> 
> Free blocks count wrong (2175, counted=2174).
> Fix? yes
> 
> 
> delme.fsck.damaged: ***** FILE SYSTEM WAS MODIFIED *****
> delme.fsck.damaged: 2053/25064 files (0.2% non-contiguous),
> 97826/100000 blocks
> Fsck lied about its success (result = 1)
> pavel@amd:~/misc$ cp delme.fsck.original-damaged delme.report-2
> 
> (I can make the images public. Yes, it is artificial test.)

Please do - you're right, it should fix it on the first pass.

Thanks,
-Eric

