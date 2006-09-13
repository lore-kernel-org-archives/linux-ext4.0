From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Sep 2006 14:11:11 -0400
Message-ID: <1158171071.6072.10.camel@lade.trondhjem.org>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
In-Reply-To: <20060913164202.GA14838@openx1.frec.bull.fr>
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

On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> hello, 
> 
> here is a small patch that adds the "change attribute" for ext3
> file-systems;
> 
> the change attribute is a simple counter that is reset to zero on
> inode creation and that is incremented every time the inode data is
> modified (similarly to the "ctime" time-stamp).

I would really have preferred a full-blown 64-bit counter as per
RFC3530, but I suppose we could always combine this change attribute
with the high word from ctime in order to make up the NFSv4 change
attribute. That should keep us safe until someone develops a ramdisk
with < 1 nsecond access time.

Cheers,
  Trond
