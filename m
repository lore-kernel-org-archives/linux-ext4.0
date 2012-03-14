From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Tue, 13 Mar 2012 22:51:08 -0400
Message-ID: <20120314025108.GF15379@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
 <20120313213304.GB11969@thunk.org>
 <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 14, 2012 at 10:48:17AM +0800, Yongqiang Yang wrote:
> What if we use inode number as the hash value?  Does it work?

The whole point of using the tree structure is to accelerate filename
-> inode number lookups.  So the namei lookup doesn't have the inode
number; the whole point is to use the filename to lookup the inode
number.  So we can't use the inode number as the hash value since
that's what we are trying to find out.

We could do this if we have two b-trees, one indexed by filename and
one indexed by inode number, which is what JFS (and I believe btrfs)
does.

						- Ted
