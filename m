From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Add flag to files with blocks intentionally past EOF
Date: Wed, 20 Jan 2010 16:37:03 +0800
Message-ID: <62859653-8D41-4A7B-B95B-80A33F5A7EAD@sun.com>
References: <4B5627EF.3080804@redhat.com>
 <1263948377.3954.2.camel@mingming-laptop> <4B567F77.5030103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Mingming <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62655 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0ATIhK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 03:37:10 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0K8b8WM017647
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 00:37:08 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWJ00100E39XW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 20 Jan 2010 00:37:08 -0800 (PST)
In-reply-to: <4B567F77.5030103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-20, at 11:58, Eric Sandeen wrote:
> Mingming wrote:
>>
>> I am a little lost why doing vmtruncate here...
>
> Hm first off I assume vmtruncate will clear blocks past that size,
> but tonight I'm not seeing how it gets there.
>
> Anyway, it looks like any setting of the size, truncate up or down
> (or to current size) will clear any blocks past EOF.


Why not just call ext4_truncate(inode)?  Since these blocks are only  
fallocated, and pages couldn't (shouldn't?) be instantiated beyond  
i_size, we don't need to do anything at the mapping level, only at the  
inode level.

> Well here we are clearing the EOFBLOCKS flag so we'd want to clear any
> blocks past EOF.... but now, does vmtruncate do that?
>
> Ok, count me as confused too, but mostly jsut so far as how does
> vmtruncate clear the blocks beyond eof.  I guess I glossed over this  
> when reading it.


Has the new truncate API patchset gone into the kernel?  I recall  
there was some work to restructure the API and maybe you are a victim  
of understanding the old API?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

