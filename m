From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Thu, 3 Apr 2014 12:39:42 -0700
Message-ID: <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
References: <20140403191558.GA8745@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Al Viro <viro@zeniv.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33778 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaDCTjo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2014 15:39:44 -0400
In-Reply-To: <20140403191558.GA8745@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Btw, since I'm planning on getting to the filesystem pulls later today
(or perhaps tomorrow), I wanted to check: are you ok with the ext4
parts of the cross-rename patches from Miklos?

They are currently at

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git cross-rename

in case you want to refresh your memory.

I have this memory of having seen an acked-by from you last time they
flew past, but looking at Miklos branch that isn't in the commit logs
at least, so maybe my memory is crap. It wouldn't be the first time.

I think the concerns about renameat2() got all sorted out, and I'm
planning on pulling them, but I want to make sure that there aren't
any objections to them.

Al added to the cc for the same reason.

              Linus
