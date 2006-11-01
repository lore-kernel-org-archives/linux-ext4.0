From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Shred mount option for ext4?
Date: Thu, 2 Nov 2006 00:17:00 +0800
Message-ID: <20061101161700.GA5212@schatzie.adilger.int>
References: <Pine.GSO.4.53.0610311444550.4220@compserv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:29322 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1946923AbWKAQTS
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Nov 2006 11:19:18 -0500
To: Nikolai Joukov <kolya@cs.sunysb.edu>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0610311444550.4220@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 31, 2006  15:14 -0500, Nikolai Joukov wrote:
> 1. One of the patches performs N overwrites with configurable patterns
> (can comply with NIST and NISPOM standards).  Because of the transaction
> compaction we had to separately add overwriting as separate transactions.
> Fortunately, the whole procedure is still atomic due to the orphan list.
> The problem that we have right now is per-file syncing of dirty data
> buffers between overwrites.  We sync the whole device at the moment.

Did anyone discuss doing this with crypto instead of actually overwriting
the whole file?  It would be pretty easy to store a per-file crypto key
in each inode as an EA, then to "delete" the file all that would be
needed would be to erase the key in a secure matter (which is a great
deal easier because inodes don't move around on disk).

The drawback is there is a runtime overhead to encrypt/decrypt the file
data, but honestly, if people care about secure deletion don't they also
care about security of the undeleted data also?  By having an (unknown
to the user) per-file crypto key then if the file is deleted the user
can also plausibly deny the ability to recover the file data even if
they are forced to surrender their key.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
