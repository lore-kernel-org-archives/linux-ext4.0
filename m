From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: Shred mount option for ext4?
Date: Wed, 1 Nov 2006 11:52:42 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0611011142120.13266@compserv1>
References: <Pine.GSO.4.53.0610311444550.4220@compserv1>
 <20061101161700.GA5212@schatzie.adilger.int> <4548CD94.2030406@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:61170 "EHLO sbcs.cs.sunysb.edu")
	by vger.kernel.org with ESMTP id S2992671AbWKAQxA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 11:53:00 -0500
To: Ric Wheeler <ric@emc.com>
In-Reply-To: <4548CD94.2030406@emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> >>1. One of the patches performs N overwrites with configurable patterns
> >>(can comply with NIST and NISPOM standards).  Because of the transaction
> >>compaction we had to separately add overwriting as separate transactions.
> >>Fortunately, the whole procedure is still atomic due to the orphan list.
> >>The problem that we have right now is per-file syncing of dirty data
> >>buffers between overwrites.  We sync the whole device at the moment.
> >
> >Did anyone discuss doing this with crypto instead of actually overwriting
> >the whole file?  It would be pretty easy to store a per-file crypto key
> >in each inode as an EA, then to "delete" the file all that would be
> >needed would be to erase the key in a secure matter (which is a great
> >deal easier because inodes don't move around on disk).

Encryption is another possible secure deletion solution.  Usually it is
used by systems that already encrypt the data anyways.  In that case the
key management and run-time overhead costs are already paid.

> >The drawback is there is a runtime overhead to encrypt/decrypt the file

The difference is that in case of encryption there are overheads for read
and write operations whereas in case of overwriting there are overheads
only for infrequent unlink/truncate operations.

> I think that having the data encrypted on disk is a generically useful
> feature, but in this case it might not count for much since the key is
> stored right next to the data in that EA...

Agreed.  Key management is a big issue in any encryption system.  In this
particular solution the key management is simple but there is also no
real protection of the live data.

Nikolai.
