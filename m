From: david@lang.hm
Subject: Re: [patch] document flash/RAID dangers
Date: Tue, 25 Aug 2009 16:56:40 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz>
 <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
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

On Wed, 26 Aug 2009, Pavel Machek wrote:

> There are storage devices that high highly undesirable properties
> when they are disconnected or suffer power failures while writes are
> in progress; such devices include flash devices and MD RAID 4/5/6
> arrays.

change this to say 'degraded MD RAID 4/5/6 arrays'

also find out if DM RAID 4/5/6 arrays suffer the same problem (I strongly 
suspect that they do)

then you need to add a note that if the array becomes degraded before a 
scrub cycle happens previously hidden damage (that would have been 
repaired by the scrub) can surface.

> These devices have the property of potentially corrupting blocks being 
> written at the time of the power failure,

this is true of all devices

> and worse yet, amplifying the region where blocks are corrupted such 
> that additional sectors are also damaged during the power failure.

re-word this something like

In addition to the standard risk of corrupting the blocks being written at 
the time of the power failure, additonal blocks (in the same flash 
eraseblock or raid stripe) may also be corrupted.

> Users who use such storage devices are well advised take
> countermeasures, such as the use of Uninterruptible Power Supplies,
> and making sure the flash device is not hot-unplugged while the device
> is being used.  Regular backups when using these devices is also a
> Very Good Idea.
>
> Otherwise, file systems placed on these devices can suffer silent data
> and file system corruption.  An forced use of fsck may detect metadata
> corruption resulting in file system corruption, but will not suffice
> to detect data corruption.

David Lang
