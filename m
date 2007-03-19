From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Date: Mon, 19 Mar 2007 12:23:12 +0100
Message-ID: <20070319112312.GA8331@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316152103.GD8525@osiris.boeblingen.de.ibm.com> <20070319092404.GA12092@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com,
	Matthew Wilcox <matthew@wil.cx>,
	Paul Mackerras <paulus@samba.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Russell King <rmk+lkml@arm.linux.org.uk>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070319092404.GA12092@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 19, 2007 at 02:54:04PM +0530, Amit K. Arora wrote:
> On Fri, Mar 16, 2007 at 04:21:03PM +0100, Heiko Carstens wrote:
> > On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> > >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > > 
> > > Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> > > preallocation and deallocation of preallocated blocks respectively. More
> > > modes can be added, when required. And these modes can be renamed, since
> > > I am sure these are no way the best ones ! :)
> > > 
> Yes, the problem was adding compat wrapper for this. I will appreciate
> your help in writing it. Only thing is that we might have to wait till
> the order of the arguments is decided upon. Thanks!

There is probably not much choice. If you want to stay with the loff_t
arguments it won't work on 31-bit s390 or 32-bit powerpc dependent on the
order of the arguments.
So you should go for what Matthew Wilcox suggested:

asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
			      u32 len_low, u32 len_high);

That way it will work an all architectures and in addition no architecture
has to do some magic to combine the splitted 64 bit arguments in compat
mode.
