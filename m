From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
 enabled
Date: Thu, 6 Mar 2014 10:18:11 -0500
Message-ID: <20140306151811.GB22136@thunk.org>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com>
 <20130705012128.GA11793@gmail.com>
 <20130707154140.GA11993@thunk.org>
 <alpine.LFD.2.00.1403031640020.2258@localhost.localdomain>
 <20140304151925.GC23106@thunk.org>
 <alpine.LFD.2.00.1403061458340.2249@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37965 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaCFPSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 10:18:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403061458340.2249@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 03:03:30PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I am sorry, but am I missing something ? This patch seems to do
> exactly that.
>=20
> 	if ((fs_blocks_count > MAX_32_NUM) &&
> +	    (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT))
> +		fs_param.s_feature_compat &=3D ~EXT2_FEATURE_COMPAT_RESIZE_INODE;
>=20
> The answer from you on that patch is commenting on a guestion from
> Zheng Liu who is asking whether we could skip the MAX_32_NUM check.

You're right, I misread the patch and the e-mail thread.

Thanks, I've applied the patch.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
