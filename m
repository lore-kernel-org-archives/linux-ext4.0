From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Wed, 3 Aug 2011 18:25:25 +0200
Message-ID: <20110803162525.GB10815@quack.suse.cz>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
 <20110801084526.GB6522@quack.suse.cz>
 <4E3675D6.3010201@jp.fujitsu.com>
 <20110801095731.GI6522@quack.suse.cz>
 <4E37BFEA.7020601@jp.fujitsu.com>
 <4E38B57B.4050304@jp.fujitsu.com>
 <20110803095754.GA5047@quack.suse.cz>
 <20110803222548.7c1ee229.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1HCQZ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2011 12:25:29 -0400
Content-Disposition: inline
In-Reply-To: <20110803222548.7c1ee229.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 03-08-11 22:25:48, Toshiyuki Okajima wrote:
> On Wed, 3 Aug 2011 11:57:54 +0200
> Jan Kara <jack@suse.cz> wrote:
> > On Wed 03-08-11 11:42:03, Toshiyuki Okajima wrote:
> > > >(2011/08/01 18:57), Jan Kara wrote:
> > > >>On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
> > > >>>(2011/08/01 17:45), Jan Kara wrote:
> > > >>>>On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
> > > >>>>>If there are some inodes in orphan list while a filesystem i=
s being
> > > >>>>>read-only mounted, we should recommend that pepole umount an=
d then
> > > >>>>>mount it when they try to remount with read-write. But the c=
urrent
> > > >>>>>message/comment recommends that they umount and then remount=
 it.
> > > <SNIP>
> > > >>>>the most... BTW, I guess you didn't really see this message i=
n practice, did
> > > >>>>you?
> > > >>>No.
> > > >>>I have seen this message in practice while quotacheck command =
was repeatedly
> > > >>>executed per an hour.
> > > >>Interesting. Are you able to reproduce this? Quotacheck does re=
mount
> > > >>read-only + remount read-write but you cannot really remount th=
e filesystem
> > > >>read-only when it has orphan inodes and so you should not see t=
hose when
> > > >>you remount read-write again. Possibly there's race between rem=
ounting and
> > > >>unlinking...
> > > >Yes. I can reproduce it. However, it is not frequently reproduce=
d
> > > >by using the original procedure (qutacheck per an hour). So, I m=
ade a
> > > >reproducer.
> > > To tell the truth, I think the race creates the message:
> > > -----------------------------------------------------------------=
------
> > >  EXT3-fs: <dev>: couldn't remount RDWR because of
> > >  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode li=
st.  Please umount/remount instead.
> > > -----------------------------------------------------------------=
------
> > > which hides a serious problem.
> >   I've inquired about this at linux-fsdevel (I think you were in CC=
 unless
> > I forgot). It's a race in VFS remount code as you properly analyzed=
 below.
> > People are working on fixing it but it's not trivial. Filesystem is=
 really
> > a wrong place to fix such problem. If there is a trivial fix for ex=
t3 to
> > workaround the issue, I can take it but I'm not willing to push any=
thing
> > complex - effort should better be spent working on a generic fix.
> I also think read-only remount race in VFS layer should be fixed.
> However, I think this race depends on ext3/ext4 filesystem=20
> implementation. (Orphan inode list)
> So, we should modify ext3/ext4(jbd/jbd2) to fix it.
  Umm, I don't understand here. If VFS makes sure that there are no
files open for writing, no unfinished operations changing the filesyste=
m (e.g.
unlink), and no open-but-unlinked files, what remains for ext3 to check=
?

									Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
