From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 12:48:04 -0400
Message-ID: <20120314164804.GA28042@thunk.org>
References: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
 <20120313213304.GB11969@thunk.org>
 <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com>
 <20120314025108.GF15379@thunk.org>
 <4F60A881.3070607@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47127 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2CNQsK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Mar 2012 12:48:10 -0400
Content-Disposition: inline
In-Reply-To: <4F60A881.3070607@zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 14, 2012 at 10:17:37AM -0400, Zach Brown wrote:
> 
> >We could do this if we have two b-trees, one indexed by filename and
> >one indexed by inode number, which is what JFS (and I believe btrfs)
> >does.
> 
> Typically the inode number of the destination inode isn't used to index
> entries for a readdir tree because of (wait for it) hard links.  You end
> up right back where you started with multiple entries per key.

Well, if you are using 32-bit (or even 48-bit) inode numbers and a
64-bit telldir cookie, it's possible to make the right thing happen.
But yes, if you are using 32-bit inode numbers and a 32-bit telldir
cookie, dealing with what happens when you have multiple hard links to
the same inode in the same directory gets tricky.

> A painful solution is to have the key in the readdir tree allocated by
> the tree itself -- count key populations in subtrees per child pointer
> and use that to find free keys.

One thing that might work is to have a 16-bit extra field in the
directory entry that gives an signed offset to the inode number so
that such that inode+offset is a unique value within the btree sorted
by inode+offset number.  Since this tree is only used for returning
entries in an optimal (or as close to optimal as can be arranged)
order, we could get away with that.

				- Ted
