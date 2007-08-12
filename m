From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: Future of ext2 support in the Hurd?
Date: Mon, 13 Aug 2007 01:39:03 +0200
Message-ID: <20070812233903.GM27500@interface.famille.thibault.fr>
References: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bug-hurd@gnu.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iona.labri.fr ([147.210.8.143]:52491 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934871AbXHLXjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 19:39:10 -0400
Content-Disposition: inline
In-Reply-To: <E1IKLAG-0002yi-8Z@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o, le Sun 12 Aug 2007 17:40:00 -0400, a =E9crit :
> no one touched the ext2 code in two years,

Yes, because the current implementation roughly does its job, so I gues=
s
nobody felt brave enough to touch it.  Support for >2GB filesystems was
developped and is used in Debian GNU/Hurd as a patch, though.

Regards,
Samuel
