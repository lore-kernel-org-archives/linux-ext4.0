From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Tue, 7 Aug 2007 18:13:49 -0400
Message-ID: <20070807181349.5d4175c7.jlayton@redhat.com>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807204909.GA30159@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Christoph Hellwig <hch@infradead.org>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20070807204909.GA30159@infradead.org>
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

On Tue, 7 Aug 2007 21:49:09 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> First thanks a lot for doing this work, it's been long needed.
> 
> Second please don't send out that many patches.  We encourage people
> to split things into small patches when the changes are logially
> separated.  Which these are not - it's a flag day change (which btw
> is fine despite the rants soe people spewed in reply to this), so it
> should be one single patch. (Or one for all mainline filesystems +
> one per fs only in -mm to make Andrew's life a little easier if you
> really care.)

Thanks. I debated about how best to split these up. A coworker
mentioned that Andrew had tossed him back a single patch that
touched several mainline filesystems and asked him to break it 
up. I took that to mean that the patches should generally be split
out, but I guess I took that too far ;-)

-- 
Jeff Layton <jlayton@redhat.com>
