From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 dev branch: mutex not locked in ext4_truncate()
Date: Wed, 3 Apr 2013 22:02:23 -0400
Message-ID: <20130404020223.GA4756@thunk.org>
References: <alpine.LFD.2.00.1304031503470.10110@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59094 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786Ab3DDCC2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304031503470.10110@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 04:41:01PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> There is a quick&dirty patch and it seems to be working well so
> far. Let me know if you prefer standalone patch, or if you'll
> include it into your commit.

While rebasing the ext4 dev tree on top of the 3.9 emergency
big-endian fix (which has been accpeted into Linus's tree), I've
folded your propose change into my commit.

Thanks!!

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
