From: Graham Murray <graham@gmurray.org.uk>
Subject: Re: Block allocation failed
Date: Wed, 19 Aug 2009 15:46:01 +0100
Message-ID: <87zl9vhnfa.fsf@newton.gmurray.org.uk>
References: <87iqgk8jal.fsf@newton.gmurray.org.uk>
	<20090819135006.GB17488@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newton.gmurray.org.uk ([81.2.114.237]:33739 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZHSOqB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 10:46:01 -0400
Received: from newton.gmurray.org.uk (localhost [127.0.0.1])
	by newton.gmurray.org.uk (8.14.3/8.14.3) with ESMTP id n7JEk1V2008668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 15:46:01 +0100
In-Reply-To: <20090819135006.GB17488@mit.edu> (Theodore Tso's message of "Wed,
	19 Aug 2009 09:50:06 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Wed, Aug 19, 2009 at 06:27:46AM +0100, Graham Murray wrote:
>> Shortly after rebooting following an untidy shutdown due to an unrelated
>> (to ext4 or the filesystem) Oops. Unmounting the partition and running
>> e2fsck (version 1.41.8) just replayed the journal and stated the
>> filesystem was clean but I did not believe it so ran 'e2fsck -f
>> /dev/sdb3' and that showed several errors which I allowed it to correct.
>
> What sort of errors did it find?
>
Sorry, but I do not remember all the errors, it was late at night. The
first were some sort of block error with lots of block numbers in ()
which I responded 'y' to fix. Then there were a number of files with
multiply-claimed blocks which I responded 'y' to clone. There were files
containing unallocated or deleted inodes. A number of files were
recovered to Lost+Found. A number of inode reference counts were
wrong. There may have been other errors, but I do not remember what they
were. 

>> Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 35: 3499 blocks in bitmap, 3243 in gd
>> Aug 18 23:50:07 newton Aborting journal on device sdb3:8.
>
> Was this right after you mounted the filesystem, or did some time
> take place before these errors started showing up?

It was about 90s after the message showing the filesystem mounted

Aug 18 23:48:33 newton EXT4-fs (sdb3): barriers enabled
Aug 18 23:48:33 newton kjournald2 starting: pid 3855, dev sdb3:8, commit
interval 10 seconds
Aug 18 23:48:33 newton EXT4-fs (sdb3): internal journal on sdb3:8
Aug 18 23:48:33 newton EXT4-fs (sdb3): delayed allocation enabled
Aug 18 23:48:33 newton EXT4-fs: file extents enabled
Aug 18 23:48:33 newton EXT4-fs: mballoc enabled
Aug 18 23:48:33 newton EXT4-fs (sdb3): mounted filesystem with ordered
data mode

