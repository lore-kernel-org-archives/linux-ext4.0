From: Andreas Dilger <adilger@sun.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
 with 2.6.32-rc1 and upwards]
Date: Wed, 04 Nov 2009 01:05:28 -0700
Message-ID: <9EA6C408-DC45-457F-B7FA-93F08A769E78@sun.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
 <20091101054542.GP18464@mit.edu>
 <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
 <42D1C316-13BF-401C-BB2F-A3DF62996A54@sun.com> <4AEF64ED.1040703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35810 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZKDIF0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 03:05:26 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA485UDZ028951
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 00:05:31 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSK00100RNNTV00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 04 Nov 2009 00:05:30 -0800 (PST)
In-reply-to: <4AEF64ED.1040703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-02, at 16:02, Eric Sandeen wrote:
> Andreas Dilger wrote:
>> I thought Takashi Sato was working on allowing a filesystem freeze
>> ioctl from userspace?  This would hook into the filesystem-specific
>> freeze code so that when the ioctl() returns the on-disk filesystem
>> is fully consistent and does not even require journal replay.
>
> That's in and done; most recent xfsprogs' xfs_freeze utility will  
> even freeze non-xfs filesystems now :)  Otherwise a wrapper utility  
> around the ioctl would be trivial to write.


It probably makes sense to add a tune2fs option to freeze and unfreeze  
the
filesystem?  That would allow ext* users to have an available/documented
command even if they don't have xfsprogs installed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

