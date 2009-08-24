From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 23:33:12 +0200
Message-ID: <20090824213312.GG29763@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <200908241611.10400.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Rob Landley <rob@landley.net>, jack@suse.cz
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200908241611.10400.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 2009-08-24 16:11:08, Rob Landley wrote:
> On Monday 24 August 2009 04:31:43 Pavel Machek wrote:
> > Running journaling filesystem such as ext3 over flashdisk or degraded
> > RAID array is a bad idea: journaling guarantees no longer apply and
> > you will get data corruption on powerfail.
> >
> > We can't solve it easily, but we should certainly warn the users. I
> > actually lost data because I did not understand these limitations...
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Acked-by: Rob Landley <rob@landley.net>
> 
> With a couple comments:
> 
> > +* write caching is disabled. ext2 does not know how to issue barriers
> > +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
> 
> It's coming up on 2.6.31, has it learned anything since or should that version 
> number be bumped?

Jan, did those "barrier for ext2" patches get merged? 

> > +	(Thrash may get written into sectors during powerfail.  And
> > +	ext3 handles this surprisingly well at least in the
> > +	catastrophic case of garbage getting written into the inode
> > +	table, since the journal replay often will "repair" the
> > +	garbage that was written into the filesystem metadata blocks.
> > +	It won't do a bit of good for the data blocks, of course
> > +	(unless you are using data=journal mode).  But this means that
> > +	in fact, ext3 is more resistant to suriving failures to the
> > +	first problem (powerfail while writing can damage old data on
> > +	a failed write) but fortunately, hard drives generally don't
> > +	cause collateral damage on a failed write.
> 
> Possible rewording of this paragraph:
> 
>   Ext3 handles trash getting written into sectors during powerfail
>   surprisingly well.  It's not foolproof, but it is resilient.  Incomplete
>   journal entries are ignored, and journal replay of complete entries will
>   often "repair" garbage written into the inode table.  The data=journal
>   option extends this behavior to file and directory data blocks as well
>   (without which your dentries can still be badly corrupted by a power fail
>   during a write).
> 
> (I'm not entirely sure about that last bit, but clarifying it one way or the 
> other would be nice because I can't tell from reading it which it is.  My 
> _guess_ is that directories are just treated as files with an attitude and an 
> extra cacheing layer...?)

Thanks, applied, it looks better than what I wrote. I removed the ()
part, as I'm not sure about it...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
