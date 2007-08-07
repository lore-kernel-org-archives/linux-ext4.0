From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
	from VFS into individual setattr functions (RESEND)
Date: Tue, 7 Aug 2007 21:49:09 +0100
Message-ID: <20070807204909.GA30159@infradead.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com,
	jfs-discussion@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, reiserfs-devel@vger.kernel.org,
	zippel@linux-m68k.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
	wli@holomorphy.com, joel.becker@oracle.com, dhowells@redhat.com,
	fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
	user-mode-linux-user@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
	ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
To: Jeff Layton <jlayton@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

First thanks a lot for doing this work, it's been long needed.

Second please don't send out that many patches.  We encourage people
to split things into small patches when the changes are logially
separated.  Which these are not - it's a flag day change (which btw
is fine despite the rants soe people spewed in reply to this), so it
should be one single patch. (Or one for all mainline filesystems +
one per fs only in -mm to make Andrew's life a little easier if you
really care.)
