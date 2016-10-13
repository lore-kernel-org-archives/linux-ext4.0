From: Jens Axboe <axboe@fb.com>
Subject: Re: Test generic/299 stalling forever
Date: Thu, 13 Oct 2016 08:28:24 -0600
Message-ID: <22600770-bfc4-6876-f1c9-b38d8022f603@fb.com>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard> <20160929043722.ypf3tnxsl6ovt653@thunk.org>
 <20161012211407.GL23194@dastard>
 <f1c80b32-9593-48e0-05e9-4c8b97380b49@fb.com>
 <20161013021552.l6afs2k5tjcsfp2k@thunk.org> <20161013130836.GA16445@yogzotot>
 <20161013133635.GA16723@yogzotot>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, <linux-ext4@vger.kernel.org>,
        <fstests@vger.kernel.org>, <tarasov@vasily.name>
To: Anatoly Pugachev <matorola@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20161013133635.GA16723@yogzotot>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/13/2016 07:36 AM, Anatoly Pugachev wrote:
> On Thu, Oct 13, 2016 at 04:08:37PM +0300, Anatoly Pugachev wrote:
>> On Wed, Oct 12, 2016 at 10:15:52PM -0400, Theodore Ts'o wrote:
>>> On Wed, Oct 12, 2016 at 03:19:25PM -0600, Jens Axboe wrote:
>>>>
>>>> FWIW, this is the commit that fixes it:
>>>>
>>>> commit 39d13e67ef1f4b327c68431f8daf033a03920117
>>>> Author: Jens Axboe <axboe@fb.com>
>>>> Date:   Fri Aug 26 14:39:30 2016 -0600
>>>>
>>>>     backend: check if we need to update rusage stats, if stat_mutex is busy
>>>>
>>>> 2.14 and newer should not have the problem, but earlier versions may
>>>> depending on how old...
>>>
>>> Unfortunately, I'm still seeing hangs in generic/299 with the latest version of fio:
>>>
>>> fio 	  fio-2.14-10-g0a301e9 (Fri, 23 Sep 2016 11:57:00 -0600)
>>>
>>> If I use an older fio, it reliably does not hang.  What can I do to
>>> help debug this?
>>>
>>> As I said, I can attach to the hanging fio using a gdb and give you
>>> stackdumps for all of the threads if that would be helpful.
>
> I'm sorry, didn't read that it only with ext4, it hangs for me with ext4 as
> well.
>
> # mkfs.ext4 /dev/loop0
> mke2fs 1.43.3 (04-Sep-2016)
> /dev/loop0 contains a xfs file system
> Proceed anyway? (y,n) y
> Discarding device blocks: done
> Creating filesystem with 3145728 4k blocks and 786432 inodes
> Filesystem UUID: 18abfd64-3395-43c4-9c7d-f2c312e7516d
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
>
> root@ttip:/home/mator/xfstests-dev# ./check generic/299
> FSTYP         -- ext4
> PLATFORM      -- Linux/sparc64 ttip 4.8.0+
> MKFS_OPTIONS  -- /dev/loop1
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/loop1 /mnt/scratch
>
> generic/299 103s ... 104s
>
> (hangs)
>
> on another console:
>
> $ pstree -Alap
>
>   |                       `-check,219419 ./check generic/299
>   |                           `-fsck,221209 -t ext4 -nf /dev/loop1
>   |                               `-fsck.ext4,221210 -nf /dev/loop1
>
> fsck.ext4 can't finish its work
>
> # strace \-p 221210
> strace: Process 221210 attached
> pread64(4, "\n\363R\0T\1\0\0\0\0\0\0\37\350\"\0\1\0\0\0x+\26\0*\350\"\0\1\0\0\0"..., 4096, 12793810944) = 4096
> pread64(4, "\n\363\37\1T\1\0\0\0\0\0\0\260\356\"\0\1\0\0\0\227\256/\0\261\356\"\0\1\0\0\0"..., 4096, 3918262272) = 4096
> pread64(4, "\n\363\357\0T\1\0\0\0\0045\254\32\6#\0\1\0\0\0\275\322 \0%\6#\0\1\0\0\0"..., 4096, 974860288) = 4096
> pread64(4, "\n\363\226\0T\1\0\0\0\0\0\2\377\31#\0\1\0\0\0\311\257/\0\33\32#\0\1\0\0\0"..., 4096, 3927293952) = 4096
> brk(0x10000d08000)                      = 0x10000d08000
> pread64(4, "\n\363\306\0T\1\0\0\0\0\0\2L%#\0\1\0\0\0<3\10\0Y%#\0\1\0\0\0"..., 4096, 6654865408) = 4096
> pread64(4, "\n\363\3\0T\1\0\0\0\0\0\0\2124#\0\1\0\0\0\272\263\2\0\2344#\0\1\0\0\0"..., 4096, 3800674304) = 4096
> pread64(4, "\n\363\254\0T\1\0\0!\277\301~\3074#\0\1\0\0\0\"\310\16\0\3514#\0\1\0\0\0"..., 4096, 2717888512) = 4096
> pread64(4, "\n\363Q\1T\1\0\0\255\255\255\255\307B#\0\1\0\0\0S\231\6\0\313B#\0\1\0\0\0"..., 4096, 4038303744) = 4096
> pread64(4, "\n\363/\0T\1\0\0&o\r\201e^#\0\1\0\0\0\233\237\f\0\202^#\0\1\0\0\0"..., 4096, 4184920064) = 4096
> pread64(4, "\n\363\244\0T\1\0\0\305\305\305\305\266b#\0\1\0\0\0n]\21\0\322b#\0\1\0\0\0"..., 4096, 6043922432) = 4096
> pread64(4, "\n\363\"\1T\1\0\0\0\0\0\2\310q#\0\1\0\0\0 \337\26\0\335q#\0\1\0\0\0"..., 4096, 4194627584) = 4096
> pread64(4, "\n\363\376\0T\1\0\0\0\0\0\2F\211#\0\1\0\0\0 \256/\0M\211#\0\1\0\0\0"..., 4096, 6049001472) = 4096
> pread64(4, "\n\363]\0T\1\0\0\0\0\0\1\16\235#\0\1\0\0\0\272_\30\0\20\235#\0\1\0\0\0"..., 4096, 6567260160) = 4096
> pread64(4, "\n\363\343\0T\1\0\0eeee\317\243#\0\1\0\0\0\264\222\20\0\332\243#\0\1\0\0\0"..., 4096, 6083014656) = 4096
> pread64(4, "\n\363\332\0T\1\0\0\36\255\246d\216\264#\0\1\0\0\0.\212\17\0\242\264#\0\1\0\0\0"..., 4096, 8083423232) = 4096
> pread64(4, "\n\363\334\0T\1\0\0EEEEW\306#\0\1\0\0\0^\273\20\0g\306#\0\1\0\0\0"..., 4096, 6083252224) = 4096
> pread64(4, "\n\363\333\0T\1\0\0\0\0\0\0@\330#\0\1\0\0\0Z\353\23\0N\330#\0\1\0\0\0"..., 4096, 7774924800) = 4096
> pread64(4, "\n\363x\0T\1\0\0{{{{H\347#\0\1\0\0\0\232~\27\0M\347#\0\1\0\0\0"..., 4096, 4735361024) = 4096
> pread64(4, "\n\363\367\0T\1\0\0\377\377\377\377#\361#\0\1\0\0\0O\t\27\0b\361#\0\1\0\0\0"..., 4096, 4448808960) = 4096
> pread64(4, "\n\363\t\0T\1\0\0aaaa\271\2$\0\1\0\0\0\351I\21\0\340\2$\0\1\0\0\0"..., 4096, 5948190720) = 4096
> pread64(4, "\n\363\25\0T\1\0\0\0\0\0\0@\3$\0\1\0\0\0t\33.\0D\3$\0\1\0\0\0"..., 4096, 1714593792) = 4096
> pread64(4, "\n\363b\0T\1\0\0\0\0\0\0g\4$\0\1\0\0\0\332\366\0\0n\4$\0\1\0\0\0"..., 4096, 1635794944) = 4096
> pread64(4, "\n\363)\1T\1\0\0\0\0\0\0%\v$\0\1\0\0\0e\230\17\0003\v$\0\1\0\0\0"..., 4096, 2111643648) = 4096
> pread64(4, "\n\363<\0T\1\0\0\0\0\0\0D $\0\1\0\0\0\1\355 \0T $\0\1\0\0\0"..., 4096, 165666816) = 4096
> brk(0x10000d2a000)                      = 0x10000d2a000
> pread64(4, "\n\363\n\0T\1\0\0\301\301\301\3012%$\0\1\0\0\0r\37\22\0004%$\0\1\0\0\0"..., 4096, 4871196672) = 4096
> pread64(4, "\n\363\225\0T\1\0\0\0\0\0\1(&$\0\1\0\0\0\213\"\22\0@&$\0\1\0\0\0"..., 4096, 5401088000) = 4096
> ^Cstrace: Process 221210 detached
>
> $ dpkg -l e2fsprogs
> ii  e2fsprogs                1.43.3-1          sparc64 ext2/ext3/ext4 file system utilities

If it's fsck that's hung, then that's a different issue than the one Ted
is reporting, where it is fio that is hung. I've run your test case 10
times this morning, and I haven't seen any issues.

I'll try with two nvme devices and see if that changes the situation for
me. Ted, what devices are you using for data/scratch?

-- 
Jens Axboe
