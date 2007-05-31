From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch 2/2] i_version update - ext4 part
Date: Wed, 30 May 2007 22:25:14 -0400
Message-ID: <1180578314.6696.24.camel@heimdal.trondhjem.org>
References: <46570E16.5040006@bull.net>
	 <1180467854.4204.15.camel@localhost.localdomain>
	 <20070529225817.GE5181@schatzie.adilger.int>
	 <1180568925.3794.44.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	jean-noel.cordenner@bull.net, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1180568925.3794.44.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-30 at 16:48 -0700, Mingming Cao wrote:
> On Tue, 2007-05-29 at 16:58 -0600, Andreas Dilger wrote:
> > I don't know what the NFS requirements for the version are.  There may
> > also be some complaints from others if the i_version is 64 bits because
> > this contributes to generic inode growth and isn't used for other
> > filesystems.
> > 
> That should benefit for other filesystems, as I thought this NFS
> requirements apply to all filesystems. 

Right. The point here is that the NFS protocol needs to impose certain
requirements on _all_ filesystems that want to be supported, and so it
is in the interest of everyone to have a generic update mechanism
available in the VFS in order to avoid code (and bug) replication.

Now if Lustre doesn't care about NFS compatibility, then I suppose it
would be fairly easy to engineer the i_version update interface to allow
them to use that field in whatever way suits them best.

Trond

