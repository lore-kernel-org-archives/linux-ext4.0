From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Wed, 30 Sep 2009 10:32:37 -0500
Message-ID: <4AC37A15.8030407@redhat.com>
References: <20090826052505.GA22238@webber.adilger.int>	<20090929213859.GB13825@webber.adilger.int>	<20090929223938.GD3384@webber.adilger.int> <20090930082154.20e351cd.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090930082154.20e351cd.randy.dunlap@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Randy Dunlap wrote:
> On Tue, 29 Sep 2009 16:39:38 -0600 Andreas Dilger wrote:
> 
>> I've done some work to merge some of the existing fsx.c mods into a
>> single version.  Over & above the version that is in the LTP, I've
>> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
>> segfault handling, and per-write fsync.
> 
> It sure would be Good if fsx-linux had a fixed, known home, instead of
> having to look at Andrew's ext3-tools, Dave's codemonkey files,
> LTP, linux-fsdevel mailing list, etc.
> 
> Is there a linux-fs-tests package somewhere?  (like where the xfstests
> are being merged into)
> 
> 
> thanks,
> ---
> ~Randy

Well, I think Andreas' idea was to make LTP the official home for now 
which is why I was going to send it here ...

But I don't think xfstests is being merged into anything at the moment; 
if anything, we're working to make it a more generic suite of tests (it 
can run about 50 tests on generic posix filesystems by now).

-Eric
