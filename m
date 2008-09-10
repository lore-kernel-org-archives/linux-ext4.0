From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bug 11525] New: Unable to handle paging request at
	ext3_rmdir() and ext4_rmdir() on intentionally corrupted fs
Date: Wed, 10 Sep 2008 06:26:34 +0300
Message-ID: <20080910032633.GH8723@lh.kyla.fi>
References: <bug-11525-27@http.bugzilla.kernel.org/> <20080909134627.75bd0a80.akpm@linux-foundation.org> <15802_1220997383_ZZ0K6Y00A5R7LWI2.00_20080909215531.GE21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:53393 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYIJD1q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Sep 2008 23:27:46 -0400
Content-Disposition: inline
In-Reply-To: <15802_1220997383_ZZ0K6Y00A5R7LWI2.00_20080909215531.GE21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 05:55:31PM -0400, Theodore Tso wrote:
> > > Unfortunately this is one of those bugs that I can't find a way to
> > > reproduce except by randomly breaking one fs after another. This
> > > happens with ext3 and ext4, but so far I haven't seen it happen
> > > with ext2.
> > > 
> > >
> > > *** seed 270, ext3, 2.6.27-rc3 ***
> > > *** seed 451, ext4, 2.6.27-rc5 ***
> 
> Given these seed numbers, I assume this was generating using some tool
> like fsfuzzer?  Would it be possible to generate a filesystem image
> *before* that triggers the problem case, before trying to execute the
> rm -rf?  
> 
> That would be the fastest way to try to track the problem down.

Yes, I can generate those filesystems. However the problem seems to be
elusive in that I haven't yet been able to reproduce it twice with the
same filesystem (and even with random filesystems, it every occurs
once in a while). I'll do some more testing and try to figure out if
it can be reproduced more easily. Still I can give you some
filesystems that crashed once, if you wish. They are typically
something like 600 KiB compressed, and I guess that could be made less
by zeroing all regular files in the pristine fs before doing the
fuzzing.

Here's a script I use to do the testing ($1 is the initial seed). The
filesystem is a 10 MiB pristine ext[34] image with a copy of my
workstation's /dev and a partial copy of /usr/share/doc (I tried to be
diverse in what I put there).

------------------------------------------------------------
#!/bin/sh

if [ "`hostname`" != "fstest" ]; then
   echo "This is a dangerous script."
   echo "Set your hostname to \`fstest\' if you want to use it."
   exit 1
fi

umount /dev/hdb
umount /dev/hdc
/etc/init.d/sysklogd stop
/etc/init.d/klogd stop
/etc/init.d/cron stop
mount /dev/hda / -t ext3 -o remount,ro || exit 1

#ulimit -t 20

for ((s=$1; s<1000000000; s++)); do
  umount /mnt
  echo '***** zzuffing *****' seed $s
  zzuf -r 0:0.03 -s $s </dev/hdc >/dev/hdb || exit
  mount /dev/hdb /mnt -t ext2 -o errors=continue || continue
  cd /mnt || continue
  timeout 30 cp -r doc doc2 >&/dev/null
  timeout 30 find -xdev >&/dev/null
  timeout 30 find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
  timeout 30 mkdir tmp >&/dev/null
  timeout 30 echo whoah >tmp/filu 2>/dev/null
  timeout 30 rm -rf /mnt/* >&/dev/null
  cd /
done
------------------------------------------------------------

	Sami
