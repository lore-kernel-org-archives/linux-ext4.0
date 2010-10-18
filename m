From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] ext3: Remove misplaced BUFFER_TRACE() in
 ext3_truncate()
Date: Mon, 18 Oct 2010 23:53:11 +0900
Message-ID: <1287413591.1689.25.camel@leonhard>
References: <1287140582-5925-1-git-send-email-namhyung@gmail.com>
	 <4CBC5825.8050502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51083 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0JROxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Oct 2010 10:53:22 -0400
In-Reply-To: <4CBC5825.8050502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-10-18 (=EC=9B=94), 09:22 -0500, Eric Sandeen:
> As long as you're doing these cleanups, you may as well eyeball ext4
> to see whether the same issues exist; in the case above, it does, and=
 the
> exact same patch (modulo ext3/ext4 changes) applies.
>=20
> No real point in getting ext3 fixed up and leaving ext4 behind...
>=20

My plan was sending those patches in a batch after reading ext3 at all.
But it seems to take some time, so now I think that it'd be better to
send them in a small series. I'll prepare it for ext4 (and ext2 too if
you want, Jan) soon. Thanks.

--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
