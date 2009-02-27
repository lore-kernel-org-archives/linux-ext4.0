From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Thu, 26 Feb 2009 17:15:19 -0700
Message-ID: <20090227001519.GO3199@webber.adilger.int>
References: <20090218154310.GH3600@mini-me.lan> <20090226182156.GL7227@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48870 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbZB0APj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Feb 2009 19:15:39 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1R0FYPD003532
	for <linux-ext4@vger.kernel.org>; Thu, 26 Feb 2009 16:15:34 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFP00L0075AT000@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 26 Feb 2009 16:15:34 -0800 (PST)
In-reply-to: <20090226182156.GL7227@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 26, 2009  13:21 -0500, Theodore Ts'o wrote:
> So any improvements in mkdirs_mark would require special-case hacks
> such as treating a zero-length directory inode as a synthetic empty
> inode, and not actually trying to allocate the directory block until
> the first time a file is created in the directory.  But that would be
> a file system format change that would probably only really be useful
> for better benchmark results --- how common are file systems with
> hundreds of thousands of empty directories, after all?

Actually, I often reference some online statistics for HPC storage:
http://www.pdsi-scidac.org/cgi-bin/fsstats-list.cgi

and while one would think in HPC filesystems there are lots of huge
directories, the below stats show that a huge majority of DIRECTORIES
are only containing a few entries.  That said, a large percentage of
the FILES are in larger directories, but that doesn't change the fact
that there are a large number of directories with very few entries.

Stats from the filesystem (incorrectly marked ext3, but really Lustre):
http://www.pdsi-scidac.org/fsstats/approved/PNNL-Oct102007-233TB-ext3-EvanFelix_nwfs.out

directory size:
count=888082 average=14.936094
min=0 max=57114
entries:  dirs  dir pct  cumulative entries ents pct cum. ents
[ 0- 1]: 127934 (14.41%) (14.41%)     86753 ( 0.65%) ( 0.65%)
[ 2- 3]: 126204 (14.21%) (28.62%)    305501 ( 2.30%) ( 2.96%)
[ 4- 7]: 268058 (30.18%) (58.80%)   1314419 ( 9.91%) (12.87%)
[ 8-15]: 228065 (25.68%) (84.48%)   2449552 (18.47%) (31.33%)
[16-31]:  88365 ( 9.95%) (94.43%)   1965719 (14.82%) (46.15%)
[32-63]:  30436 ( 3.43%) (97.86%)   1355962 (10.22%) (56.38%)

filename length:
count=13264476 average=21.981972
min=1 max=232
chars:   files   file pct cumulative bytes    byte pct cum. bytes
[ 0- 7]: 1557016 (11.74%) (11.74%)    7772274 ( 2.67%) ( 2.67%)
[ 8-15]: 4826194 (36.38%) (48.12%)   53282606 (18.27%) (20.94%)
[16-23]: 2598854 (19.59%) (67.72%)   50042818 (17.16%) (38.10%)
[24-31]: 1346382 (10.15%) (77.87%)   36152231 (12.40%) (50.50%)
[32-39]:  572299 ( 4.31%) (82.18%)   20691279 ( 7.10%) (57.60%)
[40-47]:  873408 ( 6.58%) (88.76%)   37941162 (13.01%) (70.61%)
[48-55]:  814905 ( 6.14%) (94.91%)   41733619 (14.31%) (84.92%)

Shows that we could quite easily store most (57%) of average named
files (24 chars or less) in average sized directories (15 files or
less) in 480-byte directories (including 8 bytes of dirent overhead
per name).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

