From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 3/3] i_version update for ext4: user interface
Date: Tue, 23 Jan 2007 11:52:08 -0700
Message-ID: <20070123185208.GH5236@schatzie.adilger.int>
References: <45B644C3.6000607@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Content-Disposition: inline
In-Reply-To: <45B644C3.6000607@bull.net>
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

On Jan 23, 2007  18:24 +0100, Cordenner jean noel wrote:
> This patch adds a  ``st_i_version'' field in the stat
> structure, and modifies the stat(2) syscall accordingly. Currently the
> change is only visible on i386 and x86_64 archs.

What is the need for exporting i_version to userspace?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
