From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 19 Jan 2010 23:24:43 GMT
Message-ID: <201001192324.o0JNOhCE026952@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40049 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0ASXYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2010 18:24:43 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0JNOh76026953
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 23:24:43 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #28 from Darren Hart <dvhltc@us.ibm.com>  2010-01-19 23:24:41 ---
>From the following in the test:

  mem = mmap (NULL, ps, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

this may be related to be the problem reported by Kosaki and fixed with his
patch recently pulled into tip by Ingo and sent Linus and stable. Can you try
with this patch from tip/core-fixes-for-linus?

commit 7485d0d3758e8e6491a5c9468114e74dc050785d
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Tue Jan 5 16:32:43 2010 +0900

    futexes: Remove rw parameter from get_futex_key()

    Currently, futexes have two problem:

    A) The current futex code doesn't handle private file mappings properly.

    get_futex_key() uses PageAnon() to distinguish file and
    anon, which can cause the following bad scenario:

      1) thread-A call futex(private-mapping, FUTEX_WAIT), it
         sleeps on file mapping object.
      2) thread-B writes a variable and it makes it cow.
      3) thread-B calls futex(private-mapping, FUTEX_WAKE), it
         wakes up blocked thread on the anonymous page. (but it's nothing)

    B) Current futex code doesn't handle zero page properly.

    Read mode get_user_pages() can return zero page, but current
    futex code doesn't handle it at all. Then, zero page makes
    infinite loop internally.

    The solution is to use write mode get_user_page() always for
    page lookup. It prevents the lookup of both file page of private
    mappings and zero page.

    Performance concerns:

    Probaly very little, because glibc always initialize variables
    for futex before to call futex(). It means glibc users never see
    the overhead of this patch.

    Compatibility concerns:

    This patch has few compatibility issues. After this patch,
    FUTEX_WAIT require writable access to futex variables (read-only
    mappings makes EFAULT). But practically it's not a problem,
    glibc always initalizes variables for futexes explicitly - nobody
    uses read-only mappings.

    Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
    Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Acked-by: Peter Zijlstra <peterz@infradead.org>
    Acked-by: Darren Hart <dvhltc@us.ibm.com>
    Cc: <stable@kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Ulrich Drepper <drepper@gmail.com>
    LKML-Reference: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
