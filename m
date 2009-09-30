From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Wed, 30 Sep 2009 11:47:59 -0500
Message-ID: <4AC38BBF.4080707@redhat.com>
References: <20090826052505.GA22238@webber.adilger.int> <20090929213859.GB13825@webber.adilger.int> <20090929223938.GD3384@webber.adilger.int> <20090930082154.20e351cd.randy.dunlap@oracle.com> <4AC37A15.8030407@redhat.com> <20090930161913.GA3425@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZI3QsW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2009 12:48:22 -0400
In-Reply-To: <20090930161913.GA3425@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Jones wrote:
> On Wed, Sep 30, 2009 at 10:32:37AM -0500, Eric Sandeen wrote:
>  > Randy Dunlap wrote:
>  > > On Tue, 29 Sep 2009 16:39:38 -0600 Andreas Dilger wrote:
>  > > 
>  > >> I've done some work to merge some of the existing fsx.c mods into a
>  > >> single version.  Over & above the version that is in the LTP, I've
>  > >> included AKPM's O_DIRECT fixes (with a twist), the BSD mmap page and
>  > >> segfault handling, and per-write fsync.
>  > > 
>  > > It sure would be Good if fsx-linux had a fixed, known home, instead of
>  > > having to look at Andrew's ext3-tools, Dave's codemonkey files,
>  > > LTP, linux-fsdevel mailing list, etc.
>  > > 
>  > > Is there a linux-fs-tests package somewhere?  (like where the xfstests
>  > > are being merged into)
>  > 
>  > Well, I think Andreas' idea was to make LTP the official home for now 
>  > which is why I was going to send it here ...
>  > 
>  > But I don't think xfstests is being merged into anything at the moment; 
>  > if anything, we're working to make it a more generic suite of tests (it 
>  > can run about 50 tests on generic posix filesystems by now).
> 
> I'd love to see a tests/ directory shipped with the kernel.
> It's been talked about for about several years and still hasn't happened.
> 
> Is it just because no-one has stepped up to do it ?
> I would be happy to manage a git tree for marshalling stuff on its way to Linus
> if that's all that's holding this idea back.
> 
> Of course if there are other objections..
> 
> 	Dave
>  

Perhaps for simple, small things like fsx.c that might make sense, but a 
full-blown test suite could add significantly to the size of the tarball 
I'd think (especially by the time you start including things like 
including pre-corrupted images, perhaps)...

-Eric


