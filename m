From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 20 Apr 2007 19:21:46 +0530
Message-ID: <20070420135146.GA21352@amitarora.in.ibm.com>
References: <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	suparna@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
	Jakub Jelinek <jakub@redhat.com>, torvalds@linux-foundation.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070418130600.GW5967@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 18, 2007 at 07:06:00AM -0600, Andreas Dilger wrote:
> On Apr 17, 2007  18:25 +0530, Amit K. Arora wrote:
> > On Fri, Mar 30, 2007 at 02:14:17AM -0500, Jakub Jelinek wrote:
> > > Wouldn't
> > > int fallocate(loff_t offset, loff_t len, int fd, int mode)
> > > work on both s390 and ppc/arm?  glibc will certainly wrap it and
> > > reorder the arguments as needed, so there is no need to keep fd first.
> > 
> > I think more people are comfirtable with this approach.
> 
> Really?  I thought from the last postings that "fd first, wrap on s390"
> was better.
> 
> > Since glibc
> > will wrap the system call and export the "conventional" interface
> > (with fd first) to applications, we may not worry about keeping fd first
> > in kernel code. I am personally fine with this approach.
> 
> It would seem to make more sense to wrap the syscall on those architectures
> that can't handle the "conventional" interface (fd first).

Ok.
In this case we may have to consider following things:

1) Obviously, for this glibc will have to call fallocate() syscall with
different arguments on s390, than other archs. I think this should be
doable and should not be an issue with glibc folks (right?).

2) we also need to see how strace behaves in this case. With little
knowledge that I have of strace, I don't think it should depend on
argument ordering of a system call on different archs (since it uses
ptrace internally and that should take care of it). But, it will be
nice if someone can confirm this.

Thanks!
--
Regards,
Amit Arora
