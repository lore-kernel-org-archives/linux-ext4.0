From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Mon, 09 Jul 2007 17:16:30 -0400
Message-ID: <1184015790.3864.26.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
	 <1183388313.3864.35.camel@localhost.localdomain>
	 <20070703221522.GE14074@fieldses.org>
	 <20070703233200.GL6578@schatzie.adilger.int>
	 <20070706135156.GD10812@fieldses.org>
	 <20070706225300.GB5633@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	linux-fsdevel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org,
	Kalpak Shah <kalpak@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070706225300.GB5633@schatzie.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-06 at 16:53 -0600, Andreas Dilger wrote:
> On Jul 06, 2007  09:51 -0400, J. Bruce Fields wrote:
> > The use of a mount option means the change attribute could be
> > inconsistent across mounts.  If we really need this, wouldn't it make
> > more sense for it to be a persistent feature of the filesystem, set at
> > mkfs time?
> 
> Yes, having it stored into the superblock in s_flags is probably a good
> idea.  Kalpak, do you think you could get a patch that adds e.g.
> EXT4_FLAGS_NO_INODE_VERSION (like EXT4_FLAGS_SIGNED_HASH in e2fsprogs).
> 
Per our ext4 interlock discussion today, I have dropped the
ext4-no-inode version-mount-option patch from ext4 patch queue. 

Thanks,
Mingming

