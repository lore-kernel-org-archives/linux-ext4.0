From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 7 Nov 2006 17:20:11 -0500
Message-ID: <20061107222011.GH29071@ti64.telemetry-investments.com>
References: <20061107114724.9c2cc644.akpm@osdl.org> <1162933193.8123.36.camel@kleikamp.austin.ibm.com> <20061107134513.fbd5f219.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1a.telemetry-investments.com ([64.20.161.180]:44492 "EHLO
	sv1.telemetry-investments.com") by vger.kernel.org with ESMTP
	id S1752969AbWKGWUM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Nov 2006 17:20:12 -0500
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061107134513.fbd5f219.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 07, 2006 at 01:45:13PM -0800, Andrew Morton wrote:
> On Tue, 07 Nov 2006 14:59:52 -0600
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2006-11-07 at 11:47 -0800, Andrew Morton wrote:
> > > Why is ext3 slow??
> > 
> > Allocation?  I don't see anything indicating that Bill is overwriting an
> > existing file, so there is block allocation and journaling overhead.  If
> > that's the case, it would be interesting to see how fast ext3 is when
> > overwriting a file.  Extents and delayed allocation should improve on
> > this a lot.  

Will do.

> Maybe.  or perhaps some funniness with RAID aligment.

I neglected to include the relevant RAID/mkfs info here.

device=/dev/sdc2  # ought to have been on a raid stripe boundary 
                  # very close to the start of the array

# XFS:
mkfs.xfs -f -d su=65536,sw=6 -l su=65536 $device
mount -o noatime,attr2,largeio,logbsize=64k $device /mnt

# Ext3: XFS has problems up through 2.6.18-rc5; use slow, but safe, Ext3:
mke2fs -j -J size=400 -E stride=96 $device
mount -o noatime $device /mnt

Also,  I ran blockdev --flushbufs and

   echo 1 | sudo tee /proc/sys/vm/drop_caches 

before each test.

	-Bill
