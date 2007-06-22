From: Jeremy Allison <jra@samba.org>
Subject: Re: avoid leak upon failed realloc
Date: Fri, 22 Jun 2007 10:27:04 -0700
Message-ID: <20070622172704.GA10211@samba1>
References: <87ejkbbycq.fsf@rho.meyering.net>
	<1182175456.13184.7.camel@kleikamp.austin.ibm.com>
	<87wsy15p5n.fsf@rho.meyering.net>
	<20070622064144.GC17097@thunk.org>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org,
	samba-technical@lists.samba.org, Jim Meyering <jim@meyering.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20070622064144.GC17097@thunk.org>
List-Unsubscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/archive/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org
Errors-To: samba-technical-bounces+gnsi-samba-technical=m.gmane.org@lists.samba.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 22, 2007 at 02:41:44AM -0400, Theodore Tso wrote:
> On Mon, Jun 18, 2007 at 04:10:44PM +0200, Jim Meyering wrote:
> > Here's a tiny fix to avoid a leak when realloc fails:
> > 
> > 2007-06-16  Jim Meyering  <jim@meyering.net>
> > 
> > 	* tdb.c (tdb_append): Don't leak a buffer when realloc fails.
> 
> Hi Jim,
> 
> 	Thanks for the patch!  I actually automatically build the
> tdb.c file from the Samba SVN tree (with a series of patches and
> scripts) at: 
> 
> 	svn://svnanon.samba.org/samba/branches/SAMBA_4_0/source/lib/tdb
> 
> So I'm going to forward this patch (attached) to the Samba developers.
> It appears to apply cleanly to .../source/lib/tdb/common/tdb.c.  Once
> they commit it into their SVN tree, I can just pick it up from there.

Thanks Ted, we fixed this in the generic Samba sources by using
realloc wrappers, but tdb has to be separate from these.

I'll commit the fix asap.

Thanks,

	Jeremy.
