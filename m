From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Date: Wed, 28 Nov 2018 13:02:56 +0300
Message-ID: <en52df-5dh.ln1@banana.localnet>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net> <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net> <vb31df-25g.ln1@banana.localnet> <20181128041555.GE31885@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In gmane.comp.file-systems.ext4 Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote:
> > Corrupted inodes - always directory, not touched at least year or
> > more for writing. Something wrong when updating atime?

> We're not sure.  The frustrating thing is that it's not reproducing
> for me.  I run extensive regression tests, and I'm using 4.19 on my
> development laptop without notcing any problems.  If I could reproduce
> it, I could debug it, but since I can't, I need to rely on those who
> are seeing the problem to help pinpoint the problem.

My workstation hit this bug every time after boot. If you have an idea - I
may test it.

> I'm trying to figure out common factors from those people who are
> reporting problems.

> (a) What distribution are you running (it appears that many people
> reporting problems are running Ubuntu, but this may be a sampling
> issue; lots of people run Ubuntu)?  (For the record, I'm using Debian
> Testing.)
Debian sid but self-build kernel from ubuntu mainline-ppa.

> (b) What hardware are you using?  (SSD?  SATA-attached?
> NVMe-attached?)
SATA HDD WDC WD20EZRZ-00Z5HB0.

> (c) Are you using LVM?  LUKS (e.g., disk encrypted)?
No and no. Plain ext4.
-- cut --
debugfs:  features 
Filesystem features: has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent 64bit flex_bg sparse_super large_file huge_file
dir_nlink extra_isize metadata_csum
-- cut --

> (d) are you using discard?  One theory is a recent discard change may
> be in play.   How do you use discard?   (mount option, fstrim, etc.)

no
