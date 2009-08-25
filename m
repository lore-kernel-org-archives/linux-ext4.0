From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 20:45:20 +0200
Message-ID: <20090825184520.GA24729@duck.novell.com>
References: <20090312092114.GC6949@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <200908241611.10400.rob@landley.net> <20090824213312.GG29763@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, jack@suse.cz,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755551AbZHYSpX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090824213312.GG29763@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 24-08-09 23:33:12, Pavel Machek wrote:
> On Mon 2009-08-24 16:11:08, Rob Landley wrote:
> > On Monday 24 August 2009 04:31:43 Pavel Machek wrote:
> > > Running journaling filesystem such as ext3 over flashdisk or degraded
> > > RAID array is a bad idea: journaling guarantees no longer apply and
> > > you will get data corruption on powerfail.
> > >
> > > We can't solve it easily, but we should certainly warn the users. I
> > > actually lost data because I did not understand these limitations...
> > >
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Acked-by: Rob Landley <rob@landley.net>
> > 
> > With a couple comments:
> > 
> > > +* write caching is disabled. ext2 does not know how to issue barriers
> > > +  as of 2.6.28. hdparm -W0 disables it on SATA disks.
> > 
> > It's coming up on 2.6.31, has it learned anything since or should that version 
> > number be bumped?
> 
> Jan, did those "barrier for ext2" patches get merged? 
  No, they did not. We were discussing how to be able to enable / disable
sending barriers, someone told he'd implement it but it somehow never got
beyond an initial attempt.
  Actually, after recent sync cleanups (and when my O_SYNC cleanups get
merged) it should be pretty easy because every filesystem now has ->fsync()
and ->sync_fs() callback so we just have to add sending barriers to these
two functions and implement possibility to set via sysfs that barriers on the
block device should be ignored.
  I've put it to my todo list but if someone else has time for this, I
certainly would not mind :). It would be a nice beginner project...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
