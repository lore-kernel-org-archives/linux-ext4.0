From: Pavel Machek <pavel@ucw.cz>
Subject: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Sat, 29 Aug 2009 11:49:20 +0200
Message-ID: <20090829094919.GF1634@ucw.cz>
References: <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz> <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


>> So instead of fixing or at least documenting known software deficiency
>> in Linux MD stack, you'll try to surpress that information so that
>> people use more of raid5 setups?
>>
>> Perhaps the better documentation will push them to RAID1, or maybe
>> make them buy an UPS?
>
> people aren't objecting to better documentation, they are objecting to  
> misleading documentation.

Actually Ric is. He's trying hard to make RAID5 look better than it
really is.

> for flash drives the danger is very straightforward (although even then  
> you have to note that it depends heavily on the firmware of the device,  
> some will loose lots of data, some won't loose any)

I have not seen one that works :-(.

> you are generalizing that since you have lost data on flash drives, all  
> flash drives are dangerous.

Do the flash manufacturers claim they do not cause collateral damage
during powerfail? If not, they probably are dangerous.

Anyway, you wanted a test, and one is attached. It normally takes like
4 unplugs to uncover problems.

> but the super simplified statement you keep trying to make is  
> significantly overstating and oversimplifying the problem.

Offer better docs? You are right that it does not lose whole stripe,
it merely loses random block on same stripe, but result for journaling
filesystem is similar.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fstest

#!/bin/bash
#
# Copyright 2008 Pavel Machek <pavel@suse.cz>, GPLv2
#
# vfat is broken with filesize=0
#
#

if [ .$MOUNTOPTS = . ]; then
# ext3 is needed, or you need to disable caches using hdparm.
# odirsync is needed, else modify fstest.worker to fsync the directory.
    MOUNTOPTS="-o dirsync"
fi
if [ .$BDEV = . ]; then
#    BDEV=/dev/sdb3
    BDEV=/dev/nd0
fi

export FILESIZE=4000
export NUMFILES=4000

waitforcard() {
    umount /mnt
    echo Waiting for card:
    while ! mount $BDEV $MOUNTOPTS /mnt 2> /dev/null; do
	echo -n .
	sleep 1
    done
#   hdparm -W0 $BDEV
    echo
}

mkdir delme.fstest
cd delme.fstest

waitforcard
rm tmp.* final.* /mnt/tmp.* /mnt/final.*

while true; do
    ../fstest.work
    echo
    waitforcard
    echo Testing: fsck....
    umount /mnt
    fsck -fy $BDEV
    echo Testing....
    waitforcard
    for A in final.*; do
	echo -n $A " "
	cmp $A /mnt/$A || exit
    done
    echo
done

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fstest.work"

#!/bin/bash
#
# Copyright 2008 Pavel Machek <pavel@suse.cz>, GPLv2
#

echo "Writing test files: "
for A in `seq $NUMFILES`; do
    echo -n $A " "
    rm final.$A
    cat /dev/urandom | head -c $FILESIZE > tmp.$A
    dd conv=fsync if=tmp.$A of=/mnt/final.$A 2> /dev/zero || exit
#    cat /mnt/final.$A > /dev/null || exit
# sync should not be needed, as dd asks for fsync
#    sync
    mv tmp.$A final.$A
done

--qMm9M+Fa2AknHoGS--
