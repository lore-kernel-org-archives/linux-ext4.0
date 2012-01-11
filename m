From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Wed, 11 Jan 2012 01:51:19 +0100
Message-ID: <20120111005119.GA24005@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-2-git-send-email-kamal@canonical.com>
 <4F0C9D87.8010006@sandeen.net>
 <20120110213104.GI4516@quack.suse.cz>
 <CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
 <20120111000448.GA16395@quack.suse.cz>
 <CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
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
To: Surbhi Palande <csurbhi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-01-12 16:13:46, Surbhi Palande wrote:
> >> If all the write operations were journaled, then this patch would =
not allow
> >> ext4 filesystem to have any dirty data after its frozen.
> >> (as journal_start() would block).
> >>
> >> =A0I think the only one candidate that creates dirty data without =
calling
> >> ext4_journal_start() is mmapped?
> > =A0No, the problem is in any write path. The problem is with operat=
ions
> > that happen during the phase when s_frozen =3D=3D SB_FREEZE_WRITE. =
These
> > operations dirty the filesystem but running sync may easily miss th=
em.
> > During this phase journal is not frozen so that does not help you i=
n any
> > way.
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>=20
> Ok! No new transaction can really start after the journal is frozen.
> But we can have dirty data after SB_FREEZE_WRITE and before
> SB_FREEZE_TRANS.
> I agree with you. However, can this be fixed by adding a
> sync_filesystem() in freeze_super() after the sb->s_op->freeze_fs() i=
s
> over?
  The problem with this is that to do writeback you need to start a
transaction. So you would deadlock.

> So then essentially, when freeze_super() returns, the page cache is c=
lean?
>=20
> I do definitely agree that the fix is to add a lock for mutual
> exclusion between freeze filesystem and writes to a frozen filesystem=
=2E
  Yes, that would be the cleanest solution but it's quite some work.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
