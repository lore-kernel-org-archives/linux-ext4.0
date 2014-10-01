From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Wed, 01 Oct 2014 08:44:00 +0200
Message-ID: <542BA2B0.4040604@bitsync.net>
References: <542AEED4.5050303@bitsync.net> <20140930183012.GA9942@birch.djwong.org> <542AF9B8.2090800@bitsync.net> <20140930195408.GD17142@thunk.org> <542B1220.8020208@bitsync.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:34571 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJAGoD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 02:44:03 -0400
In-Reply-To: <542B1220.8020208@bitsync.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30.09.2014 22:27, Zlatko Calusic wrote:
>
> Unless you have other ideas, I will run badblocks. Although, as ext4 fs
> is on /dev/md2, I think I should run it on /dev/md2 only? Do you really
> mean to run it on /dev/sda2, /dev/sdb2 - underlying devices? I'm not
> sure how MD would cope with it.
>
> But, I'm pretty sure that it will come out clean. The md check I did
> last night would surely detected bad blocks if there were any. Or not?

So, I ran badblocks on both underlying devices, and both came up clean, 
as I suspected would happen. Then I ran debugfs -w /dev/md2 and unlinked 
7 inodes that were problematic. Afterwards e2fsck found those inodes and 
connected them to lost+found. Second e2fsck run finished clean. And at 
this time I see no errors on the fs.

This is definitely the case where e2fsck can't see or repair fs errors 
that are real.

Regards,
-- 
Zlatko

