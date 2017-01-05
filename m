From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] ext4: convert swap_inode_data() over to use swap()
 on most of the fields
Date: Thu, 5 Jan 2017 08:24:43 +0100
Message-ID: <20170105072443.GB7166@quack2.suse.cz>
References: <1482249341-21113-1-git-send-email-jlayton@redhat.com>
 <20170104154332.GA3607@quack2.suse.cz>
 <1483561288.1826.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483561288.1826.1.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 04-01-17 15:21:28, Jeff Layton wrote:
> On Wed, 2017-01-04 at 16:43 +0100, Jan Kara wrote:
> > On Tue 20-12-16 10:55:41, Jeff Layton wrote:
> > > 
> > > For some odd reason, it forces a byte-by-byte copy of each field. A
> > > plain old swap() on most of these fields would be more efficient. We
> > > do need to retain one memswap however as that field is an array.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > 
> > Looks good to me. You can add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > 								Honza
> > 
> 
> Thanks. Yeah, it's certainly nothing critical -- just something I
> noticed while looking at the i_version rework. Seems like it might be
> good to let soak in next for v4.11?

Yeah, it is definitely 4.11 material. I believe he'll pick up the patch to
his tree once he starts accumulating patches for the next merge window.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
