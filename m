From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Fri, 26 Mar 2010 10:00:43 GMT
Message-ID: <201003261000.o2QA0hxK006412@demeter.kernel.org>
References: <bug-12624-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58513 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0CZKAp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 06:00:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2QA0iHL006414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 10:00:44 GMT
In-Reply-To: <bug-12624-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=12624





--- Comment #8 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2010-03-26 10:00:37 ---
On Thu, 25 Mar 2010 22:21:56 GMT, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=12624
> 
> 
> Eric Sandeen <sandeen@redhat.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |sandeen@redhat.com
> 
> 
> 
> 
> --- Comment #7 from Eric Sandeen <sandeen@redhat.com>  2010-03-25 22:21:53 ---
> Aneesh, this worked for me on upstream:
> 
> # mount -o data=journal /dev/sdb5 /mnt/test
> # ltp/fsstress -d /mnt/test -n 10000 -p 4
> # umount /mnt/test
> 
> Any idea if this is still a problem?
> 

I haven't seen the problem after that. I also didn't debug the initial
problem to understand whey the umount was really hanging . So may be we
can close the bug and later open this if we hit the issue.

-aneesh

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
