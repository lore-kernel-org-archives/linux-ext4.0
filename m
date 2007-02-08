From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Testing ext4 persistent preallocation patches for 64 bit features
Date: Thu, 8 Feb 2007 16:21:09 +0530
Message-ID: <20070208105109.GA25741@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070207074801.GA5419@amitarora.in.ibm.com> <1170836750.4355.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	suparna@in.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1170836750.4355.36.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 07, 2007 at 12:25:50AM -0800, Mingming Cao wrote:
> On Wed, 2007-02-07 at 13:18 +0530, Amit K. Arora wrote:
> > c) Do I need to put some hack in the filesystem code for above (to
> > allocate >32 bit physical block numbers) ?
> I had a ext3 hack patch before to allow application specify which block
> group is the targeted block allocation group,using ioctl command, so to
> allocate >32 bit physical block numbers it just set the target block
> group beyond 2**(32-15) = 2**17. patch is below..

Thanks for the patch! 

> BTW, have you considered
> - move the preallocation code in ioctl to a seperate function, and call
> that function from ioctl? That way we could easily switch to
> posix_falloc later.

OK.

> - Test preallocation with mapped IO?

I haven't done that yet. Will test it out too. Thanks!

--
Regards,
Amit Arora
