From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
Date: Mon, 06 Aug 2007 15:04:23 -0400
Message-ID: <1186427063.6616.59.camel@localhost>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jlayton@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, codalist@telemann.coda.cs.cmu.edu,
	cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com,
	reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
	fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
	user-mode-linux-user@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
	bfennema@falcon.csc.calpoly.edu
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-08-06 at 20:28 +0200, Miklos Szeredi wrote:

> Your patch is changing the API in a very unsafe way, since there will
> be no error or warning on an unconverted fs.  And that could lead to
> security holes.
> 
> If we would rename the setattr method to setattr_new as well as
> changing it's behavior, that would be fine.  But I guess we do not
> want to do that.

Which "unconverted fses"? If we're talking out of tree stuff, then too
bad: it is _their_ responsibility to keep up with kernel changes.

Trond

