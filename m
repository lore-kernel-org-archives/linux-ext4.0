From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Sun, 18 Nov 2012 22:24:30 -0500
Message-ID: <20121119032430.GB24414@thunk.org>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
 <1352794923-28555-1-git-send-email-lczerner@redhat.com>
 <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
 <alpine.LFD.2.00.1211131304030.3577@localhost>
 <20121113141911.GA7472@X61>
 <20121113185104.GC1282@lenny.home.zabbo.net>
 <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zach Brown <zab@redhat.com>, Peng Tao <bergwolf@gmail.com>,
	linux-ext4@vger.kernel.org, dmonakhov@openvz.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33481 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2KSDYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Nov 2012 22:24:34 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211151714520.27888@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 15, 2012 at 05:39:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> You're both right. The code have to be reorganized. The
> ext4_ext_fiemap_cb() is ugly as hell, but luckily that will be
> resolved with extent status tree patches from Zheng Liu, however the
> indirection in ext4_ext_walk_space() and the callback business
> is also pointless.

Hi Lukas,

Is your patch going to be dependent on whether the extent status tree
patches are applied?

If so, you might want to develop your patch versus the ext4 git tree's
master branch, which includes the extent status patches currently
queued for the next merge window.

Thanks!!

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
