From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 19:56:43 GMT
Message-ID: <200910301956.n9UJuht2018259@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34960 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbZJ3T4i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 15:56:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UJuhCx018260
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 19:56:43 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #160 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-10-30 19:56:41 ---
Reply-To: adilger@sun.com

On 2009-10-29, at 15:38, Eric Sandeen wrote:
> Parag Warudkar wrote:
>> On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
>> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>>> Can you try this patch ?
>>>
>>> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
>>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>> Date:   Tue Oct 27 15:36:38 2009 +0530
>>>
>>>   ext4: discard preallocation during truncate
>>>
>>>   We need to make sure when we drop and reacquire the inode's
>>>   i_data_sem we discard the inode preallocation. Otherwise we
>>>   could have blocks marked as free in bitmap but still belonging
>>>   to prealloc space.
>> Just wanted to let you know that I have applied this patch and one
>> unclean shutdown later it seems to have not given me any trouble.
>> I will continue testing it - hopefully I won't have to reformat  this
>> time ( every time I tested previously I ended up having weird issues
>> that I decided to get rid of by reformatting /).
>
> I've been running my testcase, and I just hit the usual corruption  
> with this patch in place after 8 iterations, I'm afraid.


I wonder if there are multiple problems involved here?  Eric, it seems
possible that your reproducer is exercising a similar, though unrelated
codepath.  I would agree with Ted that if this patch is solving the
problem for some of the users it is definitely worth landing, even if it
ends up not solving all of the problems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
