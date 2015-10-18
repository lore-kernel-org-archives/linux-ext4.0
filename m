From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix potential use after free in __ext4_journal_stop
Date: Sat, 17 Oct 2015 22:57:33 -0400
Message-ID: <20151018025733.GK2678@thunk.org>
References: <1441205154-16501-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1510051618030.4946@localhost.localdomain>
 <D351F62D-C7F5-4B8F-8D7C-246DC6BB52CC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56765 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965071AbbJRC5g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 22:57:36 -0400
Content-Disposition: inline
In-Reply-To: <D351F62D-C7F5-4B8F-8D7C-246DC6BB52CC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 05, 2015 at 01:20:52PM -0600, Andreas Dilger wrote:
> > On Oct 5, 2015, at 8:18 AM, Luk=C3=A1=C5=A1 Czerner <lczerner@redha=
t.com> wrote:
> > On Wed, 2 Sep 2015, Lukas Czerner wrote:
> >=20
> >> Date: Wed,  2 Sep 2015 16:45:54 +0200
> >> From: Lukas Czerner <lczerner@redhat.com>
> >> To: linux-ext4@vger.kernel.org
> >> Cc: Lukas Czerner <lczerner@redhat.com>
> >> Subject: [PATCH] ext4: fix potential use after free in __ext4_jour=
nal_stop
> >>=20
> >> There is a use-after-free possibility in __ext4_journal_stop() in =
the
> >> case that we free the handle in the first jbd2_journal_stop() beca=
use
> >> we're referencing handle->h_err afterwards. This was introduced in
> >> 9705acd63b125dee8b15c705216d7186daea4625 and it is wrong. Fix it b=
y
> >> storing the handle->h_err value beforehand and avoid referencing
> >> potentially freed handle.
> >=20
> > ping
> >>=20
> >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>=20
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
