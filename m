From: Andreas Dilger <adilger@sun.com>
Subject: Re: Please reserve INCOMPAT flags
Date: Sun, 24 Jan 2010 23:18:47 -0700
Message-ID: <E1520682-CD9F-445E-AF33-D5FCDABA1FF8@sun.com>
References: <20090906092546.GU4197@webber.adilger.int>
 <20100124194839.GB4372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55860 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab0AYGSw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 01:18:52 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0P6Imsi014014
	for <linux-ext4@vger.kernel.org>; Sun, 24 Jan 2010 22:18:51 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWS00E00HDAPE00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sun,
 24 Jan 2010 22:18:48 -0800 (PST)
In-reply-to: <20100124194839.GB4372@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-24, at 12:48, tytso@mit.edu wrote:
> On Sun, Sep 06, 2009 at 11:25:46AM +0200, Andreas Dilger wrote:
>> in addition to the data-in-dirent INCOMPAT flag Rahul sent the  
>> patches
>> for last week, I would like to ensure that we also have the INCOMPAT
>> flag for large EA-in-inode flag reserved.  This patch is going into
>> testing at one of our large customers, and I want to make sure that
>> we don't accidentally get a conflicting INCOMPAT flag assignment.
>>
>> #define EXT4_FEATURE_INCOMPAT_EA_INODE	0x0400
>> #define EXT4_FEATURE_INCOMPAT_DIRDATA   0x1000
>>
>> #define EXT4_EA_INODE_FL	0x00200000 /* Inode used for large EA */
>
> Reserving... but stupid question, do you know if anyone is currently
> using the inode flag 0x00100000?  I want to make sure that's properly
> documented and reserved.


It doesn't seem that ext2/3/4 are using the 0x00100000 value itself,  
but it seems the VFS is using this value for FS_DIRECTIO_FL.  Should  
we reserve this in the ext4 flags also, to avoid collisions?  I'm not  
sure what that flag is for, possibly to force all IO to the file to be  
uncached?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

