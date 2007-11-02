From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc fragmenting files?
Date: Fri, 02 Nov 2007 11:56:36 +0300
Message-ID: <472AE644.1040102@gmail.com>
References: <47225B1E.2060708@redhat.com>
 <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com>
 <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com>
 <472A2384.2010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:53196 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXKBI5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2007 04:57:10 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lA28usEf010119
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 08:57:04 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQV00A01FB5EM00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Fri,
 02 Nov 2007 08:56:54 +0000 (GMT)
In-reply-to: <472A2384.2010001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

would you mind to repeat the run and then grab /proc/fs/ext4/<dev>/mb_history?

thanks in advance, Alex

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Alex Tomas wrote:
>>> please, try the patch attached.
>> Looks quite a bit better:
>>
>> http://people.redhat.com/esandeen/seekwatcher/ext4-alex.png
>> http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-dd-write.png
>> http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-xfs-dd-write.png
>>
>> It is much less fragmented, although still not exactly the nice linear
>> allocation I'd expect from a single threaded large write on a fresh fs...
> 
> Note, we're still getting out-of-order extents, too:
> 
> First block: 122880
> Last block: 2694143
> Discontinuity: Block 7424 is at 101376 (was 130303)
> Discontinuity: Block 28160 is at 133120 (was 122111)
> Discontinuity: Block 58368 is at 188416 (was 163327)
> Discontinuity: Block 66304 is at 180224 (was 196351)
> Discontinuity: Block 73984 is at 172032 (was 187903)
> Discontinuity: Block 81664 is at 167936 (was 179711)
> Discontinuity: Block 84736 is at 221184 (was 171007)
> Discontinuity: Block 92416 is at 212992 (was 228863)
> Discontinuity: Block 100096 is at 204800 (was 220671)
> Discontinuity: Block 107776 is at 198656 (was 212479)
> ...
> 
> I'm trying to find time to look into this but other things are knocking
> at my door so no promises...
> 
> -Eric
> 
