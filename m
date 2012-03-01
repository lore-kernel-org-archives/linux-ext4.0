From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 13:42:48 -0500
Message-ID: <20120301184248.GC32588@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
 <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
 <20120229144244.GF5054@shiny>
 <CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
 <CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
 <CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
 <CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
 <20120301141823.GV5054@shiny>
 <CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 01, 2012 at 03:43:41PM +0100, Jacek Luczak wrote:
> 
> Yep, ext4 is close to my wife's closet.
> 

Were all of the file systems freshly laid down, or was this an aged
ext4 file system?

Also you should beware that if you have a workload which is heavy
parallel I/O, with lots of random, read/write accesses to small files,
a benchmark using tar might not be representative of what you will see
in production --- different file systems have different strengths and
weaknesses --- and the fact that ext3/ext4's readdir() returns inodes
in a non-optimal order for stat(2) or unlink(2) or file copy in the
cold cache case may not matter as much as you think in a build server.
(i.e., the directories that do need to be searched will probably be
serviced out of the dentry cache, etc.)

Regards,

						- Ted
