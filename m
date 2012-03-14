From: Zach Brown <zab@zabbo.net>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 10:17:37 -0400
Message-ID: <4F60A881.3070607@zabbo.net>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com> <20120313195339.GA24124@thunk.org> <4F5FAC9C.9070607@gmail.com> <20120313213304.GB11969@thunk.org> <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com> <20120314025108.GF15379@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:54495 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab2CNORl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Mar 2012 10:17:41 -0400
In-Reply-To: <20120314025108.GF15379@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> We could do this if we have two b-trees, one indexed by filename and
> one indexed by inode number, which is what JFS (and I believe btrfs)
> does.

Typically the inode number of the destination inode isn't used to index
entries for a readdir tree because of (wait for it) hard links.  You end
up right back where you started with multiple entries per key.

A painful solution is to have the key in the readdir tree allocated by
the tree itself -- count key populations in subtrees per child pointer
and use that to find free keys.  You still have the problem of
correlating entry keys and the location of inodes, but at least now you
have a structure to navigate to try and do that.  You can also trivially
re-use freed keys and have densely packed readdir keys that won't break
32bit f_pos so quickly.

btrfs just punts and has an incrementing 64bit counter per directory
that determines a new entry's position in readdir.  Accompanied by the
obligatory "will be smarter some day" comment :).

- z
