From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85381] New: ext4 & tmpfs: Splicing to regular files doesn't
 trigger inotify
Date: Wed, 01 Oct 2014 16:56:36 +0000
Message-ID: <bug-85381-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaJAQ4k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 12:56:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2C9F620270
	for <linux-ext4@vger.kernel.org>; Wed,  1 Oct 2014 16:56:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4FA9B2026D
	for <linux-ext4@vger.kernel.org>; Wed,  1 Oct 2014 16:56:37 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=85381

            Bug ID: 85381
           Summary: ext4 & tmpfs: Splicing to regular files doesn't
                    trigger inotify
           Product: File System
           Version: 2.5
    Kernel Version: 3.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: richardpku@gmail.com
        Regression: No

* How to reproduce:

/tmp % cat a.c
#define _GNU_SOURCE 1
#include <limits.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
        int pipefd[2];
        pipe(pipefd);

        for (;;) {
                sleep(1);
                write(pipefd[1], "Hello world\n", 12);
                splice(pipefd[0], NULL, 1, NULL, INT_MAX, 0);
        }
}
/tmp % gcc a.c
/tmp % touch a.txt
/tmp % ./a.out > a.txt & tail -f a.txt


* Expected result:

tail prints "Hello world" every second.



* Actual result:

btrfs: Works as expected;
ext4/tmpfs: tail blocks on inotify forever and prints nothing.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
