From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/7] ext4: add mutex_is_locked() assertion to
 ext4_truncate()
Date: Tue, 26 Mar 2013 22:29:49 -0400
Message-ID: <20130327022949.GB2697@thunk.org>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu>
 <1364170014-10295-7-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1303261021290.23176@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56162 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3C0C3x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 22:29:53 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303261021290.23176@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 10:31:29AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I have to admit I do not necessarily understand the reason for this.
> Have you seen any specific problem with mutex not being locked in
> the truncation path?

This was really me being paranoid more than anything else and wanting
to add more defensive programming.  I was originally just going to add
a comment, but decided it was better to put the assertion into the
code.

> Also, having mutex not locked in the truncation path is a bug so I
> am not sure why we only do WARN_ON_ONCE() which can be easily missed
> ? Can we do WARN_ON(), or WARN_ON_ONCE() + ext4_warning() ?

Agreed, WARN_ON() is probably more appropriate here.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
