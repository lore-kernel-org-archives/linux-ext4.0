From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Tue, 11 Aug 2009 18:47:03 GMT
Message-ID: <200908111847.n7BIl3O5005365@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50420 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZHKSrF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 14:47:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7BIl3nW005366
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 18:47:03 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #26 from Roland Kletzing <devzero@web.de>  2009-08-11 18:47:01 ---
we got some feedback from the ima developers:

>> > > if this is a bug fixed in .31 (perhaps http://git.kernel.org/?>p=linux/kernel/git/torvalds/linux->2.6.git;a=commit;h=1a62e958fa4aaeeb752311b4f5e16b2a86737b23
>> > > ???) , shouldn`t that go to -stable, too ?
>> > 
>> > Yes, it's in 2.6.30.1.
>> 
>> so, is the reported one perhaps another issue? 
>> the user with that problem is using 2.6.30.4
>
>No, I don't think so. The default measurement policy in 2.6.30 measures
>all executables and all files opened for read by root. For 2.6.31, this
>policy is enabled only if the kernel command line option "ima_tcb=1" is
>specified.
>
>You're probably opening a 3GB file for read as root, which causes the
>file to be measured, not really something you'd want to do as it takes a
>real long time. Depending on what is causing the file to be measured,
>you could run the app as user. The other option is to modify the IMA
>measurement policy. (Refer to
>linux-2.6.30.X/Documentation/ABI/testing/ima_policy.)
>
>Mimi


so, before closing, it would make sense if you could do the following (with ima
enabled):

1. do the tests (md5sum/dd) as non-root user. that should make a difference
2. do the test with a 1gb, 2gb and 3gb file and check the time needed to
complete. does that scale linear? does the 2gb complete in reasonable time, but
not the 3gb file ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
