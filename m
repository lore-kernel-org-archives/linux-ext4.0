From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: Re: [PATCH] Attempt to sync the fsstress writes to a frozen F.S
Date: Wed, 25 May 2011 15:00:13 +0300
Message-ID: <4DDCEF4D.1070107@canonical.com>
References: <4DCA3583.7010904@canonical.com> <1305097841-2308-1-git-send-email-surbhi.palande@canonical.com> <20110524214222.GF26055@thunk.org>
Reply-To: surbhi.palande@canonical.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000506060100050205000601"
Cc: sandeen@redhat.com, jack@suse.cz, marco.stornelli@gmail.com,
	adilger.kernel@dilger.ca, toshi.okajima@jp.fujitsu.com,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:36403 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1EYMAX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 08:00:23 -0400
In-Reply-To: <20110524214222.GF26055@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000506060100050205000601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ted,


On 05/25/2011 12:42 AM, Ted Ts'o wrote:
> On Wed, May 11, 2011 at 10:10:41AM +0300, Surbhi Palande wrote:
>> While the fsstress background writes are busy dirtying the page cache, if a
>> fsfreeze happens then the background writes should stall. A sync should then
>> not have any data to sync to the FS. If it does have any data to sync then
>> sync will cause a deadlock by holding the s_umount write semaphore and waiting
>> in the wait queue for the FS to thaw, whereas the F.S can never thaw without
>> getting the s_umount write semaphore.
>>
>> Signed-off-by: Surbhi Palande<surbhi.palande@canonical.com>
>
> Hi Surbhi,
>
> Have you tried out Jan Kara's patches?
>
> [1/3] fs: Create __block_page_mkwrite() helper passing error values back
> [2/3] vfs: Block mmapped writes while the fs is frozen
> [3/3] ext4: Rewrite ext4_page_mkwrite() to return locked page

Yes! We have tried these patches and we still see the same 
deadlock/hang. The following is the reason for it:


// lets assume the inode is clean and so are its pages.
P1: process that tries mmap write
t1) __do_fault()
   t2) ext4_page_mkwrite()
     t3) block_page_mkwrite()
       t4) vfs_check_frozen()
// filesystem is not frozen so control falls through.
       t5) __block_page_mkwrite()
         t6) set_page_dirty()
           t7) __set_page_dirty()
	    t8) radix_tree_tag_set(PAGECACHE_TAG_DIRTY)
// page is dirtied, but inode is yet clean.
---------------------- Pre-empted-----------------
P2: freeze process

t9) freeze_super()
   t10) sync_filesystem()
  // page cache now clean! no inode is dirty.
// however we have a dirty page belonging to a clean inode.
----------------------Freeze process finishes, filesystem frozen!----


P1: process that tries mmap write gets control.
t11) __set_page_dirty() // gets control back
     t12) __mark_inode_dirty()v
    // inode is now dirty and it has a dirty page.
    // though in reality there is no write which has occured.
t13)   if (inode->i_sb->s_frozen != SB_UNFROZEN)
     // __block_page_mkwrite() gets control back
t14) unlock_page()
t15) __block_page_mkwrite() returns -EAGAIN
t16) block_page_mkwrite() returns VM_FAULT_RETRY

---------------------------
// now we see the original deadlock reported.
P3: sync a filesystem
t17) down_read(s_umount)
  t18) sync_filesystem()
   t19) sb->s_op->sync_fs() // =ext4_sync_fs()
    t20) vfs_check_frozen() // now blocks for thaw.
// so thaw cannot happen because sync process sleeps with s_umount!

This deadlock can occur whenever the freeze happens after the 
vfs_check_frozen() but before the __mark_inode_dirty().

We see blocked sync processes every time we do the following:

1) executing iozone on multipath and
2) I modified the script that Toshiyuki sent, attaching it here. This 
script reproduces the bug faster when executed with iozone.
(Note, that since this is a race, this script _may not_ always produce 
it on its own)


I also found one more missing piece in the "Add support to freeze and 
unfreeze journal":
1) Call jdb2_journal_thaw() from ext4_unfreeze() to restart the 
transactions.

I shall send a patch for the same as a reply to this email again.

Thanks!

Warm Regards,
Surbhi.












P3: sync







>
> Do these patches fix the problem you've been trying to fix with your
> patches?  I believe they should, but I would appreciate confirmation
> that with these patches, you're no longer able to reproduce the
> problem you've been concerned about.
>
> Thanks, regards,
>
> 						- Ted


--------------000506060100050205000601
Content-Type: application/x-sh;
 name="test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test.sh"

#!/bin/sh
# Nothing should dirty the page cache when fs is frozen.
# sync should not block - it should find the page cache clean and return immediately
# Original mmapped part from Toshiyuki Okajima, sent on #ext4ml.

FS=ext4
gcc -o ./write ./write.c
dd if=/dev/zero of=/tmp/loop.$$ bs=1k seek=64k count=1 > /dev/null 2>&1
/sbin/mkfs.$FS -Fq /tmp/loop.$$
/sbin/losetup /dev/loop7 /tmp/loop.$$
mkdir -p mnt
mount -t $FS /dev/loop7 mnt
########################################################
## Test freeze followed by an immediate sync
dd if=/dev/zero of=mnt/file bs=4k count=100 > /dev/null 2>&1
/sbin/fsfreeze -f mnt
echo "testing freeze, sync"
echo "does fsfreeze really clean the page cache?"
sync
echo "sync is over - it did not deadlock with fsfreeze. Works correctly"
/sbin/fsfreeze -u mnt &
wait
echo "###########################"
########################################################
## Test freeze, mmapped write, sync , unfreeze in parallel
./write mnt/file &
pid=$!
# write 0
/bin/kill -SIGUSR1 $pid
echo "testing freeze, mmapped write, sync, unfreeze - in parallel"
/sbin/fsfreeze -f mnt &
# should not be able to write 1
/bin/kill -SIGUSR1 $pid &
echo "does fsfreeze really stop an mmapped write from happening?"
sync  &
/sbin/fsfreeze -u mnt 
echo -n "thawing of fs done too - it did not deadlock with sync - page" \
	" cache not dirtied"
/bin/kill -SIGTERM $pid
wait
echo "###########################"
#################################
## Test freeze, aio write, sync , unfreeze in parallel
echo "testing freeze, aio write, sync, unfreeze in parallel"
/sbin/fsfreeze -f mnt &
# dd must block as fs is frozen!
{
dd if=/dev/zero of=mnt/aio-writes bs=4k count=100 > /dev/null 2>&1 
}&
echo -n "does fsfreeze really stop an aio write from happening?"
echo " sync should wait on vfs_check_frozen when the page cache is dirty"
sync & 
/sbin/fsfreeze -u mnt 
echo -n "thawing of fs done too - it did not deadlock with sync - page" \
	" cache not dirtied"
wait
echo "###########################"
#################################
### Test read a file when the fs is frozen - test the touch_atime path
echo "Testing freeze, touch_atime, sync and unfreeze in parallel"
/sbin/fsfreeze -f mnt &
cat mnt/aio-writes & # this should ideally stop on the journal_start
#if this does not stop on the journal_start then the page cache is dirty. sync
# should hang on vfs_check_frozen
pid=$!
echo -n "does fsfreeze really stop an aio write from happening?"
echo " sync should wait on vfs_check_frozen when the page cache is dirty"
sync & 
pid2=$!
/sbin/fsfreeze -u mnt 
echo -n "thawing of fs done too - it did not deadlock with sync - page" \
	" cache not dirtied"
wait
echo "###########################"
#################################
exit 0

--------------000506060100050205000601--
