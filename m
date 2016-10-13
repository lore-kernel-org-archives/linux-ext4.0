From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: Test generic/299 stalling forever
Date: Thu, 13 Oct 2016 16:36:35 +0300
Message-ID: <20161013133635.GA16723@yogzotot>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org>
 <20161013130836.GA16445@yogzotot>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Cc: Jens Axboe <axboe@fb.com>, Dave Chinner <david@fromorbit.com>,
        linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        tarasov@vasily.name
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from u164.east.ru ([195.170.63.164]:33346 "EHLO u164.east.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753231AbcJMNgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Oct 2016 09:36:39 -0400
Content-Disposition: inline
In-Reply-To: <20161013130836.GA16445@yogzotot>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 04:08:37PM +0300, Anatoly Pugachev wrote:
> On Wed, Oct 12, 2016 at 10:15:52PM -0400, Theodore Ts'o wrote:
> > On Wed, Oct 12, 2016 at 03:19:25PM -0600, Jens Axboe wrote:
> > > 
> > > FWIW, this is the commit that fixes it:
> > > 
> > > commit 39d13e67ef1f4b327c68431f8daf033a03920117
> > > Author: Jens Axboe <axboe@fb.com>
> > > Date:   Fri Aug 26 14:39:30 2016 -0600
> > > 
> > >     backend: check if we need to update rusage stats, if stat_mutex is busy
> > > 
> > > 2.14 and newer should not have the problem, but earlier versions may
> > > depending on how old...
> > 
> > Unfortunately, I'm still seeing hangs in generic/299 with the latest version of fio:
> > 
> > fio 	  fio-2.14-10-g0a301e9 (Fri, 23 Sep 2016 11:57:00 -0600)
> > 
> > If I use an older fio, it reliably does not hang.  What can I do to
> > help debug this?
> > 
> > As I said, I can attach to the hanging fio using a gdb and give you
> > stackdumps for all of the threads if that would be helpful.

I'm sorry, didn't read that it only with ext4, it hangs for me with ext4 as
well.

# mkfs.ext4 /dev/loop0
mke2fs 1.43.3 (04-Sep-2016)
/dev/loop0 contains a xfs file system
Proceed anyway? (y,n) y
Discarding device blocks: done
Creating filesystem with 3145728 4k blocks and 786432 inodes
Filesystem UUID: 18abfd64-3395-43c4-9c7d-f2c312e7516d
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

root@ttip:/home/mator/xfstests-dev# ./check generic/299
FSTYP         -- ext4
PLATFORM      -- Linux/sparc64 ttip 4.8.0+
MKFS_OPTIONS  -- /dev/loop1
MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop1 /mnt/scratch

generic/299 103s ... 104s

(hangs)

on another console:

$ pstree -Alap

  |                       `-check,219419 ./check generic/299
  |                           `-fsck,221209 -t ext4 -nf /dev/loop1
  |                               `-fsck.ext4,221210 -nf /dev/loop1

fsck.ext4 can't finish its work

# strace \-p 221210   
strace: Process 221210 attached
pread64(4, "\n\363R\0T\1\0\0\0\0\0\0\37\350\"\0\1\0\0\0x+\26\0*\350\"\0\1\0\0\0"..., 4096, 12793810944) = 4096
pread64(4, "\n\363\37\1T\1\0\0\0\0\0\0\260\356\"\0\1\0\0\0\227\256/\0\261\356\"\0\1\0\0\0"..., 4096, 3918262272) = 4096
pread64(4, "\n\363\357\0T\1\0\0\0\0045\254\32\6#\0\1\0\0\0\275\322 \0%\6#\0\1\0\0\0"..., 4096, 974860288) = 4096
pread64(4, "\n\363\226\0T\1\0\0\0\0\0\2\377\31#\0\1\0\0\0\311\257/\0\33\32#\0\1\0\0\0"..., 4096, 3927293952) = 4096
brk(0x10000d08000)                      = 0x10000d08000
pread64(4, "\n\363\306\0T\1\0\0\0\0\0\2L%#\0\1\0\0\0<3\10\0Y%#\0\1\0\0\0"..., 4096, 6654865408) = 4096
pread64(4, "\n\363\3\0T\1\0\0\0\0\0\0\2124#\0\1\0\0\0\272\263\2\0\2344#\0\1\0\0\0"..., 4096, 3800674304) = 4096
pread64(4, "\n\363\254\0T\1\0\0!\277\301~\3074#\0\1\0\0\0\"\310\16\0\3514#\0\1\0\0\0"..., 4096, 2717888512) = 4096
pread64(4, "\n\363Q\1T\1\0\0\255\255\255\255\307B#\0\1\0\0\0S\231\6\0\313B#\0\1\0\0\0"..., 4096, 4038303744) = 4096
pread64(4, "\n\363/\0T\1\0\0&o\r\201e^#\0\1\0\0\0\233\237\f\0\202^#\0\1\0\0\0"..., 4096, 4184920064) = 4096
pread64(4, "\n\363\244\0T\1\0\0\305\305\305\305\266b#\0\1\0\0\0n]\21\0\322b#\0\1\0\0\0"..., 4096, 6043922432) = 4096
pread64(4, "\n\363\"\1T\1\0\0\0\0\0\2\310q#\0\1\0\0\0 \337\26\0\335q#\0\1\0\0\0"..., 4096, 4194627584) = 4096
pread64(4, "\n\363\376\0T\1\0\0\0\0\0\2F\211#\0\1\0\0\0 \256/\0M\211#\0\1\0\0\0"..., 4096, 6049001472) = 4096
pread64(4, "\n\363]\0T\1\0\0\0\0\0\1\16\235#\0\1\0\0\0\272_\30\0\20\235#\0\1\0\0\0"..., 4096, 6567260160) = 4096
pread64(4, "\n\363\343\0T\1\0\0eeee\317\243#\0\1\0\0\0\264\222\20\0\332\243#\0\1\0\0\0"..., 4096, 6083014656) = 4096
pread64(4, "\n\363\332\0T\1\0\0\36\255\246d\216\264#\0\1\0\0\0.\212\17\0\242\264#\0\1\0\0\0"..., 4096, 8083423232) = 4096
pread64(4, "\n\363\334\0T\1\0\0EEEEW\306#\0\1\0\0\0^\273\20\0g\306#\0\1\0\0\0"..., 4096, 6083252224) = 4096
pread64(4, "\n\363\333\0T\1\0\0\0\0\0\0@\330#\0\1\0\0\0Z\353\23\0N\330#\0\1\0\0\0"..., 4096, 7774924800) = 4096
pread64(4, "\n\363x\0T\1\0\0{{{{H\347#\0\1\0\0\0\232~\27\0M\347#\0\1\0\0\0"..., 4096, 4735361024) = 4096
pread64(4, "\n\363\367\0T\1\0\0\377\377\377\377#\361#\0\1\0\0\0O\t\27\0b\361#\0\1\0\0\0"..., 4096, 4448808960) = 4096
pread64(4, "\n\363\t\0T\1\0\0aaaa\271\2$\0\1\0\0\0\351I\21\0\340\2$\0\1\0\0\0"..., 4096, 5948190720) = 4096
pread64(4, "\n\363\25\0T\1\0\0\0\0\0\0@\3$\0\1\0\0\0t\33.\0D\3$\0\1\0\0\0"..., 4096, 1714593792) = 4096
pread64(4, "\n\363b\0T\1\0\0\0\0\0\0g\4$\0\1\0\0\0\332\366\0\0n\4$\0\1\0\0\0"..., 4096, 1635794944) = 4096
pread64(4, "\n\363)\1T\1\0\0\0\0\0\0%\v$\0\1\0\0\0e\230\17\0003\v$\0\1\0\0\0"..., 4096, 2111643648) = 4096
pread64(4, "\n\363<\0T\1\0\0\0\0\0\0D $\0\1\0\0\0\1\355 \0T $\0\1\0\0\0"..., 4096, 165666816) = 4096
brk(0x10000d2a000)                      = 0x10000d2a000
pread64(4, "\n\363\n\0T\1\0\0\301\301\301\3012%$\0\1\0\0\0r\37\22\0004%$\0\1\0\0\0"..., 4096, 4871196672) = 4096
pread64(4, "\n\363\225\0T\1\0\0\0\0\0\1(&$\0\1\0\0\0\213\"\22\0@&$\0\1\0\0\0"..., 4096, 5401088000) = 4096
^Cstrace: Process 221210 detached

$ dpkg -l e2fsprogs
ii  e2fsprogs                1.43.3-1          sparc64 ext2/ext3/ext4 file system utilities

299.full in attachment

--IS0zKkzwUGydFO0o
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="299.full.gz"
Content-Transfer-Encoding: base64

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
RAZbAAA=

--IS0zKkzwUGydFO0o--
