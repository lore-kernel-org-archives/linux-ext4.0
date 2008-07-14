From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 14 Jul 2008 22:12:51 +0900
Message-ID: <88E7CDF01964465CB9F33DE11298271D@nsl.ad.nec.co.jp>
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <mtk.manpages@googlemail.com>, <axboe@kernel.dk>,
	<linux-kernel@vger.kernel.org>, <dm-devel@redhat.com>,
	<xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>,
	<viro@ZenIV.linux.org.uk>, <akpm@linux-foundation.org>,
	<pavel@suse.cz>, <linux-fsdevel@vger.kernel.org>,
	<hch@infradead.org>, "Miklos Szeredi" <miklos@szeredi.hu>,
	"Arjan van de Ven" <arjan@infradead.org>,
	"Theodore Tso" <tytso@mit.edu>,
	"Dave Chinner" <david@fromorbit.com>
To: "jim owens" <jowens@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62174 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYGNNO7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 09:14:59 -0400
In-Reply-To: <4874C3E8.20804@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

jim owens wrote:
> In addition to the user controllable timeout mechanism,
> we internally implement AUTO-THAW in the filesystem
> whenever necessary to prevent a kernel hang/crash.
>
> If an AUTO-THAW occurs, we post to the log and an
> event manager so the user knows the snapshot is bad.

I am interested in AUTO-THAW.
What is the difference between the timeout and AUTO-THAW?
When the kernel detects a deadlock, does it occur to solve it?

Cheers, Takashi
