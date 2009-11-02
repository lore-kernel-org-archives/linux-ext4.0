From: Andreas Dilger <adilger@sun.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
 with 2.6.32-rc1 and upwards]
Date: Mon, 02 Nov 2009 15:53:38 -0700
Message-ID: <42D1C316-13BF-401C-BB2F-A3DF62996A54@sun.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
 <20091101054542.GP18464@mit.edu>
 <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ted Augustine <taugustine@techpathways.com>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60222 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbZKBWxi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 17:53:38 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA2MredG000759
	for <linux-ext4@vger.kernel.org>; Mon, 2 Nov 2009 14:53:43 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSI00E007H29T00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 02 Nov 2009 14:53:40 -0800 (PST)
In-reply-to: <87f94c370911021359x19f57427o19e6f7bfcfadae21@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-02, at 14:59, Greg Freemyer wrote:
> One example is a hardware raid array that creates readonly snapshots
> or clones.  (Lots of those exist in the real world).
>
> So the typical backup procedure is:
>
> ====
> Queisce application (databases, etc. have utils to do this.)
>
> Queisce filesystem (xfs_freeze -f can be done from userspace. is there
> a ext4 util?)
>
> issue raid array command to create snapshot.
>
> release filesystem (xfs_freeze -u)
>
> release the app (util provided by app).
>
> Mount the snapshot readonly (true readonly with zero writes to the
> block device).
>
> Backup the readonly snapshot (to tape, etc.).

I thought Takashi Sato was working on allowing a filesystem freeze
ioctl from userspace?  This would hook into the filesystem-specific
freeze code so that when the ioctl() returns the on-disk filesystem
is fully consistent and does not even require journal replay.

> I believe XFS had 2 issues related to this process when first
> implemented in linux.
>
> 1) It required the UUID to be unique.  Obviously in the above scenario
> it is not, so "mount -o nouuid" was added for xfs.
>
> 2) Journal replay was originally aways attempted in the above process,
> so the "mount -o norecovery" option was added to force a true readonly
> mount.
>
> ext4 may already support mounting of readonly clones, but if not it
> needs to before it will qualify as a data center ready filesystem.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

