From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Wed, 30 Sep 2009 08:21:54 -0700
Message-ID: <20090930082154.20e351cd.randy.dunlap@oracle.com>
References: <20090826052505.GA22238@webber.adilger.int>
	<20090929213859.GB13825@webber.adilger.int>
	<20090929223938.GD3384@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090929223938.GD3384@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 29 Sep 2009 16:39:38 -0600 Andreas Dilger wrote:

> I've done some work to merge some of the existing fsx.c mods into a
> single version.  Over & above the version that is in the LTP, I've
> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
> segfault handling, and per-write fsync.

It sure would be Good if fsx-linux had a fixed, known home, instead of
having to look at Andrew's ext3-tools, Dave's codemonkey files,
LTP, linux-fsdevel mailing list, etc.

Is there a linux-fs-tests package somewhere?  (like where the xfstests
are being merged into)


thanks,
---
~Randy
