From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 07:09:00 -0400
Message-ID: <20080709110900.GI9957__20456.432135734$1215601887$gmane$org@mit.edu>
References: <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Arjan van de Ven <arjan@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54755 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754318AbYGILKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 07:10:10 -0400
Content-Disposition: inline
In-Reply-To: <20080709071346.GS11558@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
> *clean*? That the process of freezing it ensures all dirty data and
> metadata is written out before the freeze completes? And that once
> frozen, it can't be dirtied until unfrozen?

What do you mean by "it can't be diritied until unfrozen".  What
happens if I have a kernel compilation happening on a filesystem which
I am trying to freeze?   Does

(a) the freeze fail (because the checks equivalent to what happens
when you remount a filesystem read-only happen)?

(b) The process gets a kill -9 when it tries to write a file on the
frozen filesystem?

(c) The process gets a kill -STOP when it tries to write
to a file on the frozen filesystem?  

(d) The process won't fail, but just continue to run, filling the page
cache with dirty pages that can't be written out because the
filesystem is frozen?

If the answer is (b) or (c), and if you don't have a timeout, and the
backup process which has frozen the filesystem tries to write to the
filesystem, hilarity will ensue....

> That's 3 (or is it 4 - maybe 5 now that I think about it) different
> ppl in 24 hours that have made this same broken argument about
> being unable to write back dirty data on a frozen filesystem......

It's not a question of writing back dirty data, it's the fact that you
*can't*, leading to the page cache filling up wirth dirty data,
leading eventually to the OOM killer running --- and since the last
time I tried suggesting that if the process holding the file
descriptor freezing the filesystem, that idea got shot down (I see
it's been suggested again), if that happens, there is going to be no
other recovery path other than the Big Red Button.

      	       	    	       	       	   - Ted
