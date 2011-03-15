From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 07:38:29 -0400
Message-ID: <7A57B033-E270-4DE1-86B9-F06B4BF9DA20@mit.edu>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <8239molspy.fsf@mid.bfk.de> <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu> <4D7F4C22.9060801@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Weimer <fweimer@bfk.de>, Eric Sandeen <sandeen@redhat.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:56831 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757297Ab1COLif convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 07:38:35 -0400
In-Reply-To: <4D7F4C22.9060801@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Mar 15, 2011, at 7:23 AM, Ric Wheeler wrote:
> 
> I have tested both sorting techniques with very large directories.
> 
> Most of the gain came with the simple sorting by inode number, but of course this relies on the file system allocation policy having a correlation between the inode numbers and layout (i.e., higher inode number correspond to higher block numbers).

That's not just a matter of file system allocation policy, but how fragmented the free space is as far 
as inode numbers and block numbers might be.  (Especially in the block group where /var/lib/dpkg/info
lives, on Debian systems.  That's because that directory is (ab)used as a database, with lots of files
added and deleted, so over time it's pretty much inevitable that any link between directory order,
inode numbers, and block numbers, would become weaker and weaker over time.  Fortunately the
overall database tends to fit into the dentry, inode, and page caches after the first dpkg operation...)

> Note that you can get the inode number used in this sorting without doing any stat calls.

Sure.  And in the worst case, you would sort based on the inode number so that when you call
open/FI[BE]MAP, the disk isn't seeking all over the place when you read in the inode structure...
Then you need to sort by block numbers, and assuming that you have enough memory that
all of /var/lib/dpkg/info/* fits in the inode cache, you will minimize seeking while you read the
blocks into memory.

-- Ted

