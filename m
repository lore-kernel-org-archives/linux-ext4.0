From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 9 Mar 2012 09:34:46 -0500
Message-ID: <20120309143446.GO29510@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 09, 2012 at 12:29:29PM +0100, Lukas Czerner wrote:
> Hi,
> 
> I have created a simple script which creates a bunch of files with
> random names in the directory and then performs operation like list,
> tar, find, copy and remove. I have run it for ext4, xfs and btrfs with
> the 4k size files. And the result is that ext4 pretty much dominates the
> create times, tar times and find times. However copy times is a whole
> different story unfortunately - is sucks badly.
> 
> Once we cross the mark of 320000 files in the directory (on my system) the
> ext4 is becoming significantly worse in copy times. And that is where
> the hash tree order in the directory entry really hit in.
> 
> Here is a simple graph:
> 
> http://people.redhat.com/lczerner/files/copy_benchmark.pdf
> 
> Here is a data where you can play with it:
> 
> https://www.google.com/fusiontables/DataSource?snapid=S425803zyTE
> 
> and here is the txt file for convenience:
> 
> http://people.redhat.com/lczerner/files/copy_data.txt
> 
> I have also run the correlation.py from Phillip Susi on directory with
> 100000 4k files and indeed the name to block correlation in ext4 is pretty
> much random :)
> 
> _ext4_
> Name to inode correlation: 0.50002499975
> Name to block correlation: 0.50002499975
> Inode to block correlation: 0.9999900001
> 
> _xfs_
> Name to inode correlation: 0.969660303397
> Name to block correlation: 0.969660303397
> Inode to block correlation: 1.0
> 
> 
> So there definitely is a huge space for improvements in ext4.

Thanks Lukas, this is great data.  There is definitely room for btrfs to
speed up in the other phases as well.

-chris
