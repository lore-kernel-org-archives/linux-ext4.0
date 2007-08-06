From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
Date: Mon, 06 Aug 2007 21:37:00 +0200
Message-ID: <E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu> <1186427063.6616.59.camel@localhost>
Cc: miklos@szeredi.hu, jlayton@redhat.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	codalist@telemann.coda.cs.cmu.edu, cluster-devel@redhat.com,
	jfs-discussion@lists.sourceforge.net,
	mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, wli@holomorphy.com,
	reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
	fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
	user-mode-linux-user@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
	bfennema@falcon.csc.calpoly.edu
To: trond.myklebust@fys.uio.no
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765666AbXHFTit@vger.kernel.org>
In-reply-to: <1186427063.6616.59.camel@localhost> (message from Trond
	Myklebust on Mon, 06 Aug 2007 15:04:23 -0400)
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > Your patch is changing the API in a very unsafe way, since there will
> > be no error or warning on an unconverted fs.  And that could lead to
> > security holes.
> > 
> > If we would rename the setattr method to setattr_new as well as
> > changing it's behavior, that would be fine.  But I guess we do not
> > want to do that.
> 
> Which "unconverted fses"? If we're talking out of tree stuff, then too
> bad: it is _their_ responsibility to keep up with kernel changes.

It is usually a good idea to not change the semantics of an API in a
backward incompatible way without changing the syntax as well.

This is true regardless of whether we care about out-of-tree code or
not (and we should care to some degree).  And especially true if the
change in question is security sensitive.

Miklos
