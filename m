From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v3 1/9] string: introduce memweight
Date: Wed, 20 Jun 2012 16:12:51 -0700
Message-ID: <CA+8MBb+Kk=G5GQbSdbjXqFmw+GCON6jLZABCAGuL+bNDC+dLgA@mail.gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37403 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2FTXMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 19:12:52 -0400
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 8, 2012 at 5:50 PM, Akinobu Mita <akinobu.mita@gmail.com> w=
rote:
> =A0lib/string.c =A0 =A0 =A0 =A0 =A0 | =A0 36 ++++++++++++++++++++++++=
++++++++++++

Is lib/string.c the right place for this?  I get a build error on the
ia64 sim_defconfig:

  LD      arch/ia64/hp/sim/boot/bootloader

It fails because it pulls in lib/lib.a(string.o) to get some
innocuous function like strcpy() ... but it also gets
given memweight() which relies on __bitmap_weight()
which it doesn't have, because it doesn't include lib/built-in.o
(which is where bitmap.o, the definer of __bitmap_weight(), has
been linked).

Moving memweight() to lib/bitmap.c fixes the problem. But it
isn't really clear that it belongs there either.  Perhaps it should
be its own file lib/memweight.c that gets included in lib/lib.a?

-Tony
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
