From: Alex Tomas <alex.tomas@sun.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Mon, 24 Dec 2007 21:18:45 +0300
Message-ID: <476FF805.4050700@sun.com>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20071221191020.GM3214@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:40431 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXLXSTb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2007 13:19:31 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe1.eu.sun.com [192.18.6.10])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lBOIJKD9022163
	for <linux-ext4@vger.kernel.org>; Mon, 24 Dec 2007 18:19:30 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JTK00L01FVWSV00@fe-emea-09.sun.com>
 (original mail from alex.tomas@sun.com) for linux-ext4@vger.kernel.org; Mon,
 24 Dec 2007 18:19:20 +0000 (GMT)
In-reply-to: <20071221191020.GM3214@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Dec 21, 2007  16:39 +0530, Aneesh Kumar K.V wrote:
>> @@ -3790,7 +3782,9 @@ repeat:
>>  
>>  	/* if we still need more blocks and some PAs were used, try again */
>>  	if (free < needed && busy) {
>> +		busy = 0;
>>  		ext4_unlock_group(sb, group);
>> +		schedule_timeout(HZ);
>>  		goto repeat;
>>  	}
> 
> Is there nothing we could actually wait on instead of just sleeping for
> 1 second?

actually it was done for simplicity - in my tests busy PA happened quite rare.
I have no objection to improve this with special wait queue.

thanks, Alex
