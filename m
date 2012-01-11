From: Surbhi Palande <csurbhi@gmail.com>
Subject: Re: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Wed, 11 Jan 2012 08:45:17 -0800
Message-ID: <CAMBkX3e_OvCZS2nrwmxHfUONXmVttQP0N4=31mgbAA4V=WVdjA@mail.gmail.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
	<1323367477-21685-2-git-send-email-kamal@canonical.com>
	<4F0C9D87.8010006@sandeen.net>
	<20120110213104.GI4516@quack.suse.cz>
	<CAMBkX3eVeKSmEzmYTe6Oe_D6kAMQTL5LYoi1-Axj7CcrM85Pow@mail.gmail.com>
	<20120111000448.GA16395@quack.suse.cz>
	<CAMBkX3e_jyTZ=i8D8_cza23Xygd+Gf5iACZ+hbo5TaYLrJPH-Q@mail.gmail.com>
	<CAMBkX3e8CKaDh7vdqAcTH1tnye4UusPZ_XjJdNVRZcaDqZnt2g@mail.gmail.com>
	<20120111121022.GB26337@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Kamal Mostafa <kamal@canonical.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58041 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab2AKQpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 11:45:19 -0500
Received: by bkvi17 with SMTP id i17so611530bkv.19
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jan 2012 08:45:17 -0800 (PST)
In-Reply-To: <20120111121022.GB26337@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Thanks a lot for your comments :)

Isn't dirty data flushed out in "ordered" mode? as
ext4_jbd2_file_inode() will get called for ordered writes. Thus this
inode's data is flushed at journal commit time through
journal_submit_data_buffers()?

However I do see that we will still have a dirty data problem for
"writeback" and "journalled" mode?

Regards,
Surbhi.








On Wed, Jan 11, 2012 at 4:10 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 10-01-12 21:38:29, Surbhi Palande wrote:
>> On second thoughts, I fail to see why there is still a race window
>> after this patch.
>>
>> Here are the reasons why i fail to see how the data can be dirtied
>> when all the operations involve a journal:
>>
>> ----------
>> So here is the problem that we see
>> =C2=A0 =C2=A0 =C2=A0 CPU1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CPU2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Task1 (write operation) =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Task2
>> --------------------------------------------------------------------=
-------------------
>> t1 =C2=A0 =C2=A0ext4_journal_start()
>> t2 =C2=A0 =C2=A0 =C2=A0ext4_journal_start_sb()
>> t3 =C2=A0 =C2=A0 =C2=A0 =C2=A0vfs_check_frozen =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sb->frozen=3DSB_FREEZE_WRITE
>> t4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0jbd2_journal_start() =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* he=
nce forth all processes calling
>> vfs_check_frozen will wait */
> =C2=A0Note that we call vfs_check_frozen(sb, SB_FREEZE_TRANS) in
> ext4_journal_start_sb(). Thus we start blocking only when s_frozen =3D=
=3D
> SB_FREEZE_TRANS and we just ignore s_frozen =3D=3D SB_FREEZE_WRITE.
>
>> Now, our aim is to stop Task1 from dirtying the page cache ie in
>> starting this transaction. However if it is successful in starting
>> this transaction, then we want to make sure that this transaction is
>> flushed out.
>> Correct?
> =C2=A0Not quite. Flushing a journal will flush dirty metadata but we =
will still
> have dirty pages (dirty data is not part of any transaction). So in t=
he
> scenarion I describe in
> http://marc.info/?l=3Dlinux-fsdevel&m=3D132585911925796&w=3D2
> all metadata changes will be flushed inside ->freeze_fs (at least for
> journalling filesystems) but pages will be left dirty. Is it clearer =
now?
>
> But your comment makes me realize that the situation is simpler than =
I
> thought by the fact that we only have to protect paths that create di=
rty
> data as dirty metadata can be handled by flushing a journal. And ther=
e are
> only a few places creating dirty data. So a reasonably clean solution
> shouldn't be that complicated after all. I'll tweak my patch and try =
it in
> a moment.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
