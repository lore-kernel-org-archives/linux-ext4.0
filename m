From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix build failure if DX_DEBUG
Date: Sat, 05 Jul 2008 23:10:06 -0500
Message-ID: <4870459E.20006@redhat.com>
References: <484F9030.2020800@cn.fujitsu.com> <484FF75B.8090403@redhat.com> <20080706040751.GA21990@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYGFEKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2008 00:10:18 -0400
In-Reply-To: <20080706040751.GA21990@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Jun 11, 2008 at 11:03:39AM -0500, Eric Sandeen wrote:
>> Li Zefan wrote:
>>> I got build failure when I turned on DX_DEBUG.
>>>
>>> fs/ext4/namei.c: In function =E2=80=98dx_show_leaf=E2=80=99:
>>> fs/ext4/namei.c:291: error: implicit declaration of function =E2=80=
=98ext4_next_entry=E2=80=99
>>> fs/ext4/namei.c:291: warning: assignment makes pointer from integer=
 without a cast
>>>
>>> Move the definition of ext4_next_entry() upwards just as ext3 code.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Thanks,  I added this to the bugfix portion of the ext4 patch queue.
>=20
> But you forgot to edit the series file.  :-)=20
>=20
> I've fixed in the patch queue, and it will be in the 2.6.26-rc9-ext4-=
1
> patch drop.

*sigh*

Thanks...

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
