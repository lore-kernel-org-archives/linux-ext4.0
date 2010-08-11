From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: fix warning if CONFIG_JBD2_DEBUG is not used
Date: Tue, 10 Aug 2010 23:07:20 -0400
Message-ID: <20100811030720.GO3635@thunk.org>
References: <1281490742.4423.10.camel@lovely.krouter>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	dingdinghua <dingdinghua@nrchpc.ac.cn>,
	Joel Becker <joel.becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>, linux-ext4@vger.kernel.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: Christoph Fritz <chf.fritz@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57958 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab0HKDHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Aug 2010 23:07:45 -0400
Content-Disposition: inline
In-Reply-To: <1281490742.4423.10.camel@lovely.krouter>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 11, 2010 at 03:39:02AM +0200, Christoph Fritz wrote:
> Commit 8dd420466c7bfc459fa04680bd5690bfc41a4553 makes variable ts unu=
sed
> when CONFIG_JBD2_DEBUG is not used. This patch ifdefs it too.
>=20
> fs/jbd2/transaction.c: In function =E2=80=98start_this_handle=E2=80=99=
:
> fs/jbd2/transaction.c:98: warning: unused variable =E2=80=98ts=E2=80=99
>=20
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>

I have a patch queued up to fix this already, using an approach
suggested by Linus.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
