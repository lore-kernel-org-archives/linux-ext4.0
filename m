From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC] [patch 0/3] i_version update for ext4
Date: Wed, 24 Jan 2007 13:06:02 -0500
Message-ID: <20070124180602.GB26806@fieldses.org>
References: <45B644AA.1070409@bull.net>
	<20070123184611.GF5236@schatzie.adilger.int>
	<45B76961.7030509@bull.net> <45B79A12.4060004@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org,
	Cordenner jean noel <jean-noel.cordenner@bull.net>,
	Andreas Dilger <adilger@clusterfs.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <45B79A12.4060004@us.ibm.com>
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

On Wed, Jan 24, 2007 at 09:40:34AM -0800, Mingming Cao wrote:
> Could we just increment the counter each time the mtime is modifies(not 
> the ctime)? Is that enough to serve NFSv4 need?

No, the NFSv4 change attribute is also supposed to change on metadata
updates.

--b.
