From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Date: Wed, 9 May 2007 16:40:11 +0530
Message-ID: <20070509111011.GA21619@in.ibm.com>
References: <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <17978.47502.786970.196554@cargo.ozlabs.ibm.com> <20070509101507.GA26056@in.ibm.com> <17985.42884.971318.859402@cargo.ozlabs.ibm.com>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17985.42884.971318.859402@cargo.ozlabs.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 09, 2007 at 08:50:44PM +1000, Paul Mackerras wrote:
> Suparna Bhattacharya writes:
> 
> > > This looks like it will have the same problem on s390 as
> > > sys_sync_file_range.  Maybe the prototype should be:
> > > 
> > > asmlinkage long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)
> > 
> > Yes, but the trouble is that there was a contrary viewpoint preferring that fd
> > first be maintained as a convention like other syscalls (see the following
> > posts)
> 
> Of course the interface used by an application program would have the
> fd first.  Glibc can do the translation.

I think that was understood.

Regards
Suparna

> 
> Paul.

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

