From: Filipe David Manana <fdmanana@gmail.com>
Subject: Re: [ANNOUNCE] xfstests: updated to cf1ed54
Date: Tue, 8 Apr 2014 16:16:18 +0100
Message-ID: <CAL3q7H7Uo3d4b+KjPmVMftrVaMu5Ta12B7-BK9498HL_bKfAPg@mail.gmail.com>
References: <20140404090357.GW17603@dastard>
	<CAL3q7H6q7M-hrvniaVkAm_L6aSHANmnfdTKGEHHLFqXUhWfY5w@mail.gmail.com>
	<20140408001443.GG27017@dastard>
Reply-To: fdmanana@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40499 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbaDHPQU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 11:16:20 -0400
In-Reply-To: <20140408001443.GG27017@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 8, 2014 at 1:14 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Apr 04, 2014 at 02:07:16PM +0100, Filipe David Manana wrote:
>> On Fri, Apr 4, 2014 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > Hi folks,
>> >
>> > The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
>> > just been updated. Patches often get missed, so please check if your
>> > outstanding patches were in this update. If they have not been in
>> > this update, please resubmit them to xfs@oss.sgi.com so they can be
>> > picked up in the next update.
>> >
>> > The new head of the master branch is commit:
>> >
>> > cf1ed54 check: fix RESULT_BASE typo in check script
>> >
>> > The major new functionality worth mentioning in this update is the
>> > new config file format from Lukas. The existing format config files
>> > should continue to work without change, but the new format is much
>> > richer and allows specification of multiple different configurations
>> > to run test under. Hence testing multiple mount an dmkfs
>> > configurations becomes as simple as iterating the configurations
>> > in the config file.
>>
>> Hi,
>>
>> I might be missing something, but after checking out these changes, I
>> am no longer able to run btrfs tests. Example:
>>
>> $ ./check btrfs/041
>> common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
>> Passed all 0 tests
>>
>> $ cat local.config
>> export TEST_DEV=/dev/sdb
>> export TEST_DIR=/home/fdmanana/btrfs-tests/dev
>> export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
>> export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"
>
> Are you sure that's the config file that is being picked up? I can't
> test btrfs at the moment because it appears to be completely screwed
> in a TOT kernel right now - it doesn't even show up in
> /proc/filesystems and doesn't emit anything on dmesg to indicate
> that initialisation of the built in btrfs code has failed or even
> been attempted. It's simply MIA....
>
> However, using that same SCRATCH_DEV_POOL config for xfs or ext4
> works just fine on my test machines with the current TOT xfstests
> and kernel code.
>
> $ cat configs/test2.config
> TEST_DIR=/mnt/test
> SCRATCH_MNT=/mnt/scratch
> TEST_DEV=/dev/vda
> SCRATCH_DEV_POOL="/dev/vdc /dev/vdd"
> $ sudo MKFS_OPTIONS="-m crc=1" ./check generic/001
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test2 3.14.0-rc1-dgc+
> MKFS_OPTIONS  -- -f -m crc=1 /dev/vdc
> MOUNT_OPTIONS -- /dev/vdc /mnt/scratch
>
> generic/001 4s ... 3s
> Ran: generic/001
> Passed all 1 tests
> $
>
> So, as you can see I can't reproduce your problem myself right now.
> Could you add a "set -x" line to the start of check and post the
> output?

Ok, here's some more tests:

# On origin/master:

root 16:56:42 /home/fdmanana/git/hub/xfstests ((cf1ed54...))> cat local.config
export TEST_DEV=/dev/sdb
export TEST_DIR=/home/fdmanana/btrfs-tests/dev
export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"
export FSTYP=btrfs

root 16:56:49 /home/fdmanana/git/hub/xfstests ((cf1ed54...))> ./check
generic/001
common/config: Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
Passed all 0 tests

# Now going back to an older revision, it works as I showed before:

root 16:56:56 /home/fdmanana/git/hub/xfstests ((cf1ed54...))> git
checkout 3948694eb12e9699f558fab5e8169a8b090780d1
Previous HEAD position was cf1ed54... check: fix RESULT_BASE typo in
check script
HEAD is now at 3948694... xfs/300: fix golden output

root 16:57:11 /home/fdmanana/git/hub/xfstests ((3948694...))> ./check
generic/001
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 debian-vm3 3.13.0-fdm-btrfs-next-24+
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

generic/001 23s ... 23s
Ran: generic/001
Passed all 1 tests

# Now if I change my config and remove the definition of FSTYP, it
still works with the old revision:

root 16:59:19 /home/fdmanana/git/hub/xfstests ((3948694...))> cat local.config
# Ideally define at least these 4 to match your environment
# The first 2 are required.
# See README for other variables which can be set.
#
# Note: SCRATCH_DEV >will< get overwritten!

export TEST_DEV=/dev/sdb
export TEST_DIR=/home/fdmanana/btrfs-tests/dev
export SCRATCH_MNT="/home/fdmanana/btrfs-tests/scratch_1"
export SCRATCH_DEV_POOL="/dev/sdc /dev/sdd"
# export FSTYP=btrfs

root 16:59:22 /home/fdmanana/git/hub/xfstests ((3948694...))> ./check
generic/001
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 debian-vm3 3.13.0-fdm-btrfs-next-24+
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

generic/001 23s ... 23s
Ran: generic/001
Passed all 1 tests

# Now going back to master, without FSTYP set, it doesn't work too:

root 16:59:50 /home/fdmanana/git/hub/xfstests ((3948694...))> git
checkout origin/master
Previous HEAD position was 3948694... xfs/300: fix golden output
HEAD is now at cf1ed54... check: fix RESULT_BASE typo in check script

root 16:59:57 /home/fdmanana/git/hub/xfstests ((cf1ed54...))> ./check
generic/001
common/rc: Error: $TEST_DEV (/dev/sdb) is not a MOUNTED xfs filesystem
Filesystem     Type  1024-blocks  Used Available Capacity Mounted on
/dev/sdb       btrfs    20971520   768  18845184       1%
/home/fdmanana/btrfs-tests/dev
root 17:00:00 /home/fdmanana/git/hub/xfstests ((cf1ed54...))>


After adding set -x to the top of the 'check' script, here's the
output when running current master:

https://friendpaste.com/6x8Hzq3wJxe2KXZypomCiY

And for the revision that works:  https://friendpaste.com/6x8Hzq3wJxe2KXZyppKkwB

Hope it helps.
Thanks



>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
