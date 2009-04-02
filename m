From: Jan Kara <jack@suse.cz>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Fri, 3 Apr 2009 01:39:09 +0200
Message-ID: <20090402233908.GA22206@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200904022224.31060.nickpiggin@yahoo.com.au> <20090402113400.GC3010@duck.suse.cz> <200904030251.22197.nickpiggin@yahoo.com.au> <604427e00904021044n73302f4uc39ca09fe96caf57@mail.gmail.com> <604427e00904021552m7ef58163n5392bbe54d902c21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
	"Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
	Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
	Rohit Seth <rohitseth@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ying Han <yinghan@google.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <604427e00904021552m7ef58163n5392bbe54d902c21@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 02-04-09 15:52:19, Ying Han wrote:
> On Thu, Apr 2, 2009 at 10:44 AM, Ying Han <yinghan@google.com> wrote:
> > On Thu, Apr 2, 2009 at 8:51 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >> On Thursday 02 April 2009 22:34:01 Jan Kara wrote:
> >>> On Thu 02-04-09 22:24:29, Nick Piggin wrote:
> >>> > On Thursday 02 April 2009 09:36:13 Ying Han wrote:
> >>> > > Hi Jan:
> >>> > >     I feel that the problem you saw is kind of differnt than mine. As
> >>> > > you mentioned that you saw the PageError() message, which i don't see
> >>> > > it on my system. I tried you patch(based on 2.6.21) on my system and
> >>> > > it runs ok for 2 days, Still, since i don't see the same error message
> >>> > > as you saw, i am not convineced this is the root cause at least for
> >>> > > our problem. I am still looking into it.
> >>> > >     So, are you seeing the PageError() every time the problem happened?
> >>> >
> >>> > So I asked if you could test with my workaround of taking truncate_mutex
> >>> > at the start of ext2_get_blocks, and report back. I never heard of any
> >>> > response after that.
> >>> >
> >>> > To reiterate: I was able to reproduce a problem with ext2 (I was testing
> >>> > on brd to get IO rates high enough to reproduce it quite frequently).
> >>> > I think I narrowed the problem down to block allocation or inode block
> >>> > tree corruption because I was unable to reproduce it with that hack in
> >>> > place.
> >>>   Nick, what load did you use for reproduction? I'll try to reproduce it
> >>> here so that I can debug ext2...
> >>
> >> OK, I set up the filesystem like this:
> >>
> >> modprobe rd rd_size=$[3*1024*1024]   #almost fill memory so we reclaim buffers
> >> dd if=/dev/zero of=/dev/ram0 bs=4k   #prefill brd so we don't get alloc deadlock
> >> mkfs.ext2 -b1024 /dev/ram0           #1K buffers
> >>
> >> Test is basically unmodified except I use 64MB files, and start 8 of them
> >> at once to (8 core system, so improve chances of hitting the bug). Although I
> >> do see it with only 1 running it takes longer to trigger.
> >>
> >> I also run a loop doing 'sync ; echo 3 > /proc/sys/vm/drop_caches' but I don't
> >> know if that really helps speed up reproducing it. It is quite random to hit,
> >> but I was able to hit it IIRC in under a minute with that setup.
> >>
> >
> > Here is how i reproduce it:
> > Filesystem is ext2 with blocksize 4096
> > Fill up the ram with 95% anon memory and mlockall ( put enough memory
> > pressure which will trigger page reclaim and background writeout)
> > Run one thread of the test program
> >
> > and i will see "bad pages" within few minutes.
> 
> And here is the "top" and stdout while it is getting "bad pages"
> top
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  3487 root      20   0 52616  50m  284 R   95  0.3   3:58.85 usemem
>  3810 root      20   0  129m  99m  99m D   41  0.6   0:01.87 ftruncate_mmap
>   261 root      15  -5     0    0    0 D    4  0.0   0:31.08 kswapd0
>   262 root      15  -5     0    0    0 D    3  0.0   0:10.26 kswapd1
> 
> stdout:
> 
> while true; do
>     ./ftruncate_mmap;
> done
> Running 852 bad page
> Running 315 bad page
> Running 999 bad page
> Running 482 bad page
> Running 24 bad page
  Thanks, for the help. I've debugged the problem to a bug in
ext2_get_block(). I've already sent out a patch which should fix the issue
(at least it fixes the problem for me).
  The fix is also attached if you want to try it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--mYCpIKhGyMATD0i+
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-data-corruption-for-racing-writes.patch"

>From f6e454b1f9fe90d023b30daf0ae7e081580c3bb2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 3 Apr 2009 00:24:28 +0200
Subject: [PATCH] ext2: Fix data corruption for racing writes

If two writers allocating blocks to file race with each other (e.g. because
writepages races with ordinary write or two writepages race with each other),
ext2_getblock() can be called on the same inode in parallel.  Before we are
going to allocate new blocks, we have to recheck the block chain we have
obtained so far without holding truncate_mutex. Otherwise we could overwrite
the indirect block pointer set by the other writer leading to data loss.

The below test program by Ying is able to reproduce the data loss with ext2
on in BRD in a few minutes if the machine is under memory pressure:

long kMemSize  = 50 << 20;
int kPageSize = 4096;

int main(int argc, char **argv) {
	int status;
	int count = 0;
	int i;
	char *fname = "/mnt/test.mmap";
	char *mem;
	unlink(fname);
	int fd = open(fname, O_CREAT | O_EXCL | O_RDWR, 0600);
	status = ftruncate(fd, kMemSize);
	mem = mmap(0, kMemSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	// Fill the memory with 1s.
	memset(mem, 1, kMemSize);
	sleep(2);
	for (i = 0; i < kMemSize; i++) {
		int byte_good = mem[i] != 0;
		if (!byte_good && ((i % kPageSize) == 0)) {
			//printf("%d ", i / kPageSize);
			count++;
		}
	}
	munmap(mem, kMemSize);
	close(fd);
	unlink(fname);

	if (count > 0) {
		printf("Running %d bad page\n", count);
		return 1;
	}
	return 0;
}

CC: Ying Han <yinghan@google.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index b43b955..acf6788 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -590,9 +590,8 @@ static int ext2_get_blocks(struct inode *inode,
 
 	if (depth == 0)
 		return (err);
-reread:
-	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
 
+	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
 		first_block = le32_to_cpu(chain[depth - 1].key);
@@ -602,15 +601,16 @@ reread:
 		while (count < maxblocks && count <= blocks_to_boundary) {
 			ext2_fsblk_t blk;
 
-			if (!verify_chain(chain, partial)) {
+			if (!verify_chain(chain, chain + depth - 1)) {
 				/*
 				 * Indirect block might be removed by
 				 * truncate while we were reading it.
 				 * Handling of that case: forget what we've
 				 * got now, go to reread.
 				 */
+				err = -EAGAIN;
 				count = 0;
-				goto changed;
+				break;
 			}
 			blk = le32_to_cpu(*(chain[depth-1].p + count));
 			if (blk == first_block + count)
@@ -618,7 +618,8 @@ reread:
 			else
 				break;
 		}
-		goto got_it;
+		if (err != -EAGAIN)
+			goto got_it;
 	}
 
 	/* Next simple case - plain lookup or failed read of indirect block */
@@ -626,6 +627,33 @@ reread:
 		goto cleanup;
 
 	mutex_lock(&ei->truncate_mutex);
+	/*
+	 * If the indirect block is missing while we are reading
+	 * the chain(ext3_get_branch() returns -EAGAIN err), or
+	 * if the chain has been changed after we grab the semaphore,
+	 * (either because another process truncated this branch, or
+	 * another get_block allocated this branch) re-grab the chain to see if
+	 * the request block has been allocated or not.
+	 *
+	 * Since we already block the truncate/other get_block
+	 * at this point, we will have the current copy of the chain when we
+	 * splice the branch into the tree.
+	 */
+	if (err == -EAGAIN || !verify_chain(chain, partial)) {
+		while (partial > chain) {
+			brelse(partial->bh);
+			partial--;
+		}
+		partial = ext2_get_branch(inode, depth, offsets, chain, &err);
+		if (!partial) {
+			count++;
+			mutex_unlock(&ei->truncate_mutex);
+			if (err)
+				goto cleanup;
+			clear_buffer_new(bh_result);
+			goto got_it;
+		}
+	}
 
 	/*
 	 * Okay, we need to do block allocation.  Lazily initialize the block
@@ -683,12 +711,6 @@ cleanup:
 		partial--;
 	}
 	return err;
-changed:
-	while (partial > chain) {
-		brelse(partial->bh);
-		partial--;
-	}
-	goto reread;
 }
 
 int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
-- 
1.6.0.2


--mYCpIKhGyMATD0i+--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
