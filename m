From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
 with 2.6.32-rc1 and upwards]
Date: Mon, 02 Nov 2009 17:02:05 -0600
Message-ID: <4AEF64ED.1040703@redhat.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com> <20091101054542.GP18464@mit.edu> <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com> <42D1C316-13BF-401C-BB2F-A3DF62996A54@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbZKBXCN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 18:02:13 -0500
In-Reply-To: <42D1C316-13BF-401C-BB2F-A3DF62996A54@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2009-11-02, at 14:59, Greg Freemyer wrote:
>> One example is a hardware raid array that creates readonly snapshots
>> or clones.  (Lots of those exist in the real world).
>>
>> So the typical backup procedure is:
>>
>> ====
>> Queisce application (databases, etc. have utils to do this.)
>>
>> Queisce filesystem (xfs_freeze -f can be done from userspace. is there
>> a ext4 util?)
>>
>> issue raid array command to create snapshot.
>>
>> release filesystem (xfs_freeze -u)
>>
>> release the app (util provided by app).
>>
>> Mount the snapshot readonly (true readonly with zero writes to the
>> block device).
>>
>> Backup the readonly snapshot (to tape, etc.).
> 
> I thought Takashi Sato was working on allowing a filesystem freeze
> ioctl from userspace?  This would hook into the filesystem-specific
> freeze code so that when the ioctl() returns the on-disk filesystem
> is fully consistent and does not even require journal replay.

That's in and done; most recent xfsprogs' xfs_freeze utility will even 
freeze non-xfs filesystems now :)  Otherwise a wrapper utility around 
the ioctl would be trivial to write.

>> I believe XFS had 2 issues related to this process when first
>> implemented in linux.
>>
>> 1) It required the UUID to be unique.  Obviously in the above scenario
>> it is not, so "mount -o nouuid" was added for xfs.
>>
>> 2) Journal replay was originally aways attempted in the above process,
>> so the "mount -o norecovery" option was added to force a true readonly
>> mount.

these days a frozen xfs fs should be consistent & not need replay.

-Eric

>> ext4 may already support mounting of readonly clones, but if not it
>> needs to before it will qualify as a data center ready filesystem.

