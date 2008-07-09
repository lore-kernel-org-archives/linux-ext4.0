From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 09 Jul 2008 09:13:34 +0200
Message-ID: <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
References: <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed>
Cc: arjan@infradead.org, miklos@szeredi.hu, hch@infradead.org,
	tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com,
	akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: david@fromorbit.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37656 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYGIHOS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 03:14:18 -0400
In-reply-to: <20080709065950.GR11558@disturbed> (message from Dave Chinner on
	Wed, 9 Jul 2008 16:59:50 +1000)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 9 Jul 2008, Dave Chinner wrote:
> The argument against Miklos' version is that there may be multiple
> commands to execute while the fs is frozen.

Which is what a shell is for ;)

Miklos
