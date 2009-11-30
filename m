From: Andreas Dilger <adilger@sun.com>
Subject: Re: Please reserve INCOMPAT flags
Date: Mon, 30 Nov 2009 12:15:11 -0700
Message-ID: <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
References: <20090906092546.GU4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60950 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZK3TPN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2009 14:15:13 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAUJFHVL000541
	for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2009 11:15:17 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTX00F00S48QC00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 30 Nov 2009 11:15:17 -0800 (PST)
In-reply-to: <20090906092546.GU4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-09-06, at 03:25, Andreas Dilger wrote:
> in addition to the data-in-dirent INCOMPAT flag Rahul sent the patches
> for last week, I would like to ensure that we also have the INCOMPAT
> flag for large EA-in-inode flag reserved.  This patch is going into
> testing at one of our large customers, and I want to make sure that
> we don't accidentally get a conflicting INCOMPAT flag assignment.
>
> #define EXT4_FEATURE_INCOMPAT_EA_INODE	0x0400
> #define EXT4_FEATURE_INCOMPAT_DIRDATA   0x1000
>
> #define EXT4_EA_INODE_FL	0x00200000 /* Inode uses large EA */


Hi Ted,
I noticed Aneesh proposing to use the 0x0400 INCOMPAT flag for the  
NFSv4 ACL support, but this conflicts with the large EA feature we had  
previously discussed.  We now have a couple of customers using the  
large EA feature at this point, and I wouldn't want to break their  
filesystem as a result of an avoidable conflict.

I'll attach patches for this, which will hopefully make it easier, and  
the patch tracking tool will keep this visible.

Aneesh, maybe you can use 0x0800 for the INCOMPAT_RICHACL?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

