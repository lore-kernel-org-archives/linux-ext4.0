From: Jan Kara <jack@suse.cz>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging request in ext2_free_blocks
Date: Wed, 20 Aug 2008 12:25:33 +0200
Message-ID: <20080820102533.GA5979@atrey.karlin.mff.cuni.cz>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz> <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int> <20080819091339.GE14799@duck.suse.cz> <20080819105111.GK8997@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Sami Liedes <sliedes@cc.hut.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54821 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYHTKZe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 06:25:34 -0400
Content-Disposition: inline
In-Reply-To: <20080819105111.GK8997@lh.kyla.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Tue, Aug 19, 2008 at 11:13:39AM +0200, Jan Kara wrote:
> > > Isn't equivalent checking done in ext2_check_descriptors()?  It would make
> > > sense to abstract out the "check one group and return error" code and use
> > > it in both places.
> >   Actually yes, it is. Good point. Sami, is it the case that you have
> > mounted the filesystem, then intentionally corrupted it and after that
> > the kernel oopsed (as opposed to first corrupting the filesystem image and
> > mounting it after that)? That would explain how corrupted values could get
> > to read_block_bitmap() even though ext2_check_descriptors() checked them.
> 
> No, that's not what I do. I corrupt the fs before mounting it, then
> mount it, perform normal filesystem operations on it and unmount it.
  OK, thanks. Then we must somehow corrupt group descriptor block during
the operation. Because I'm pretty sure it *is* corrupted - the oops
is: unable to handle kernel paging request at c7e95ffc. If we look into
registers, we see ECX has c7e96000 (which is probably bh->b_data). In
the second oops it's exactly the same - ECX has c11e4000, the oops is at
address c11e3ffc. So in both cases it is ECX-4. So somehow we managed to
pass negative offset into ext2_test_bit(). But as Andreas pointed out,
when we load descriptors into memory, we check that both bitmaps and
inode table is in ext2_check_descriptors()... The other possibility
would be that we managed to corrupts s_first_data_block in the
superblock. Anyway, both possibilities don't look very likely. I'll try
to reproduce the problem and maybe get more insight... How large is your
filesystem BTW?

> Here's the most current script I use (zzuf is the fuzzer):
> 
> ------------------------------------------------------------
> #!/bin/sh
> 
> if [ "`hostname`" != "fstest" ]; then
>    echo "This is a dangerous script."
>    echo "Set your hostname to \`fstest\' if you want to use it."
>    exit 1
> fi
> 
> umount /dev/hdb
> umount /dev/hdc
> /etc/init.d/sysklogd stop
> /etc/init.d/klogd stop
> /etc/init.d/cron stop
> mount /dev/hda / -t ext3 -o remount,ro || exit 1
> 
> #ulimit -t 20
> 
> for ((s=$1; s<1000000000; s++)); do
>   umount /mnt
>   echo '***** zzuffing *****' seed $s
>   zzuf -r 0:0.03 -s $s </dev/hdc >/dev/hdb || exit
>   mount /dev/hdb /mnt -t ext2 -o errors=continue || continue
>   cd /mnt || continue
>   timeout 30 cp -r doc doc2 >&/dev/null
>   timeout 30 find -xdev >&/dev/null
>   timeout 30 find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
>   timeout 30 mkdir tmp >&/dev/null
>   timeout 30 echo whoah >tmp/filu 2>/dev/null
>   timeout 30 rm -rf /mnt/* >&/dev/null
>   cd /
> done
> ------------------------------------------------------------

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
