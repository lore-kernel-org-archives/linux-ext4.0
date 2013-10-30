From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix FITRIM in no journal mode
Date: Wed, 30 Oct 2013 11:12:01 -0400
Message-ID: <20131030151201.GA13343@thunk.org>
References: <1380102385-10475-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52497 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3J3Qu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:50:59 -0400
Content-Disposition: inline
In-Reply-To: <1380102385-10475-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 25, 2013 at 11:46:25AM +0200, Lukas Czerner wrote:
> When using FITRIM ioctl on a file system without journal it will
> only trim the block group once, no matter how many times you invoke
> FITRIM ioctl and how many block you release from the block group.
>=20
> It is because we only clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT in journa=
l
> callback. Fix this by clearing the bit in no journal mode as well.
>=20
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Jorge F=E1bregas <jorge.fabregas@gmail.com>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
