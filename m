From: Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Tue, 10 Jan 2012 13:55:17 -0800
Message-ID: <CAMBkX3dXrxRUSoRWWPzxaii-D0PF-1T2v9=RPhaApnCS2+x0FQ@mail.gmail.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20120110213104.GI4516@quack.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > Hrm let me think through this a little more; we actually do:
> >
> > t16) ext4_journal_start()
> > =C2=A0 t17) ext4_journal_start_sb()
> > =C2=A0 =C2=A0 t18) handle =3D ext4_journal_current_handle();
> > =C2=A0 =C2=A0 t19) if (!handle) vfs_check_frozen()
> > =C2=A0 =C2=A0 t20) ... jbd2_journal_start()
> =C2=A0Ah, right. I forgot.
>
> > So actually we *do* block new handles, but let *existing* ones
> > continue (see commits 6b0310fbf087ad6e9e3b8392adca97cd77184084
> > and be4f27d324e8ddd57cc0d4d604fe85ee0425cba9)
> >
> > So your assertion that a new handle is started is incorrect
> > in general, isn't it? =C2=A0So then does the fix seem necessary?
> > Or, at least, in the fashion below - maybe we need to just make
> > sure all started handles complete before the unlock_updates?
> > Or am I missing something...?
> =C2=A0Well, the problem with running operations and freezing is more
> fundamental I believe. See my email
> http://marc.info/?l=3Dlinux-fsdevel&m=3D132585911925796&w=3D2
>
> So I believe we'll need some better exclusion mechanism already in VF=
S.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>

If all the write operations were journaled, then this patch would not
allow ext4 filesystem to have any dirty data after its frozen.
(as journal_start() would block).

 I think the only one candidate that creates dirty data without
calling ext4_journal_start() is mmapped?

Regards,
Surbhi.
