From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 10 Jul 2007 22:17:21 -0700
Message-ID: <20070710221721.23c46edf.akpm@linux-foundation.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<1184119748.20193.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <1184119748.20193.37.camel@localhost.localdomain>
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

On Tue, 10 Jul 2007 22:09:08 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> David Chinneer pointed that we need to journal the version number
> updates together with the operations that causes the change of the inode
> version number, in order to survive server crashes so clients won't see
> the counter go backwards.
> 
> So increment i_version in fs code is probably the place to ensure the
> inode version changes are stored to disk. It's seems update the ext4
> inode version in every ext4_mark_inode_dirty() is the easiest way.

That still makes us dependent upon _something_ changing the inode.  For
overwrites the only something is mtime.

If we don't want to have a peculiar dependency upon s_time_gran=1e9 (and
I don't think we do) then I guess we'll need new code in or around
file_update_time() to do this.
