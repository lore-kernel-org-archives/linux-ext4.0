From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [3.19 ext4] Significant loss of file I/O reliability under extreme memory pressure.
Date: Fri, 20 Feb 2015 20:20:40 +0900
Message-ID: <201502202020.BGG05734.FJOSMLtHFQOFOV@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:64235 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbbBTLUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2015 06:20:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

Commit 9879de7373fc (mm: page_alloc: embed OOM killing naturally into
allocation slowpath) which was merged between 3.19-rc6 and 3.19-rc7 has
changed the behavior of GFP_NOFS / GFP_NOIO allocations. As a result,
filesystem error actions (e.g. remount-ro or panic) can now be trivially
invoked via extreme memory pressure.

I tested how frequent filesystem errors occurs using scripted environment
on a VM with 4 CPUs / 2048MB RAM / no swap.

---------- Testing script start ----------
#!/bin/sh
: > ~/trial.log
for i in `seq 1 100`
do
    mkfs.ext4 -q /dev/sdb1 || exit 1
    mount -o errors=remount-ro /dev/sdb1 /tmp || exit 2
    chmod 1777 /tmp
    su - demo -c ~demo/a.out
    if [ -w /tmp/ ]
    then
        echo -n "S" >> ~/trial.log
    else
        echo -n "F" >> ~/trial.log
    fi
    umount /tmp
done
---------- Testing script end ----------

---------- Source code of ~demo/a.out start ----------
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sched.h>

static int file_writer(void *unused)
{
        char buffer[128] = { };
        int fd;
        snprintf(buffer, sizeof(buffer) - 1, "/tmp/file.%u", getpid());
        fd = open(buffer, O_WRONLY | O_CREAT, 0600);
        unlink(buffer);
        while (write(fd, buffer, 1) == 1 && fsync(fd) == 0);
        return 0;
}

static void memory_consumer(void)
{
        const int fd = open("/dev/zero", O_RDONLY);
        unsigned long size;
        char *buf = NULL;
        for (size = 1048576; size < 512UL * (1 << 30); size <<= 1) {
                char *cp = realloc(buf, size);
                if (!cp) {
                        size >>= 1;
                        break;
                }
                buf = cp;
        }
        read(fd, buf, size); /* Will cause OOM due to overcommit */
}

int main(int argc, char *argv[])
{
        int i;
        for (i = 0; i < 100; i++) {
                char *cp = malloc(4 * 1024);
                if (!cp || clone(file_writer, cp + 4 * 1024,
                                 CLONE_SIGHAND | CLONE_VM, NULL) == -1)
                        break;
        }
        memory_consumer();
        while (1)
                pause();
        return 0;
}
---------- Source code of ~demo/a.out end ----------

We can see that filesystem errors are occurring frequently if GFP_NOFS / GFP_NOIO
allocations give up without retrying. On the other hand, as far as these trials,
TIF_MEMDIE stall was not observed if GFP_NOFS / GFP_NOIO allocations give up
without retrying. According to Michal Hocko, this is expected because those
allocations are with locks held and so the chances to release the lock are
higher.

  Linux 3.19-rc6 (Console log is http://I-love.SAKURA.ne.jp/tmp/serial-20150219-3.19-rc6.txt.xz )

    0 filesystem errors out of 100 trials. 2 stalls.
    SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

  Linux 3.19 (Console log is http://I-love.SAKURA.ne.jp/tmp/serial-20150219-3.19.txt.xz )

    44 filesystem errors out of 100 trials. 0 stalls.
    SSFFSSSFSSSFSFFFFSSFSSFSSSSSSFFFSFSFFSSSSSSFFFFSFSSFFFSSSSFSSFFFFFSSSSSFSSFSFSSFSFFFSFFFFFFFSSSSSSSS

  Linux 3.19 with http://marc.info/?l=linux-mm&m=142418465615672&w=2 applied.
  (Console log is http://I-love.SAKURA.ne.jp/tmp/serial-20150219-3.19-patched.txt.xz )

    0 filesystem errors out of 100 trials. 2 stalls.
    SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS

I'm posting this result to this ML so that you can start considering what
the proper fix for ext4 filesystem is. At linux-mm ML, Michal Hocko and
Dave Chinner are discussing about use of __GFP_NOFAIL. Their discussion
within http://thread.gmane.org/gmane.linux.kernel.mm/126398 started from
17 Feb might give you some hints.

Regards.
