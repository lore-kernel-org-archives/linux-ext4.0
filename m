From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 21:39:07 GMT
Message-ID: <200910292139.n9TLd7bJ007722@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54405 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZJ2VjC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:39:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLd71P007723
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:39:07 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #145 from Eric Sandeen <sandeen@redhat.com>  2009-10-29 21:39:06 ---
Parag Warudkar wrote:
> On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> Can you try this patch ?
>>
>> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Date:   Tue Oct 27 15:36:38 2009 +0530
>>
>>    ext4: discard preallocation during truncate
>>
>>    We need to make sure when we drop and reacquire the inode's
>>    i_data_sem we discard the inode preallocation. Otherwise we
>>    could have blocks marked as free in bitmap but still belonging
>>    to prealloc space.
> 
> Just wanted to let you know that I have applied this patch and one
> unclean shutdown later it seems to have not given me any trouble.
> 
> I will continue testing it - hopefully I won't have to reformat  this
> time ( every time I tested previously I ended up having weird issues
> that I decided to get rid of by reformatting /).

I've been running my testcase, and I just hit the usual corruption with 
this patch in place after 8 iterations, I'm afraid.

-Eric

> Parag
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
