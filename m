From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Date: Mon, 7 May 2007 11:51:44 -0700
Message-ID: <20070507185144.GC6031@schatzie.adilger.int>
References: <20070506222626.GA25632@janus> <20070506214014.8b7451ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754837AbXEGTtn@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070506214014.8b7451ba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 06, 2007  21:40 -0700, Andrew Morton wrote:
> On Mon, 7 May 2007 00:26:26 +0200 Frank van Maarseveen <frankvm@frankvm.com> wrote:
> 
> > 2.6.20.6, FC4:
> > 
> > I created a 91248k ext3 fs with 4k blocksize:
> > 
> > Next, I tried to resize it to about 3G using ext2online while mounted:
> > 
> > At that time the kernel said:
> > 
> > |JBD: ext2online wants too many credits (744 > 256)
> > 
> > What is the limitation I should be aware of? Has it something to do with
> > the journal log size?

Yes, for very small filesystems the default journal size is only 4MB, and
the maximum transaction size is 1MB (256 blocks).

If the filesystem was 128MB or larger in the initial mke2fs then the
journal would be 16MB and the resize would get up to 1024 blocks for
the transaction.

I'm not sure what the right solution is for this.  If you know you will
be resizing the fs you could increase the initial journal size at mke2fs
time (-J size=16).  Alternately, it is possible resize to an intermediate
size and then delete and recreate the journal via tune2fs (which would
be the larger size by default) but that can only be done offline.  

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
