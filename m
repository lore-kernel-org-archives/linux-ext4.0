From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Sep 2006 09:56:20 -0400
Message-ID: <1158242180.5308.24.camel@lade.trondhjem.org>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
	<45095D1B.8040201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Peter Staubach <staubach@redhat.com>
In-Reply-To: <45095D1B.8040201@redhat.com>
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

On Thu, 2006-09-14 at 09:46 -0400, Peter Staubach wrote:
> Wouldn't the generation count work better than ctime to differentiate 
> between
> instances of files using the same inode number?  That way, there wouldn't be
> a clock resolution issue.

No. This is about distinguishing updates to the metadata/data of the
same instance. It is exactly what ctime was supposed to do, but ctime
relies on a clock which usually has too poor time resolution, may not be
monotonic, etc...

Cheers,
  Trond
