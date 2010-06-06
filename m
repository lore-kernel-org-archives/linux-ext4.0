From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: force block allocation on quota_off
Date: Mon, 7 Jun 2010 00:36:41 +0200
Message-ID: <20100606223641.GA3302@quack.suse.cz>
References: <20100531191130.GE5334@quack.suse.cz>
 <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
 <20100601121107.GE4275@quack.suse.cz>
 <20100605145530.GA9159@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100605145530.GA9159@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 05-06-10 10:55:30, tytso@mit.edu wrote:
> On Tue, Jun 01, 2010 at 02:11:08PM +0200, Jan Kara wrote:
> > On Tue 01-06-10 11:39:47, Dmitry Monakhov wrote:
> > > Perform full sync procedure to guarantee quota consistency.
> >   The patch looks OK to me. Acked-by: Jan Kara <jack@suse.cz>
> > Ted, will you merge it or should I do it?
> 
> I'll take it, but I don't think either of these is critical enough to
> merge now that the merge window is closed.  Agreed?
  Yes, I agree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
