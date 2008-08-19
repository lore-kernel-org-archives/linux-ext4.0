From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Tue, 19 Aug 2008 13:51:12 +0300
Message-ID: <20080819105111.GK8997@lh.kyla.fi>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz> <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int> <20080819091339.GE14799@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:49579 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYHSLDP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2008 07:03:15 -0400
Content-Disposition: inline
In-Reply-To: <20080819091339.GE14799@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 19, 2008 at 11:13:39AM +0200, Jan Kara wrote:
> > Isn't equivalent checking done in ext2_check_descriptors()?  It would make
> > sense to abstract out the "check one group and return error" code and use
> > it in both places.
>   Actually yes, it is. Good point. Sami, is it the case that you have
> mounted the filesystem, then intentionally corrupted it and after that
> the kernel oopsed (as opposed to first corrupting the filesystem image and
> mounting it after that)? That would explain how corrupted values could get
> to read_block_bitmap() even though ext2_check_descriptors() checked them.

No, that's not what I do. I corrupt the fs before mounting it, then
mount it, perform normal filesystem operations on it and unmount it.

Here's the most current script I use (zzuf is the fuzzer):

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
