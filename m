From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Wed, 20 Aug 2008 13:07:06 -0600
Message-ID: <20080820190704.GD3392@webber.adilger.int>
References: <bug-11266-10286@http.bugzilla.kernel.org/>
 <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi>
 <20080807202840.GC26307@lh.kyla.fi>
 <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
 <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int>
 <20080819091339.GE14799@duck.suse.cz> <20080819105111.GK8997@lh.kyla.fi>
 <20080820102533.GA5979@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Sami Liedes <sliedes@cc.hut.fi>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50897 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYHTTHi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 15:07:38 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7KJ7JrQ000339
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 12:07:30 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5W00A01Y3TEM00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 20 Aug 2008 12:07:19 -0700 (PDT)
In-reply-to: <20080820102533.GA5979@atrey.karlin.mff.cuni.cz>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 20, 2008  12:25 +0200, Jan Kara wrote:
> > On Tue, Aug 19, 2008 at 11:13:39AM +0200, Jan Kara wrote:
> > > > Isn't equivalent checking done in ext2_check_descriptors()?  It would make
> > > > sense to abstract out the "check one group and return error" code and use
> > > > it in both places.
> > >   Actually yes, it is. Good point. Sami, is it the case that you have
> > > mounted the filesystem, then intentionally corrupted it and after that
> > > the kernel oopsed (as opposed to first corrupting the filesystem image and
> > > mounting it after that)? That would explain how corrupted values could get
> > > to read_block_bitmap() even though ext2_check_descriptors() checked them.
> > 
> > No, that's not what I do. I corrupt the fs before mounting it, then
> > mount it, perform normal filesystem operations on it and unmount it.

>   OK, thanks. Then we must somehow corrupt group descriptor block during
> the operation.

Oh, interesting...  The data in the journal is probably corrupt, but all
of the superblock/gdt sanity checks are done BEFORE the journal is replayed.

It would seem that the ext*_fill_super() code should do the sanity checks,
and then recheck the superblock and group descriptors after the journal
is replayed.  The superblock checking code can be moved out of
ext*_fill_super() into a helper function like ext*_check_super()) and then
calling ext*_check_super() and ext*_check_descriptors() again after journal
replay.

Having journal checksums enabled (ext4) would also detect this problem
before the journal replay corrupts the filesystem metadata.

It doesn't look possible that we can do journal recovery before loading
the GDT because ext*_load_journal()->ext*_get_journal() is doing iget()
and this needs the GDT to read the journal inode.

It might also make sense to just clean up the superblock and group descriptor
table and goto the beginning of fill_super() because in some cases the
superblock contents may have changed in important ways (e.g. crash after
resize of the filesystem which is only in the journal).


> Because I'm pretty sure it *is* corrupted - the oops
> is: unable to handle kernel paging request at c7e95ffc. If we look into
> registers, we see ECX has c7e96000 (which is probably bh->b_data). In
> the second oops it's exactly the same - ECX has c11e4000, the oops is at
> address c11e3ffc. So in both cases it is ECX-4. So somehow we managed to
> pass negative offset into ext2_test_bit(). But as Andreas pointed out,
> when we load descriptors into memory, we check that both bitmaps and
> inode table is in ext2_check_descriptors()... The other possibility
> would be that we managed to corrupts s_first_data_block in the
> superblock. Anyway, both possibilities don't look very likely. I'll try
> to reproduce the problem and maybe get more insight... How large is your
> filesystem BTW?
> 
> > Here's the most current script I use (zzuf is the fuzzer):
> > 
> > ------------------------------------------------------------
> > #!/bin/sh
> > 
> > if [ "`hostname`" != "fstest" ]; then
> >    echo "This is a dangerous script."
> >    echo "Set your hostname to \`fstest\' if you want to use it."
> >    exit 1
> > fi
> > 
> > umount /dev/hdb
> > umount /dev/hdc
> > /etc/init.d/sysklogd stop
> > /etc/init.d/klogd stop
> > /etc/init.d/cron stop
> > mount /dev/hda / -t ext3 -o remount,ro || exit 1
> > 
> > #ulimit -t 20
> > 
> > for ((s=$1; s<1000000000; s++)); do
> >   umount /mnt
> >   echo '***** zzuffing *****' seed $s
> >   zzuf -r 0:0.03 -s $s </dev/hdc >/dev/hdb || exit
> >   mount /dev/hdb /mnt -t ext2 -o errors=continue || continue
> >   cd /mnt || continue
> >   timeout 30 cp -r doc doc2 >&/dev/null
> >   timeout 30 find -xdev >&/dev/null
> >   timeout 30 find -xdev -print0 2>/dev/null |xargs -0 touch -- 2>/dev/null
> >   timeout 30 mkdir tmp >&/dev/null
> >   timeout 30 echo whoah >tmp/filu 2>/dev/null
> >   timeout 30 rm -rf /mnt/* >&/dev/null
> >   cd /
> > done
> > ------------------------------------------------------------

Oh, hmm, this is ext2 and not ext3, so no journal...  I guess my bug is
still valid, but just not this one?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

