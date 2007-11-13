From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Wed, 14 Nov 2007 00:43:20 +0800
Message-ID: <4739D428.2010203@suse.de>
References: <4739B0C0.3060907@suse.de> <4739B02A.2000209@gmail.com> <4739D067.5080907@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz.tomas@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:50559 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXKMQfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 11:35:07 -0500
In-Reply-To: <4739D067.5080907@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Coly Li wrote:
> Thanks for the feedback :-)
> 
> Alex Tomas wrote:
>> hmm. so you trade 265% degradation of creation for 40% improvement of
>> unlink?
>>
> 265% degradation is only for creating 50000 empty directories. This is not a common case.
> There are 13% improvement on create 15 files in each directories. Total time on creating these
> directories and files are 25m6s VS. 24m86s, indeed, dir inode reservation is a little faster.

Sorry a typo here, it's 25m6s VS. 24m7.86s.

> 
> Maybe most of the people will not create dozens of empty directories in their applications,
> therefore IMHO the 265% degradation is acceptable.
> 
> If user really need to create so many empty directories, they also can mount the file system without
> dir inode reservation to get better performance.
> 
>> thanks, Alex
>>
>> Coly Li wrote:
>>>             normal ext4            ext4 with dir inode reservation
>>>     mount options:    -o data=writeback        -o
>>> data=writeback,dir_ireserve=low
>>>     Create dirs:    real    0m49.101s        real    2m59.703s
>>>     Create files:    real    24m17.962s        real    21m8.161s
>>>     Unlink all:    real    24m43.788s        real    17m29.862s
>>> Creating dirs with dir inode reservation is slower than normal ext4 as
>>> predicted, because allocating
>>> directory inodes in non-linear order will cause extra hard disk
>>> seeking and block I/O. Creating
>>> files with dir inode reservation is 13% faster than normal ext4.
>>> Unlink all the directories and
>>> files is 29.2% faster as expected.
>>> When number of directories is increased, the performance improvement
>>> will be more considerable. More
>>> benchmark result will be posted here if necessary, because I need more
>>> time to run more test cases.
> 

-- 
Coly Li
SuSE PRC Labs
