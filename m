From: david@lang.hm
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sat, 29 Aug 2009 09:35:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908290931260.6822@asgard.lang.hm>
References: <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com>
 <20090826111208.GA26595@elf.ucw.cz> <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm> <20090829094919.GF1634@ucw.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=qMm9M+Fa2AknHoGS
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090829094919.GF1634@ucw.cz>
Content-ID: <alpine.DEB.2.00.0908290931261.6822@asgard.lang.hm>
Content-Disposition: INLINE
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--qMm9M+Fa2AknHoGS
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.DEB.2.00.0908290931262.6822@asgard.lang.hm>
Content-Disposition: INLINE

On Sat, 29 Aug 2009, Pavel Machek wrote:

>> for flash drives the danger is very straightforward (although even then
>> you have to note that it depends heavily on the firmware of the device,
>> some will loose lots of data, some won't loose any)
>
> I have not seen one that works :-(.

so let's get broader testing (including testing the SSDs as well as the 
thumb drives)

>> you are generalizing that since you have lost data on flash drives, all
>> flash drives are dangerous.
>
> Do the flash manufacturers claim they do not cause collateral damage
> during powerfail? If not, they probably are dangerous.

I think that every single one of them will tell you to not unplug the 
drive while writing to it. in fact, I'll bet they all tell you to not 
unplug the drive without unmounting ('ejecting') it at the OS level.

> Anyway, you wanted a test, and one is attached. It normally takes like
> 4 unplugs to uncover problems.

Ok, help me understand this.

I copy these two files to a system, change them to point at the correct 
device, run them and unplug the drive while it's running.

when I plug the device back in, how do I tell if it lost something 
unexpected? since you are writing from urandom I have no idea what data 
_should_ be on the drive, so how can I detect that a data block has been 
corrupted?

David Lang
--qMm9M+Fa2AknHoGS
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-ID: <alpine.DEB.2.00.0908290931263.6822@asgard.lang.hm>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=fstest

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
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-ID: <alpine.DEB.2.00.0908290931264.6822@asgard.lang.hm>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=fstest.work

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
