From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Fri, 11 Jun 2010 14:26:55 GMT
Message-ID: <201006111426.o5BEQtxh004828@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58683 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0FKO04 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jun 2010 10:26:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5BEQtqh004829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jun 2010 14:26:55 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165


Frank Mehnert <frank.mehnert@sun.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |frank.mehnert@sun.com




--- Comment #9 from Frank Mehnert <frank.mehnert@sun.com>  2010-06-11 14:26:51 ---
When compiling the test case, please make sure to add a third parameter to
open(), for example 0777, otherwise it wouldn't compile on Ubuntu (O_CREAT
requires 3 parameters for open).

Executed the testcase here on an up-to-date Ubuntu 10.04 installed on an
ext4-formatted partition. The testcase does NOT fail if the test file already
exists. But it fails about 130 out of 500 times if I remove the test file prior
to each run. When using Linux 2.6.34 vanilla: 7080 out of 10000 runs reported a
corrupted buffer. And, like expected, the test never fails on an ext3
partition.

So please make sure to run the testcase like this:

# for i in `seq 1 500`; do rm -f /mnt/tst; ./aio_corrupt /mnt/tst; done

where /mnt is an ext4 partition.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
