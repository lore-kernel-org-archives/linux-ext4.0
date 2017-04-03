From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Mon, 3 Apr 2017 07:51:07 -0700
Message-ID: <20170403145107.GC30811@bombadil.infradead.org>
References: <20170331192603.16442-1-jlayton@redhat.com>
 <87fuhqkti0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: NeilBrown <neilb@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fuhqkti0.fsf@notabene.neil.brown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 03, 2017 at 02:25:11PM +1000, NeilBrown wrote:
> I don't like that you need to add a 'flush' handler to every filesystem,
> most of which just call
>  +	return filemap_report_wb_error(file);
> 
> Could we just have
> 	if (filp->f_op->flush)
> 		retval = filp->f_op->flush(filp, id);
> +	else
> +		retval = filemap_report_wb_error(filp);
> in flip_close() ??

Maybe this is badly named as ext4_flush_file().  Maybe this should be
generic_flush_file(), and then there's no per-filesystem overhead to this?
