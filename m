From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Fri, 6 Jul 2007 16:53:00 -0600
Message-ID: <20070706225300.GB5633@schatzie.adilger.int>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<1183388313.3864.35.camel@localhost.localdomain>
	<20070703221522.GE14074@fieldses.org>
	<20070703233200.GL6578@schatzie.adilger.int>
	<20070706135156.GD10812@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org, Mingming Cao <cmm@us.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Kalpak Shah <kalpak@clusterfs.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <20070706135156.GD10812@fieldses.org>
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

On Jul 06, 2007  09:51 -0400, J. Bruce Fields wrote:
> The use of a mount option means the change attribute could be
> inconsistent across mounts.  If we really need this, wouldn't it make
> more sense for it to be a persistent feature of the filesystem, set at
> mkfs time?

Yes, having it stored into the superblock in s_flags is probably a good
idea.  Kalpak, do you think you could get a patch that adds e.g.
EXT4_FLAGS_NO_INODE_VERSION (like EXT4_FLAGS_SIGNED_HASH in e2fsprogs).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
