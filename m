From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
Date: Tue, 14 May 2013 00:43:26 +0800
Message-ID: <20130513164326.GA14526@gmail.com>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
 <20130513131809.GG400@quack.suse.cz>
 <20130513135643.GB12883@gmail.com>
 <20130513151727.GI400@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: EUNBONG SONG <eunb.song@samsung.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130513151727.GI400@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 13, 2013 at 05:17:27PM +0200, Jan Kara wrote:
> On Mon 13-05-13 21:56:43, Zheng Liu wrote:
> > On Mon, May 13, 2013 at 03:18:09PM +0200, Jan Kara wrote:
> > > On Sun 12-05-13 13:04:59, EUNBONG SONG wrote:
> > > > 
> > > > 
> > > > >> Since at this point it's safer to rollback the change and we can
> > > > >> investigate more deeply how to fix it correctly for the next
> > > > >> development cycle, this is the patch which I'm testing.
> > > > 
> > > > >>                     - Ted
> > > > 
> > > > > Hello, I've tested with your patch. But the same problem was reproduced.
> > > > > Currently, I'm trying to git bisect. If i done git bisect, i will let you know.
> > > > 
> > > > Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head() is caused by 
> > > > ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head size."
> > > > I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f06b99f66 because
> > > > I don't know the root cause. 
> > >   This is really strange. I've verified the code and all the places
> > > modifying b_jlist or b_modified are holding bh_state lock so we should be
> > > safe...
> > 
> > Hi Jan,
> > 
> > Could you please take a look at this mail [1].  I don't think we hold
> > bh_state lock there.
> > 
> > 1. http://www.spinics.net/lists/linux-ext4/msg38205.html
>   I'll also reply to that thread but: Yes, we don't hold bh_state lock when
> reading b_jlist in that one case (that's why I wrote 'modify' and not just
> 'access' in my previous email). But that's really harmless since we don't
> do any complex operations with b_jlist (only get & set) so we either see an
> old value or a new one. And that particular use is going away anyway later
> in my series.

I see.  Thanks for your explanation.

                                                - Zheng
