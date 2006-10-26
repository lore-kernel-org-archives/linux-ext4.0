From: =?iso-8859-1?Q?J=F6rn?= Engel <joern@wohnheim.fh-wedel.de>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 17:25:22 +0200
Message-ID: <20061026152522.GA12596@wohnheim.fh-wedel.de>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <20061023151447.GL3509@schatzie.adilger.int> <20061023160310.GB11353@atrey.karlin.mff.cuni.cz> <20061023172906.GO3509@schatzie.adilger.int> <20061025183656.GD9940@atrey.karlin.mff.cuni.cz> <20061025184118.GG19513@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, adilger@clusterfs.com,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025184118.GG19513@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 25 October 2006 14:41:18 -0400, Jeff Garzik wrote:
> On Wed, Oct 25, 2006 at 08:36:56PM +0200, Jan Kara wrote:
> >   Yes, but there's a question of the interface to this operation. H=
ow to
> > specify which indirect block I mean? Obviously we could introduce
> > separate call for remapping indirect blocks but I find this solutio=
n
> > kind of clumsy...
>=20
> Agreed...  that gets nasty real quick.

Logfs has a similar problem and I introduced a "level".  Without going
into all the gory details, data blocks reside on level 0, indirect
blocks on level 1, doubly indirect blocks on level 2, etc.  With this,
the tupel of (ino, pos, level) can specify any block on the
filesystem, provided it is used for some inode.

Logfs needs this for Garbage Collection, which is a fairly similar
problem.

J=F6rn

--=20
Joern's library part 3:
http://inst.eecs.berkeley.edu/~cs152/fa05/handouts/clark-test.pdf
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
