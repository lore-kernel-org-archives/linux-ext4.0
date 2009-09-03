From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Wed, 02 Sep 2009 23:21:03 -0600
Message-ID: <20090903052103.GM4197@webber.adilger.int>
References: <12386.1251948115@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34139 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZICFUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:20:52 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n835Kt7Q016101
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 22:20:55 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD00600QSP7M00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 22:20:55 -0700 (PDT)
In-reply-to: <12386.1251948115@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  23:21 -0400, Nick Dokos wrote:
> Replace all field accesses with calls to access functions.
> Most importantly, get rid of the mis-declared group descriptor
> pointer which caused the wrong fields to be updated.
> 
>  errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
>  {
>  	struct ext2_super_block *sb = fs->super;
> -	struct ext2_group_desc *bg = fs->group_desc;

Given the danger of ongoing direct access to fs->group_desc (including
potentially from external applications) I think the only safe way of
doing this is to have an opaque fs->group_desc structure that cannot
be dereferenced outside of the library.

As a potential compatibility measure, we might consider fs->group_desc
to be valid for 32-bit filesystems, and leave it NULL for 64-bit
filesystems and use a second (opaque) fs->group_desc64 pointer for
access to filesystems with INCOMPAT_64BIT set.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

