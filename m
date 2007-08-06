From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill
 logic from notify_change into helper function
Date: Mon, 6 Aug 2007 14:13:33 -0400
Message-ID: <20070806141333.0f54ab17.jlayton@redhat.com>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: codalist@TELEMANN.coda.cs.cmu.edu, dhowells@redhat.com,
	jfs-discussion@lists.sourceforge.net, jffs-dev@axis.com,
	reiserfs-devel@vger.kernel.org, zippel@linux-m68k.org,
	user-mode-linux-user@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, wli@holomorphy.com, xfs@oss.sgi.com,
	cluster-devel@redhat.com, fuse-devel@lists.sourceforge.net,
	joel.becker@oracle.com, mikulas@artax.karlin.mff.cuni.cz,
	linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
	ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
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

On Mon, 06 Aug 2007 19:43:46 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Separate the handling of the local ia_valid bitmask from the one in
> > attr->ia_valid. This allows us to hand off the actual handling of the
> > ATTR_KILL_* flags to the .setattr i_op when one is defined.
> > 
> > notify_change still needs to process those flags for the local ia_valid
> > variable, since it uses that to decide whether to return early, and to pass
> > a (hopefully) appropriate bitmask to fsnotify_change.
> 
> I agree with this change and fuse will make use of it as well.
> 
> Maybe instead of unconditionally moving attr_kill_to_mode() inside
> ->setattr() it could be made conditional based on an inode flag
> similarly to S_NOCMTIME.  Advantages:
> 
>  - no need to modify a lot of in-tree filesystems
>  - no silent breakage of out-of-tree fs
> 
> Actually I think the new flag would be used by exacly the same
> filesystems as S_NOCMTIME, so maybe it would make sense to rename
> S_NOCMTIME to something more generic (S_NOATTRUPDATE or whatever) and
> use that.
> 
> But that could still break out-of-tree fs, so a separate flag is
> probably better.
> 

In the past I've been told that adding new flags is something of a
"last resort". Since it's not strictly necessary to fix this then
it may be best to avoid that.

That said, if the concensus is that we need a transition mechanism,
then I'd be open to such a suggestion.

-- 
Jeff Layton <jlayton@redhat.com>
