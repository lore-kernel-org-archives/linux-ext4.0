From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 19:48:09 -0400
Message-ID: <4A947839.4010601@redhat.com>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090825233701.GH4300@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


> ---
> There are storage devices that high highly undesirable properties
> when they are disconnected or suffer power failures while writes are
> in progress; such devices include flash devices and MD RAID 4/5/6
> arrays.  These devices have the property of potentially
> corrupting blocks being written at the time of the power failure, and
> worse yet, amplifying the region where blocks are corrupted such that
> additional sectors are also damaged during the power failure.

I would strike the entire mention of MD devices since it is your assertion, not 
a proven fact. You will cause more data loss from common events (single sector 
errors, complete drive failure) by steering people away from more reliable 
storage configurations because of a really rare edge case (power failure during 
split write to two raid members while doing a RAID rebuild).

>
> Users who use such storage devices are well advised take
> countermeasures, such as the use of Uninterruptible Power Supplies,
> and making sure the flash device is not hot-unplugged while the device
> is being used.  Regular backups when using these devices is also a
> Very Good Idea.

All users who care about data integrity - including those who do not use MD5 but 
just regular single S-ATA disks - will get better reliability from a UPS.


>
> Otherwise, file systems placed on these devices can suffer silent data
> and file system corruption.  An forced use of fsck may detect metadata
> corruption resulting in file system corruption, but will not suffice
> to detect data corruption.
>

This is very misleading. All storage "can" have silent data loss, you are making 
a statement without specifics about frequency.

FSCK can repair the file system metadata, but will not detect any data loss or 
corruption in the data blocks allocated to user files. To detect data loss 
properly, you need to checksum (or digitally sign) all objects stored in a file 
system and verify them on a regular basis.

Also helps to keep a separate list of those objects on another device so that 
when the metadata does take a hit, you can enumerate your objects and verify 
that you have not lost anything.

ric


ric


