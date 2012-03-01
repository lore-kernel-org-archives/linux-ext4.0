From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 15:43:41 +0100
Message-ID: <CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
	<CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
	<CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
	<CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
	<20120301141823.GV5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120301141823.GV5054@shiny>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/3/1 Chris Mason <chris.mason@oracle.com>:
> On Thu, Mar 01, 2012 at 03:03:53PM +0100, Jacek Luczak wrote:
>> 2012/3/1 Hillf Danton <dhillf@gmail.com>:
>> > On Thu, Mar 1, 2012 at 9:35 PM, Jacek Luczak <difrost.kernel@gmail=
=2Ecom> wrote:
>> >>
>> >> While I was about to grab acp I've noticed seekwatcher with made =
my day :)
>> >>
>> >> seekwatcher run of tar cf to eliminate writes (all done on 3.2.7)=
:
>> >> 1) btrfs: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs.pn=
g
>> >> 2) ext4: http://dozzie.jarowit.net/~dozzie/luczajac/tar_ext4.png
>> >> 3) both merged: http://dozzie.jarowit.net/~dozzie/luczajac/tar_bt=
rfs_ext4.png
>
> Whoa, seekwatcher makes it pretty clear.

Yep, ext4 is close to my wife's closet.

>> >>
>> >> I will send acp results soon.
>> >>
>> > Would you please take reiserfs into account?
>>
>> As of now not (lack of time) but I'm pretty close to consider XFS in
>> the game. Whenever I will have more time and there won't be a pressu=
re
>> on giving host back to production I will redo same tests for reiserf=
s.
>>
>> Now I'm focused on the userspace sorting results.
>
> reiserfs should have results very similar to ext4. =A0The directory
> hashing used by reiserfs is going to result in a very random read
> pattern.
>
> XFS will probably beat btrfs in this test. =A0Their directory indexes
> reflect on disk layout very well.

True, but not that fast on small files.

Except the question I've raised in first mail there's a point in all
those action. We are maintaining host that are used for building
software: random access, lot of small files and dirs (always a co),
heavy parallel IO. We were testing XFS vs ext4 a year ago and XFS was
around 10% slower on build times. We did not - yet - done same on
btrfs. Now we're looking for replacement for ext4 as we suffer from
those issue - but we were not aware of that until stepped into this
issue.

If you would like me to do some specific tests around ext4 and btrfs,
let me know.

-Jacek
