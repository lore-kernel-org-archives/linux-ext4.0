From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: lifetime_write_kbytes isn't preserved during unclean shutdown
Date: Wed, 30 Jun 2010 15:54:02 -0600
Message-ID: <5111D4F0-8822-451F-BE81-15E0E9AE9882@dilger.ca>
References: <4C2782A7.7040301@gmail.com> <20100628195739.GB6094@thunk.org> <519E1F03-CD95-41F4-B2EE-93983A4CC08A@dilger.ca> <20100630133108.GD1333@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Nebojsa Trpkovic <trx.lists@gmail.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:17163 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab0F3VyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 17:54:03 -0400
In-Reply-To: <20100630133108.GD1333@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-30, at 07:31, tytso@mit.edu wrote:
> On Tue, Jun 29, 2010 at 11:46:57PM -0600, Andreas Dilger wrote:
>> Could we also update the superblock blocks/inodes free counters at
>> that time as well?
> 
> Remind me again why you wanted it.  You had some use case where you
> wanted to be able to read the file system's block device directly and
> have vaguely correct free inode/block numbers in the superblock?

That is so that running "e2fsck -fn" on a quiet filesystem does not complain.  I always find this annoying that it fails with the inode and blocks counters being incorrect, even though the filesystem has been idle for hours.

It would also be possible to fix e2fsck not to complain about this for a read-only e2fsck run (as it already does with "e2fsck -fy").  However, the last I recall from that approach was that you didn't want it to return 0 if there was anything that actually needed fixing.

>> One way to do this would be to have a JBD transaction pre-commit
>> callback, and if the superblock has not been written in N seconds
>> then it can be added as part of that transaction (if it will fit).
>> If it is already in the transaction it can be updated via the
>> existing bh callbacks that OCFS2 is using.
> 
> That seems reasonable way of doing things.  I think N seconds should
> be in the region of every 5-60 minutes, though.  And yes, absolutely
> we wouldn't want to spin up the disk if there was no other activity.

I didn't say how big "N" would be :-).

It may be easier to have the _first_ handle started after N seconds where the superblock was not updated add in the superblock to the transaction, and then the superblock buffer gets updated just before transaction close time with whatever we want to stick in there.

Cheers, Andreas





