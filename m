From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OOPs in ext4
Date: Wed, 21 May 2014 10:53:15 -0400
Message-ID: <20140521145315.GA8868@thunk.org>
References: <CAOkSjBgTFq_LnYnctOj2zR_to47joQDDbft3-kjEGzd2=ooswg@mail.gmail.com>
 <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53565 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaEUOxS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 10:53:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405211506190.2114@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 03:20:20PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> yes there is definitely a bug in the error handling code because we
> really should not hit that BUG_ON() later.

The bug in the error handling code is fixed in commit 66a4cb187, which
will be in 3.15.  I should have split apart the bug fix from the
general cleanup, to make it easier to backport to older kernels.  At
the time, I didn't realize that the bug was getting hit so often.

> However I am curious how we got this state in the first place. Can
> you provide the logs before the first oops ? Are there any more
> warnings ?

Also, after the system rebooted, what messages if any did e2fsck
report?

Thanks,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
