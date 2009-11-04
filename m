From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
 with 2.6.32-rc1 and upwards]
Date: Wed, 04 Nov 2009 10:20:29 -0600
Message-ID: <4AF1A9CD.8010704@redhat.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com> <20091101054542.GP18464@mit.edu> <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com> <42D1C316-13BF-401C-BB2F-A3DF62996A54@sun.com> <4AEF64ED.1040703@redhat.com> <9EA6C408-DC45-457F-B7FA-93F08A769E78@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbZKDQUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 11:20:32 -0500
In-Reply-To: <9EA6C408-DC45-457F-B7FA-93F08A769E78@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2009-11-02, at 16:02, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> I thought Takashi Sato was working on allowing a filesystem freeze
>>> ioctl from userspace?  This would hook into the filesystem-specific
>>> freeze code so that when the ioctl() returns the on-disk filesystem
>>> is fully consistent and does not even require journal replay.
>> That's in and done; most recent xfsprogs' xfs_freeze utility will  
>> even freeze non-xfs filesystems now :)  Otherwise a wrapper utility  
>> around the ioctl would be trivial to write.
> 
> 
> It probably makes sense to add a tune2fs option to freeze and unfreeze  
> the
> filesystem?  That would allow ext* users to have an available/documented
> command even if they don't have xfsprogs installed.

I'd rather see a simple tool in util-linux-ng since it's no longer
fs-specific, rather than putting something in each filesystem's toolbox.

However, the command is a little dangerous; you can lock up the machine
by freezing the wrong filesystem at the wrong time... IO can stack up
(nothing stops mmap writes yet, today) and the unfreeze may require
memory, which may require writeback to ... the frozen filesystem....

In this case there is a fair bit of rope to hang oneself ;)

-Eric
