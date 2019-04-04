Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7C5C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 14:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 423A220882
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 14:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfDDOXw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:23:52 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54072 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbfDDOXw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Apr 2019 10:23:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4F50B28A9D
        for <linux-ext4@vger.kernel.org>; Thu,  4 Apr 2019 14:23:51 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 43CF828A9B; Thu,  4 Apr 2019 14:23:51 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203107] Bad page map in process during boot
Date:   Thu, 04 Apr 2019 14:23:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vbabka@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203107-13602-OelBiVaBKD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203107-13602@https.bugzilla.kernel.org/>
References: <bug-203107-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203107

--- Comment #4 from Vlastimil Babka (vbabka@suse.cz) ---
On 4/4/19 3:08 PM, Kirill A. Shutemov wrote:
> On Tue, Apr 02, 2019 at 12:16:13PM +0200, Jan Kara wrote:
>> Switching to email...
>>
>> On Fri 29-03-19 20:46:22, bugzilla-daemon@bugzilla.kernel.org wrote:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=203107
>>>
>>>             Bug ID: 203107
>>>            Summary: Bad page map in process during boot
>>>            Product: File System
>>>            Version: 2.5
>>>     Kernel Version: 5.0.5
>>>           Hardware: All
>>>                 OS: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: ext4
>>>           Assignee: fs_ext4@kernel-bugs.osdl.org
>>>           Reporter: echto1@gmail.com
>>>         Regression: No
>>>
>>> Error occurs randomly at boot after upgrading kernel from 5.0.0 to 5.0.4.
>>>
>>> https://justpaste.it/387uf
>>
>> I don't think this is an ext4 error. Sure this is an error in file mapping
>> of libblkid.so.1.1.0 (which is handled by ext4) but the filesystem has very
>> little to say wrt how or which PTEs are installed. And the problem is that
>> invalid PTE (dead000000000100) is present in page tables. So this looks
>> more like a problem in MM itself. Adding MM guys to CC.
> 
> 0xdead000000000100 and 0xdead000000000200 are LIST_POISON1 and
> LIST_POISON2 repectively. Have no idea how would they end up in page table.

It's possible that CONFIG_DEBUG_LIST could catch the issue. Between
5.0.0 to 5.0.4 it should be also relatively easy to bisect with the
stable git tree [1], although if it happens randomly, you need to
perform enough attempts to accurately determine which commit is "good".

[1] git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
