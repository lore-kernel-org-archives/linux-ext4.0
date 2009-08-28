From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: support .ko.gz in modules.dep parser
Date: Thu, 27 Aug 2009 22:26:35 -0400
Message-ID: <20090828022635.GS6997@mit.edu>
References: <1251054836-5708-1-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52129 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZH1C0g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 22:26:36 -0400
Content-Disposition: inline
In-Reply-To: <1251054836-5708-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 23, 2009 at 09:13:56PM +0200, Karel Zak wrote:
> The Linux kernel modules could be compressed, it means modules.dep
> parser in libblid has to support .ko.gz extension too.
> 
> (Note, I've talked about this problem with Jon Masters and his
> suggestion is to exec(/sbin/modinfo) rather than directly parse
> modules.dep. BTW, the modules.dep file is deprecated.)

Thanks, applied.

Running modinfo might be the better solution, but there's the standard
tricky business of forking and execing a program from a library (which
might have threads, or open file descriptors, etc.)

						- Ted
