From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH v4] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Mon, 21 Jan 2013 18:40:34 +0800
Message-ID: <50FD1B22.1020906@asianux.com>
References: <50DD20B2.6040204@asianux.com> <50E646BC.2090201@asianux.com> <50E64A4E.7010408@asianux.com> <50E64BFD.6090000@asianux.com> <20130107192016.GD13659@quack.suse.cz> <50EFD427.8060100@asianux.com> <50FB9696.7090702@asianux.com> <20130121102428.GA5588@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>,
	jaegeuk.kim@samsung.com, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, paul.gortmaker@windriver.com,
	ebiederm@xmission.com, adilger.kernel@dilger.ca,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:18137 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3AUKjr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 05:39:47 -0500
In-Reply-To: <20130121102428.GA5588@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2013=E5=B9=B401=E6=9C=8821=E6=97=A5 18:24, Jan Kara =E5=86=99=
=E9=81=93:
>   Al Viro (you have him on CC list) is the right guy to merge this pa=
tch.
> But he's not very responsive at times... You can also check whether h=
e just
> didn't silently merge your patch into his tree -
> http://git.kernel.org/?p=3Dlinux/kernel/git/viro/vfs.git
> I don't see the patch there right now, last update to the tree has
> happened 3 weeks ago. Maybe he's on vacation...

  thank you very much for your patient details replying.

  sorry, it is my fault for my original mail address not including Viro=
=20
    so it is necessary to wait additional week for getting his response=
=2E

  next time, I need only use ./script/get_maintainers.pl to get mail ad=
dress.

  :-(


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
