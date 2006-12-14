From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Dec 2006 20:52:12 -0500
Message-ID: <20061214015212.GA30071@fieldses.org>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<20061214012428.GA11548@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061214012428.GA11548@schatzie.adilger.int>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 13, 2006 at 06:24:28PM -0700, Andreas Dilger wrote:
> On Sep 13, 2006  14:11 -0400, Trond Myklebust wrote:
> > I would really have preferred a full-blown 64-bit counter as per
> > RFC3530, but I suppose we could always combine this change attribute
> > with the high word from ctime in order to make up the NFSv4 change
> > attribute. That should keep us safe until someone develops a ramdisk
> > with < 1 nsecond access time.
> 
> Trond, can you please elaborate on the need for a 64-bit version counter
> for NFSv4?

I'm not Trond, but....

> What kind of requirements does NFSv4 place on the version?  Monotonic is
> probably a good bet.

The only requirement is that it be unique (assuming a file is never
modified 2^64 times).  Clients can't compare them except for equality.

> Does it need to be global for the filesystem

Nope.

> or is a per-inode version sufficient?

Yes.

> What functionality of NFSv4 needs the version?

Clients use it to revalidate their caches.

--b.
