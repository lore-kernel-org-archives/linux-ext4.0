From: Andreas Dilger <adilger@sun.com>
Subject: Re: periodic fsck was Re: [patch] ext2/3: document conditions when
 reliable operation is possible
Date: Mon, 09 Nov 2009 08:58:49 -0700
Message-ID: <B18BA4E1-2D18-4E00-8678-5DE92EBA343D@sun.com>
References: <20090824230036.GK29763@elf.ucw.cz> <4A932B18.1020209@redhat.com>
 <20090825093414.GB15563@elf.ucw.cz> <4A94ACDF.30405@redhat.com>
 <20090826111751.GC26595@elf.ucw.cz>
 <alpine.DEB.2.00.0908260428310.30426@asgard.lang.hm>
 <20090826131028.GB1370@ucw.cz>
 <alpine.DEB.2.00.0908260642560.28411@asgard.lang.hm>
 <20090826180248.GB6997@mit.edu> <20091109085318.GE4818@elf.ucw.cz>
 <20091109140555.GG7592@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Pavel Machek <pavel@ucw.cz>, david@lang.hm,
	Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>, corbet@lwn.net,
	Jan Kara <jack@suse.cz>,
	Bryan Kadzban <bryan@kadzban.is-a-geek.net>,
	Karel Zak <kzak@redhat.com>,
	LVM Mailing List <linux-lvm@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <20091109140555.GG7592@mit.edu>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2009-11-09, at 07:05, Theodore Tso wrote:
> So these days, what I strongly recommend is that people use LVM
> snapshots, and schedule weekly checks during some low usage period
> (i.e., 3am on Saturdays), using something like the e2croncheck shell
> script.


There was another script written to do this that handled the e2fsck,  
reiserfsck
and xfs_check, detecting all volume groups automatically, along with  
e.g.
validating that the snapshot volume doesn't exist before starting the  
check
(which may indicate that the previous e2fsck is still running), and  
not running while on AC power.

The last version was in the thread "forced fsck (again?)" dated  
2008-01-28.
Would it be better to use that one?  In that thread we discussed not  
clobbering
the last checked time as e2croncheck does, so the admin can see how  
long it
was since the filesystem was last checked.

Maybe it makes more sense to get the lvcheck script included into util- 
linux-ng
or lvm2 packages, and have it added automatically to the cron.weekly  
directory?
Then the distros could disable the at-boot checking safely, while  
still being
able to detect corruption caused by cables/RAM/drives/software.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

