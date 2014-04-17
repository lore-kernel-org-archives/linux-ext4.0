From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: RE: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
 mode
Date: Thu, 17 Apr 2014 14:16:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404171412090.2143@localhost.localdomain>
References: <002a01cf59c3$4eaf7490$ec0e5db0$@samsung.com> <alpine.LFD.2.00.1404171051040.2143@localhost.localdomain> <008501cf5a2b$14b6c690$3e2453b0$@samsung.com> <alpine.LFD.2.00.1404171259130.2143@localhost.localdomain>
 <009001cf5a34$c1b68fc0$4523af40$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1014414870-1397736986=:2143"
Cc: "'Theodore Ts'o'" <tytso@mit.edu>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945892AbaDQMQb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 08:16:31 -0400
In-Reply-To: <009001cf5a34$c1b68fc0$4523af40$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1014414870-1397736986=:2143
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Thu, 17 Apr 2014, Namjae Jeon wrote:

> Date: Thu, 17 Apr 2014 21:01:25 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: 'Luká¹ Czerner' <lczerner@redhat.com>
> Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'linux-ext4' <linux-ext4@vger.kernel.org>
> Subject: RE: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
>      mode
> 
> > 
> > On Thu, 17 Apr 2014, Namjae Jeon wrote:
> > 
> > > Date: Thu, 17 Apr 2014 19:52:09 +0900
> > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > To: 'Luká¹ Czerner' <lczerner@redhat.com>
> > > Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'linux-ext4' <linux-ext4@vger.kernel.org>
> > > Subject: RE: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
> > >      mode
> > >
> > > >
> > > > On Thu, 17 Apr 2014, Namjae Jeon wrote:
> > > >
> > > > > Date: Thu, 17 Apr 2014 07:29:18 +0900
> > > > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > > > To: Theodore Ts'o <tytso@mit.edu>
> > > > > Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
> > > > >     Luká¹ Czerner <lczerner@redhat.com>
> > > > > Subject: [PATCH 2/3] ext4: fix ZERO_RANGE test failure in data journalling
> > > > >     mode
> > > > >
> > > > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > > >
> > > > > xfstests generic/091 is failing when mounting ext4 with data=journal.
> > > > > I think that this regression is same problem that occurred prior to collapse
> > > > > range issue. So ZERO RANGE also need to call ext4_force_commit as
> > > > > collapse range.
> > > > >
> > > > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > > > ---
> > > > >  fs/ext4/extents.c | 7 +++++++
> > > > >  1 file changed, 7 insertions(+)
> > > > >
> > > > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > > > index f386dd6..a64242f 100644
> > > > > --- a/fs/ext4/extents.c
> > > > > +++ b/fs/ext4/extents.c
> > > > > @@ -4742,6 +4742,13 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> > > > >
> > > > >  	trace_ext4_zero_range(inode, offset, len, mode);
> > > > >
> > > > > +	/* Call ext4_force_commit to flush all data in case of data=journal. */
> > > > > +	if (ext4_should_journal_data(inode)) {
> > > > > +		ret = ext4_force_commit(inode->i_sb);
> > > > > +		if (ret)
> > > > > +			return ret;
> > > > > +	}
> > > >
> > > > Hi,
> > > Hi Lukas.
> > > >
> > > > it makes sense. But I have a question, maybe I do not understand it
> > > > correctly but what protect us from other writes coming in after we
> > > > force the commit ?
> > > Yes, Currently new write can come between ext4_force_commit and till
> > > we acquire mutex_lock. But this window is already present even
> > > without patch. Its just that in case of data=journal mode, this
> > > window will become slightly bigger. one possible solution coming to
> > > my mind is one more time calling ext4_force_commit followed by a call
> > > to filemap_write_and_wait_range inside mutex_lock which would sync
> > > data that has dirtied after 1st call.
> > 
> > Can we really call ext4_force_commit() inside mutex_lock ?
> Yes, I can see ext4_force_commit inside mutex_lock in ext4_sync_file().

There might be some misunderstanding, are we talking about
inode->i_mutex because that is certainly not held in
ext4_sync_file() or am I missing something ?

-Lukas

> 
> > 
> > -Lukas
> > 
> > >
> > > Thanks!
> > > >
> > > > -Lukas
> > > >
> > > > > +
> > > > >  	/*
> > > > >  	 * Write out all dirty pages to avoid race conditions
> > > > >  	 * Then release them.
> > > > >
> > >
> > >
> 
> 
--8323328-1014414870-1397736986=:2143--
