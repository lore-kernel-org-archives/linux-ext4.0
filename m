From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
Date: Thu, 31 Jan 2013 11:31:57 -0800
Message-ID: <20130131193156.GA20817@localhost>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
 <20130130144535.GK4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130130144535.GK4503@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 30, 2013 at 02:45:35PM +0000, Al Viro wrote:
> On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
> > 
> >   Hi,
> > 
> >   since nobody seem to have picked up any of the patches (at least
> > nobody told me so), I've added acks I received to the patches and I'm
> > sending them to Al for merging. Al, can you please merge these? Thanks.
> 
> VFS part (4/4) picked; IMO at least ext* and xfs should go through the
> filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
> it as well - not sure how active their tree is these days...

	I thought akpm had this through -mm.  I acked it there.

Joel

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

			http://www.jlbec.org/
			jlbec@evilplan.org
