From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [fuse-devel] [PATCH 00/25] move handling of
 setuid/gid bits from VFS into individual setattr functions (RESEND)
Date: Thu, 9 Aug 2007 07:55:02 -0400
Message-ID: <20070809075502.b3426ce9.jlayton@redhat.com>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<20070808085435.722f2b10.jlayton@redhat.com>
	<20070808094853.8c27450c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: codalist@TELEMANN.coda.cs.cmu.edu, dhowells@redhat.com,
	jfs-discussion@lists.sourceforge.net, jffs-dev@axis.com,
	zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
	user-mode-linux-user@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, wli@holomorphy.com, xfs@oss.sgi.com,
	cluster-devel@redhat.com, fuse-devel@lists.sourceforge.net,
	joel.becker@oracle.com, mikulas@artax.karlin.mff.cuni.cz,
	linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
	ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
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

On Wed, 8 Aug 2007 22:05:13 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Aug 8 2007 09:48, Andrew Morton wrote:
> >> > On Mon, 6 Aug 2007 09:54:03 -0400
> >> > Jeff Layton <jlayton@redhat.com> wrote:
> >> > 
> >> > Is there any way in which we can prevent these problems?  Say
> >> > 
> >> > - rename something so that unconverted filesystems will reliably fail to
> >> >   compile?
> >> > 
> >> 
> >> I suppose we could rename the .setattr inode operation to something
> >> else, but then we'll be stuck with it for at least a while. That seems
> >> sort of kludgey too...
> >
> >Sure.  We're changing the required behaviour of .setattr.  Changing its
> >name is a fine and reasonably reliable way to communicate that fact.
> 
> Maybe ->chattr/->chgattr?
> 
> 

That seems like a good replacement name. :-)

Now that I think on this further though, maybe Trond's suggestion to
change how the return code works is the best one. That would
(hopefully) catch this problem at runtime, so if someone is using a
precompiled but unconverted module then that would be detected too.

--
Jeff Layton <jlayton@redhat.com>
