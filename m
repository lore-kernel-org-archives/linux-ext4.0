From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Mon, 16 Aug 2010 13:45:03 -0700
Message-ID: <20100816204503.GF5786@mail.oracle.com>
References: <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
	<20100812222949.GC22777@mail.oracle.com>
	<20100813163006.GB4329@quack.suse.cz> <4C6821A8.5080805@redhat.com>
	<20100816025436.GA9061@mail.oracle.com>
	<4C68B244.6080406@redhat.com>
	<20100816092114.GB9061@mail.oracle.com>
	<4C694ED3.5070500@redhat.com>
	<20100816191319.GC5786@mail.oracle.com>
	<20100816192100.GD3708@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@redhat.com>,
        "Ted Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20100816192100.GD3708@quack.suse.cz>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 16, 2010 at 09:21:00PM +0200, Jan Kara wrote:
> On Mon 16-08-10 12:13:19, Joel Becker wrote:
> > On Mon, Aug 16, 2010 at 09:44:35AM -0500, Eric Sandeen wrote:
> > > Joel Becker wrote:
> > > > How about:
> > > > 
> > > > 	u64 last_fs_page = last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits);
> > > > 
> > > > 	... ||
> > > > 	(last_fs_page > (pgoff_t)(~0ULL))) {
> > > > 
> > > > Is that more readable?
> > > 
> > > To me, yes.  Maybe do similar for last_fs_sector.
> > 
> > 	last_fs_sector would be shifting up, which could wrap a really
> > large last_fs_blocks.  So I'm going to keep the sector_t check as-is.
> > How's this:
> > 
> > >From 8de5cb9164cdc179ba84a07b282a895d0eb794b0 Mon Sep 17 00:00:00 2001
> > >From: Joel Becker <joel.becker@oracle.com>
> > Date: Mon, 16 Aug 2010 12:10:17 -0700
> > Subject: [PATCH] libfs: Fix shift bug in generic_check_addressable()
> > 
> > generic_check_addressable() erroneously shifts pages down by a block
> > factor when it should be shifting up.  To prevent overflow, we shift
> > blocks down to pages.
> > 
> > Signed-off-by: Joel Becker <joel.becker@oracle.com>
>   Looks good.
> Reviewed-by: Jan Kara <jack@suse.cz>

	Ok, I'm going to keep this atop my existing branch, and if it
all shakes out in linux-next for a few days, send it along.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
