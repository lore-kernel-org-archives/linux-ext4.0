From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Wed, 11 Jul 2007 09:28:06 -0500
Message-ID: <1184164086.12154.15.camel@kleikamp.austin.ibm.com>
References: <1183275424.4010.126.camel@localhost.localdomain>
	 <20070710163038.ceb2ae94.akpm@linux-foundation.org>
	 <1184105380.3759.65.camel@localhost.localdomain>
	 <20070710182237.e2f88bf3.akpm@linux-foundation.org>
	 <18068.19667.942363.686858@notabene.brown>
	 <18068.25879.745638.343290@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765023AbXGKO20@vger.kernel.org>
In-Reply-To: <18068.25879.745638.343290@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-11 at 15:05 +1000, Neil Brown wrote:
> It just occurred to me:
> 
>  If i_version is 64bit, then knfsd would need to be careful when
>  reading it on a 32bit host.  What are the locking rules?

How does knfsd use i_version?  I would think that if all it was doing
was to compare (i_version == previous_version), then locking wouldn't
really matter.  Well, theoretically, previous_version could be
0x100000000, and i_version could be 0x1ffffffff, knfsd checks the high
word, then ext4 updates i_version to 0x200000000, then knfsd checks the
low word, detecting no change.  How likely is this?  (I don't understand
why i_version even needs to be 64 bits in the first place.)

>  Presumably it is only updated under i_mutex protection, but having to
>  get i_mutex to read it would seem a little heavy handed.

How does knfsd protect itself from the inode changing after i_version is
checked?  Is any locking being done otherwise?

>  Should it use a seqlock like i_size?
>  Could we use the same seqlock that i_size uses, or would we need a
>  separate one?
> 
> NeilBrown

-- 
David Kleikamp
IBM Linux Technology Center
