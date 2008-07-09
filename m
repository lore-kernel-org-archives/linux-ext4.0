From: jim owens <jowens@hp.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 09 Jul 2008 10:13:19 -0400
Message-ID: <4874C77F.7070602@hp.com>
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38762 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYGION3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 10:13:29 -0400
In-Reply-To: <4874C3E8.20804@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops..

 > WHY A TIMEOUT - need a way for operator to abort the
 > freeze

instead of "abort" I should have said "limit" because
it is really proactive control (so they will not get
called in the middle of the night by pissed users).

I forgot to make it clear that TIMEOUT is the same as AUTO-THAW
in logging errors so the adnin knows they have a bad snapshot and
can do it again.

I also forgot to say that our customers all say they can deal
with retrying a snapshot, but not with unknown bad snapshots
and most definitely not with killing their 24/7 operations!

jim
