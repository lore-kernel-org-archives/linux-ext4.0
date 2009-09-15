From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on readdir implementation
Date: Tue, 15 Sep 2009 08:41:41 -0600
Message-ID: <20090915144141.GS2537@webber.adilger.int>
References: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Zhang Huan <zhhuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39070 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbZIOOlj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 10:41:39 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8FEfgD8011433
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 07:41:42 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ000200O5IOG00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 15 Sep 2009 07:41:42 -0700 (PDT)
In-reply-to: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 15, 2009  17:57 +0800, Zhang Huan wrote:
> I'm reading EXT4 codes and has some questions about readdir
> implementation.
> 
> Why traverse the directory in hash order? This brings lots of code to
> build and traverse a red-black tree. Why not just plainly traverse the
> directory's blocks?

Because htree does not maintain constant ordering of directory entries.
Consider a readdir running at the same time as files are being added:

readdir proc		create proc
read block 0
read block 1
			create new file
			    hash of filename puts entry into block 0
			    block 0 is full, split it
				add new block 3
				copy 1/2 of block 0 entries to block 3
				add new filename to block 0
read block 2
read block 3

When the readdir returns block 3, 1/2 of the entries in that block
are the same as were returned with the original block 0 read.  This
is a violation of POSIX readdir() semantics that require each existing
entry only be returned a single time (it doesn't matter if the new
filename is returned or not).
			
> Since the red-black tree is built every time a NFS readdir request comes
> in, in case of hash collision, the nfs client may receive duplicate dir
> entries if the buffer is not large enough to return all entries with the
> same hash value in once.

This is because NFSv2 only has a 32-bit cookie value, and if there is a
whole buffer full of values with the same 32-bit hash there isn't anything
that can be done about it except drop those extra duplicates (a very rare
case).  It would have a much more serious problem if there was a directory
larger than 2^32 bytes in size, which would result in all entries beyond
2GB being lost.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

