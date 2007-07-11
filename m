From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 10 Jul 2007 22:22:09 -0700
Message-ID: <20070710222209.5078e20b.akpm@linux-foundation.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<18068.25879.745638.343290@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, cmm@us.ibm.com, linux-kernel@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <18068.25879.745638.343290@notabene.brown>
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

On Wed, 11 Jul 2007 15:05:27 +1000 Neil Brown <neilb@suse.de> wrote:

> 
> It just occurred to me:
> 
>  If i_version is 64bit, then knfsd would need to be careful when
>  reading it on a 32bit host.  What are the locking rules?
> 
>  Presumably it is only updated under i_mutex protection, but having to
>  get i_mutex to read it would seem a little heavy handed.
> 
>  Should it use a seqlock like i_size?
>  Could we use the same seqlock that i_size uses, or would we need a
>  separate one?
> 

seqlocks are a bit of a pain to use (we've had plenty of deadlocks on the
i_size one).  We could reuse inode.i_lock for this modification.  Its
mandate is "general purpose innermost lock to protect stuff in this inode".
