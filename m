From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40512] New: EXT4_IOC_MIGRATE is dangerous on directories
Date: Thu, 4 Aug 2011 01:51:00 GMT
Message-ID: <bug-40512-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39331 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab1HDBvB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 21:51:01 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p741p0Za029630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 01:51:00 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40512

           Summary: EXT4_IOC_MIGRATE is dangerous on directories
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: benjamin@python.org
        Regression: No


Using EXT4_IOC_MIGRATE on a non-extent directory seems to have terrible
consequences. Consider the following example. "dir" is a old directory without
extents.

$ ls -la dir/
total 12
drwxr-xr-x  2 benjamin benjamin 4096 Aug  3 20:42 .
drwxr-xr-x 47 benjamin benjamin 4096 Aug  3 20:42 ..
-rw-r-----  1 benjamin benjamin    7 Aug  3 20:42 something.txt
$ cat migrate.c
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char **argv)
{
    const char *fn = argv[1];
    int fd, ret;

    fd = open(fn, O_RDONLY);
    /* This invokes EXT4_IOC_MIGRATE. */
    ret = ioctl(fd, 0x6609);
    close(fd);
    if (ret < 0) {
        fprintf(stderr, "ioctl failed\n");
        return 1;
    }
    printf("Migration successful?\n");
    return 0;
}
$ gcc -o migrate migrate.c
$ ./migrate dir
Migration successful?
$ ls -la dir
total 0 # !!!!!!!!!!!!!!

Also, we why are you allowed to migrate stuff with only O_RDONLY access?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
