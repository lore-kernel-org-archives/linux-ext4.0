From: Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Tue, 10 Jan 2012 16:13:46 -0800
Message-ID: <CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
	<CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
	<20120111000448.GA16395@quack.suse.cz>
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
In-Reply-To: <20120111000448.GA16395@quack.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

>>
>>
>> If all the write operations were journaled, then this patch would no=
t allow
>> ext4 filesystem to have any dirty data after its frozen.
>> (as journal_start() would block).
>>
>> =C2=A0I think the only one candidate that creates dirty data without=
 calling
>> ext4_journal_start() is mmapped?
> =C2=A0No, the problem is in any write path. The problem is with opera=
tions
> that happen during the phase when s_frozen =3D=3D SB_FREEZE_WRITE. Th=
ese
> operations dirty the filesystem but running sync may easily miss them=
=2E
> During this phase journal is not frozen so that does not help you in =
any
> way.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza

Ok! No new transaction can really start after the journal is frozen.
But we can have dirty data after SB_FREEZE_WRITE and before
SB_FREEZE_TRANS.
I agree with you. However, can this be fixed by adding a
sync_filesystem() in freeze_super() after the sb->s_op->freeze_fs() is
over?


So then essentially, when freeze_super() returns, the page cache is cle=
an?

I do definitely agree that the fix is to add a lock for mutual
exclusion between freeze filesystem and writes to a frozen filesystem.

Thanks!

Regards,
Surbhi.
