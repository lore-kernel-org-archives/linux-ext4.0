From: Andreas Dilger <adilger@sun.com>
Subject: Re: Rare xfsqa test failure
Date: Tue, 18 Aug 2009 11:07:05 -0600
Message-ID: <20090818170705.GI5931@webber.adilger.int>
References: <E1MdNJu-0006uc-GX@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53149 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481AbZHRRHE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 13:07:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7IH74OW017380
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 10:07:04 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KOL00K000S6LO00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 18 Aug 2009 10:07:04 -0700 (PDT)
In-reply-to: <E1MdNJu-0006uc-GX@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2009  07:57 -0400, Theodore Ts'o wrote:
> As a heads up, I'm seeing a rare xfsqa test failure with the stable
> portion of the ext4 patch queue; it doesn't hit all the time, but when
> it does, i_size is corrupted:
> 
> Inode 22047, i_size is 922788, should be 942080.  Fix?
> 
> 922788/4096 is 225 plus a fraction, while 942080/4096 is 230.  The
> debugfs information is as follows:
> 
> debugfs:  stat <22047>
> Inode: 22047   Type: regular    Mode:  0666   Flags: 0x80000
> Generation: 3536075281    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 922788
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 1320
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x4a8a953b:546bc3d4 -- Tue Aug 18 07:49:15 2009
>  atime: 0x4a8a953b:29927210 -- Tue Aug 18 07:49:15 2009
>  mtime: 0x4a8a953b:546bc3d4 -- Tue Aug 18 07:49:15 2009
> crtime: 0x4a8a951c:5ac789dc -- Tue Aug 18 07:48:44 2009
> Size of extra inode fields: 28
> EXTENTS:
> (65-80): 60720-60735, (81-222 [uninit]): 1181574-1181715, (223-229): 1181716-118
> 1722
> debugfs:  
> 
> So it looks like there's a race which can cause ext4 to somehow miss an
> i_size update.

Are you sure it is a failure to update i_size, or is it possibly an
fallocate that extends the block count beyond i_size?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

