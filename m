From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 01/25] VFS: move attr_kill logic from
 notify_change into helper function
Date: Tue, 7 Aug 2007 18:20:44 -0400
Message-ID: <20070807182044.06ce4675.jlayton@redhat.com>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<20070807205145.GB30159@infradead.org>
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
In-Reply-To: <20070807205145.GB30159@infradead.org>
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

On Tue, 7 Aug 2007 21:51:49 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> > +void attr_kill_to_mode(struct inode *inode, struct iattr *attr)
> 
> This function badly needs a kerneldoc description.  Also I can't say
> I like the name a lot, but without a clearly better idea I should
> probably not complain :)
> 

Thanks for the comments.

I'm not thrilled with the name either, but kill_suid and *remove_suid
were already taken, and I really didn't want to name this something too
similar since there are already so many similarly named functions that
don't do the same thing. I'm definitely open to suggestions for
something different.

> We should at least add a generic_ prefix to indicate it's a generic
> helper valid for most filesystem (and the kerneldoc comment can explain
> the details)
> 

Both good suggestions. I'll plan to incorporate them in the next
respin of the set.

Thanks,
--
Jeff Layton <jlayton@redhat.com>
