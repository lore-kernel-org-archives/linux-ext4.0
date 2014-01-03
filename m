From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: AW: ext4 filesystem bad extent error review
Date: Fri, 03 Jan 2014 11:25:30 -0600
Message-ID: <52C6F28A.6060706@redhat.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com> <20140102184211.GC10870@thunk.org> <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaACRZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 12:25:39 -0500
In-Reply-To: <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/14, 10:29 AM, Juergens Dirk (CM-AI/ECO2) wrote:
> So, I think there _might_ be a kernel bug, but it could be also a problem 
> related to the particular type of eMMC. We did not observe the same issue
> in previous tests with another type of eMMC from another supplier, but this
> was with an older kernel patch level and with another HW design.
> 
> Regarding a possible kernel bug: Is there any chance that the invalid 
> ee_len or ee_start are returned by, e.g., the block allocator ?
> If so, can we try to instrument the code to get suitable traces ?
> Just to see or to exclude that the corrupted inode is really written
> to the eMMC ?

>From your description it does sound possible that it's a kernel bug.
Adding testcases to the code to catch it before it hits the journal
might be helpful - but then maybe this is something getting overwritten
after the fact - hard to say.

Can you share more details of the test you are running?  Or maybe even
the test itself?

I've used a test framework in the past to simulate resets w/o needing
to reset the box, and do many journal replays very quickly.  It'd be
interesting to run it using your testcase.

Thanks,
-Eric
