From: Andreas Dilger <adilger@sun.com>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Thu, 05 Feb 2009 23:29:02 -0700
Message-ID: <20090206062901.GM3209@webber.adilger.int>
References: <p06240517c5b14e12f7d1@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53661 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZBFG3T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Feb 2009 01:29:19 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n166TEuw001557
	for <linux-ext4@vger.kernel.org>; Thu, 5 Feb 2009 22:29:14 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KEM00J00SHGRU00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 05 Feb 2009 22:29:14 -0800 (PST)
In-reply-to: <p06240517c5b14e12f7d1@[10.1.5.33]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 06, 2009  04:06 +0100, J.D. Bakker wrote:
> On reboot the system refused to auto-fsck /dev/md0. A manual e2fsck -nv 
> /dev/md0 reported:
>
>   e2fsck 1.41.4 (27-Jan-2009)
>   ./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...

Not sure why it considers the initial group descriptors bad.

>   Group descriptor 0 checksum is invalid.  Fix? no
>   Group descriptor 1 checksum is invalid.  Fix? no
>   Group descriptor 2 checksum is invalid.  Fix? no
>   [...]
>   Group descriptor 29808 checksum is invalid.  Fix? no

Note that the checksums in the backup blocks are probably incorrect, so
this isn't itself a problem.

>   newraidfs contains a file system with errors, check forced.
>   Pass 1: Checking inodes, blocks, and sizes
>   Pass 2: Checking directory structure
>   Pass 3: Checking directory connectivity
>   Pass 4: Checking reference counts
>   Pass 5: Checking group summary information
>   Block bitmap differences:  [...]
>   Fix? no
>   Free blocks count wrong for group #0 (23513, counted=464).
>   Fix? no
>   Free blocks count wrong for group #1 (31743, counted=509).
>   Fix? no
>   [...]
>   Free inodes count wrong for group #7748 (8192, counted=940).
>   Fix? no
>   Directories count wrong for group #7748 (0, counted=1).
>   Fix? no
>   Free inodes count wrong for group #7749 (8192, counted=8059).
>   Fix? no
>   Free inodes count wrong (244195317, counted=237646747).
>   Fix? no

These also look like trivial errors, due to using the backup group
descriptors (which are not kept up-to-date.  It appears from this
e2fsck output that there isn't really anything wrong with the fs.

>   Error writing block 1 (Attempt to write block from filesystem resulted 
> in short write).  Ignore error? no
>   Error writing block 2 (Attempt to write block from filesystem resulted 
> in short write).  Ignore error? no
>   Error writing block 3 (Attempt to write block from filesystem resulted 
> in short write).  Ignore error? no

This is a serious problem.

> As I said, is there anything I can do to recover my data, or to make  
> sure this doesn't happen again?

I would say to run "e2fsck -fp /dev/XXX" and your data _should_ be
there.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

