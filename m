From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v4] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Tue, 29 Jan 2013 16:24:05 +0800
Message-ID: <51078725.9000802@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com> <50E64A4E.7010408@asianux.com> <50E64BFD.6090000@asianux.com> <20130107192016.GD13659@quack.suse.cz> <50EFD427.8060100@asianux.com> <50FB9696.7090702@asianux.com> <20130121102428.GA5588@quack.suse.cz> <50FD1B22.1020906@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, paul.gortmaker@windriver.com,
	ebiederm@xmission.com, adilger.kernel@dilger.ca,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <50FD1B22.1020906@asianux.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello Al Viro:

  could you give a glance for this comment patch when you have time ?

    (at least for me, most of comment patches are valuable for integrat=
ing)


  thanks.

gchen.


=E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 18:40, Chen Gang =E5=86=99=
=E9=81=93:
> =E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 18:24, Jan Kara =E5=86=99=
=E9=81=93:
>>   Al Viro (you have him on CC list) is the right guy to merge this p=
atch.
>> But he's not very responsive at times... You can also check whether =
he just
>> didn't silently merge your patch into his tree -
>> http://git.kernel.org/?p=3Dlinux/kernel/git/viro/vfs.git
>> I don't see the patch there right now, last update to the tree has
>> happened 3 weeks ago. Maybe he's on vacation...
>=20
>   thank you very much for your patient details replying.
>=20
>   sorry, it is my fault for my original mail address not including Vi=
ro=20
>     so it is necessary to wait additional week for getting his respon=
se.
>=20
>   next time, I need only use ./script/get_maintainers.pl to get mail =
address.
>=20
>   :-(
>=20
>=20


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe reiserfs-deve=
l" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
