From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due to a
 deadlock
Date: Mon, 28 Mar 2011 17:06:28 +0900
Message-ID: <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
	<20110215160630.GH17313@quack.suse.cz>
	<20110215170352.GE4255@thunk.org>
	<20110215172954.GK17313@quack.suse.cz>
	<20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
	<20110216145627.GB5592@quack.suse.cz>
	<4D5C9B1B.2050304@jp.fujitsu.com>
	<20110217104552.GD4947@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50427 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1C1J20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 05:28:26 -0400
In-Reply-To: <20110217104552.GD4947@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

On Thu, 17 Feb 2011 11:45:52 +0100
Jan Kara <jack@suse.cz> wrote:
> On Thu 17-02-11 12:50:51, Toshiyuki Okajima wrote:
> > (2011/02/16 23:56), Jan Kara wrote:
> > >On Wed 16-02-11 08:17:46, Toshiyuki Okajima wrote:
> > >>On Tue, 15 Feb 2011 18:29:54 +0100
> > >>Jan Kara<jack@suse.cz>  wrote:
> > >>>On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
> > >>>>On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> > >>>>>Thanks for detailed analysis. Indeed this is a bug. Whenever we do IO
> > >>>>>under s_umount semaphore, we are prone to deadlock like the one you
> > >>>>>describe above.
> > >>>>
> > >>>>One of the fundamental problems here is that the freeze and thaw
> > >>>>routines are using down_write(&sb->s_umount) for two purposes.  The
> > >>>>first is to prevent the resume/thaw from racing with a umount (which
> > >>>>it could do just as well by taking a read lock), but the second is to
> > >>>>prevent the resume/thaw code from racing with itself.  That's the core
> > >>>>fundamental problem here.
> > >>>>
> > >>>>So I think we can solve this by introduce a new mutex, s_freeze, and
> > >>>>having the the resume/thaw first take the s_freeze mutex and then
> > >>>>second take a read lock on the s_umount.
> > >>>   Sadly this does not quite work because even down_read(&sb->s_umount)
> > >>>in thaw_super() can block if there is another process that tries to acquire
> > >>>s_umount for writing - a situation like:
> > >>>   TASK 1 (e.g. flusher)		TASK 2	(e.g. remount)		TASK 3 (unfreeze)
> > >>>down_read(&sb->s_umount)
> > >>>   block on s_frozen
> > >>>				down_write(&sb->s_umount)
> > >>>				  -blocked
> > >>>								down_read(&sb->s_umount)
> > >>>								  -blocked
> > >>>behind the write access...
> > >>>
> > >>>The only working solution I see is to check for frozen filesystem before
> > >>>taking s_umount semaphore which seems rather ugly (but might be bearable if
> > >>>we did so in some well described wrapper).
> > >>I created the patch that you imagine yesterday.
> > >>
> > >>I got a reproducer from Mizuma-san yesterday, and then I executed it on the kernel
> > >>without a fixed patch. After an hour, I confirmed that this deadlock happened.
> > >>
> > >>However, on the kernel with a fixed patch, this deadlock doesn't still happen
> > >>after 12 hours passed.
> > >>
> > >>The patch for linux-2.6.38-rc4 is as follows:
> > >>---
> > >>  fs/fs-writeback.c |    2 +-
> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >>
> > >>diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > >>index 59c6e49..1c9a05e 100644
> > >>--- a/fs/fs-writeback.c
> > >>+++ b/fs/fs-writeback.c
> > >>@@ -456,7 +456,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
> > >>         spin_unlock(&sb_lock);
> > >>
> > >>         if (down_read_trylock(&sb->s_umount)) {
> > >>-               if (sb->s_root)
> > >>+               if (sb->s_frozen == SB_UNFROZEN&&  sb->s_root)
> > >>                         return true;
> > >>                 up_read(&sb->s_umount);
> > 
> > >   So this is something along the lines I thought but it actually won't work
> > >for example if sync(1) is run while the filesystem is frozen (that takes
> > >s_umount semaphore in a different place). And generally, I'm not convinced
> > >there are not other places that try to do IO while holding s_umount
> > >semaphore...
> > OK. I understand.
> > 
> > This code only fixes the case for the following path:
> > writeback_inodes_wb
> > -> ext4_da_writepages
> >    -> ext4_journal_start_sb
> >       -> vfs_check_frozen
> > But, the code doesn't fix the other cases.
> > 
> > We must modify the local filesystem part in order to fix all cases...?
>   Yes, possibly. But most importantly we should first find clear locking
> rules for frozen filesystem that avoid deadlocks like the one above. And
> the freezing / unfreezing code might become subtle for that reason, that's
> fine, but it would be really good to avoid any complicated things for the
> code in the rest of the VFS / filesystems.
I have deeply continued to examined the root cause of this problem, then 
I found it.

It is that we can write a memory which is mmaped to a file. Then the memory 
becomes "DIRTY" so then the flusher thread (ex. wb_do_writeback) tries to
"writeback" the memory. 

Therefore, the root cause of this hangup is not only ext4 component (with
delayed allocation feature) but also writeback mechanism for mmap. If you 
use the other filesystem, you can write something to the filesystem though 
you have freezed the filesystem.

A sample problem is attached on this mail.  Try to execute it then you can 
confirm that we can write some data to your filesystem while freezing the 
filesystem.
(If you change FS variable in go.sh from ext3 to ext4 and you execute
"fsfreeze -u mnt" manually on other prompt, you can also confirm this deadlock.)

I think the best approach to fix this problem is to let users not to write
memory which is mapped to a certain file while the filesystem is freezing. 
However, it is very difficult to control users not to write memory which has 
been already mapped to the file.

Therefore, I think there is only actual method that we stop writeback thread 
to resolve the mmap problem. Also, by this fix, the original problem 
(ext4 delayed write vs unfreeze) can be solved.

I created a patch for this problem. Please confirm it.

------------------------------------------------------------------------------
----------
reproducer
----------
[run script] go.sh
#!/bin/sh

FS=ext3
gcc -o ./write ./write.c
dd if=/dev/zero of=/tmp/loop.$$ bs=1k seek=64k count=1 > /dev/null 2>&1
/sbin/mkfs.$FS -Fq /tmp/loop.$$
/sbin/losetup /dev/loop7 /tmp/loop.$$
mkdir -p mnt
mount -t $FS /dev/loop7 mnt
dd if=/dev/zero of=mnt/file bs=4k count=100 > /dev/null 2>&1
./write mnt/file &
pid=$!
# write 0 then 1
/bin/kill -SIGUSR1 $pid 
/bin/kill -SIGUSR1 $pid 
/sbin/fsfreeze -f mnt
cp /tmp/loop.$$ /tmp/loop.$$.pre
/bin/kill -SIGUSR1 $pid
sync
sleep 30
cp /tmp/loop.$$ /tmp/loop.$$.post
/sbin/fsfreeze -u mnt
/bin/kill -SIGTERM $pid
umount mnt
/sbin/losetup -d /dev/loop7
/usr/bin/cmp /tmp/loop.$$.pre /tmp/loop.$$.post > /dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "freeze doesn't work correctly!"
else
        echo "freeze works correctly!"
fi
rm -f /tmp/loop.$$* 
exit 0

[program] write.c
#define LARGEFILE64_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

int counter = 0;
char *mmap_addr;
int fd;

#define LOOP 100
#define UNIT 4096
#define MMAPSZ  (UNIT*LOOP)
#define FILENAME "./mnt/file"

void
write_inc(int sig)
{
        int i;

        for (i = 0; i < LOOP; i++) 
                *((int*)(mmap_addr + UNIT*i)) = counter;
        counter ++;
}

void
main_exit(int sig)
{
        munmap(mmap_addr, MMAPSZ);
        close(fd);
        exit(0);
}

int main(int argc, char *argv[])
{
        char *file = FILENAME;

        if ((fd = open(file, O_RDWR)) < 0) {
                perror("open error");
                exit(1);
        }
        if ((mmap_addr = mmap(0, MMAPSZ, PROT_WRITE, MAP_SHARED, fd, 0)) ==
MAP_FAILED) {
                perror("mmap error");
                close(fd);
                exit(2);
        }
        sigset(SIGTERM, (void *)main_exit);
        sigset(SIGUSR1, (void *)write_inc);
        while (1) 
                pause();
}

[step to rerproduce]
# sh ./go.sh 
------------------------------------------------------------------------------

[patch]
Now, we can write the memory which is mapped to a file while 
the filesystem to which it belongs is being freezed.
Therefore, the filesystem can modify even if it is being freezed.
This fix prevents the flusher thread from updating the filesystem.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/fs-writeback.c   |    2 +-
 fs/super.c          |    7 ++++++-
 mm/page-writeback.c |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b5ed541..2a60148 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -477,7 +477,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
 	spin_unlock(&sb_lock);
 
 	if (down_read_trylock(&sb->s_umount)) {
-		if (sb->s_root)
+		if (sb->s_frozen == 0 && sb->s_root)
 			return true;
 		up_read(&sb->s_umount);
 	}
diff --git a/fs/super.c b/fs/super.c
index 8a06881..bac28c4 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -432,8 +432,13 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
 			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
-
+retry:
 		down_read(&sb->s_umount);
+		if (sb->s_frozen > 0) {
+			up_read(&sb->s_umount);
+			cond_resched();
+			goto retry;
+		}
 		if (sb->s_root)
 			f(sb, arg);
 		up_read(&sb->s_umount);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 31f6988..eb19642 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1058,7 +1058,9 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	struct super_block *sb = mapping->host->i_sb;
 
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
 	if (wbc->nr_to_write <= 0)
 		return 0;
 	if (mapping->a_ops->writepages)
-- 
1.5.5.6
