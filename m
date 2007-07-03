From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Tue, 3 Jul 2007 17:32:00 -0600
Message-ID: <20070703233200.GL6578@schatzie.adilger.int>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<1183388313.3864.35.camel@localhost.localdomain>
	<20070703221522.GE14074@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <20070703221522.GE14074@fieldses.org>
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

On Jul 03, 2007  18:15 -0400, J. Bruce Fields wrote:
> How will nfsd tell whether it can really on a given filesystem's
> i_version, or whether it should fall back on ctime?

Good question.

> > As to performance concerns that raise before the inode version counter
> > (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> > no extra IO work to store this counter to disk.
> 
> So what's the motivation for the "noversion" mount option?

Lustre needs to be able to control the version number directly (version
number needs to be ordered between all inodes, is set by Lustre to be a
transaction number).  Instead of trying to incorporate this unused code
into ext4 we just turn off the ext4 version code and let Lustre control
this directly.  It may even be that NFSv4 will need to control the version
numbers itself...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
