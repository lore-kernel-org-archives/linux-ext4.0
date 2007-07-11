From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Wed, 11 Jul 2007 07:54:37 -0400
Message-ID: <1184154877.6462.6.camel@heimdal.trondhjem.org>
References: <1183275465.4010.130.camel@localhost.localdomain>
	<20070711084737.GA17675@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <20070711084737.GA17675@infradead.org>
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

On Wed, 2007-07-11 at 09:47 +0100, Christoph Hellwig wrote:
> On Sun, Jul 01, 2007 at 03:37:45AM -0400, Mingming Cao wrote:
> > This patch is on top of i_version_update_vfs.
> > The i_version field of the inode is set on inode creation and incremented when
> > the inode is being modified.
> 
> Which is not what i_version is supposed to do.  It'll get you tons of misses
> for NFSv3 filehandles that rely on the generation staying the same for the
> same file.  Please add a new field for the NFSv4 sequence counter instead
> of making i_version unuseable.

Aren't you confusing i_version and i_generation here? Those are two
separate inode fields.

Cheers
  Trond
