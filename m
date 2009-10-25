From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 25 Oct 2009 19:04:22 GMT
Message-ID: <200910251904.n9PJ4ME9020434@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48512 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbZJYTES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Oct 2009 15:04:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9PJ4Msw020437
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2009 19:04:22 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #115 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-10-25 19:04:20 ---
Reply-To: pavel@ucw.cz

Hi!

>>> So I have been experimenting with various root file systems on my
>>> laptop running latest git. This laptop some times has problems waking
>>> up from sleep and that results in it needing a hard reset and
>>> subsequently unclean file system.
>>>      
>> A number of people have reported this, and there is some discussion
>> and some suggestions that I've made here:
>>
>> 	http://bugzilla.kernel.org/show_bug.cgi?id=14354
>>
>> It's been very frustrating because I have not been able to replicate
>> it myself; I've been very much looking for someone who is (a) willing
>> to work with me on this, and perhaps willing to risk running fsck
>> frequently, perhaps after every single unclean shutdown, and (b) who
>> can reliably reproduce this problem.  On my system, which is a T400
>> running 9.04 with the latest git kernels, I've not been able to
>> reproduce it, despite many efforts to try to reproduce it.  (i.e.,
>> suspend the machine and then pull the battery and power; pulling the
>> battery and power, "echo c>  /proc/sysrq-trigger", etc., while
>> doing "make -j4" when the system is being uncleanly shutdown)
>>    
>
> I wonder if we might have better luck if we tested using an external  
> (e-sata or USB connected) S-ATA drive.
>
> Instead of pulling the drive's data connection, most of these have an  
> external power source that could be turned off so the drive firmware  
> won't have a chance to flush the volatile write cache. Note that some  
> drives automatically write back the cache if they have power and see a  
> bus disconnect, so hot unplugging just the e-sata or usb cable does not  
> do the trick.
>
> Given the number of cheap external drives, this should be easy to test  
> at home....

Do they support barriers?

(Anyway, you may want to use some kind of VM for testing. That should
make the testing cycle shorter, easier to reprorduce *and* more repeatable.)

                                    Pavel

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.