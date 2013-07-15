From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 14:10:37 -0400
Message-ID: <20130715181037.GD26359@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
 <20130715134357.GA26359@thunk.org>
 <CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
 <20130715163720.GC26359@thunk.org>
 <CACyNnZMxN7p9k0UOFLNmKL6sV0k+grNh85UpPJVyHck9pA7M5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38019 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3GOSKk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 14:10:40 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZMxN7p9k0UOFLNmKL6sV0k+grNh85UpPJVyHck9pA7M5w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you please run dumpe2fs on the file system in question?

That should answer your questions.  If not, then send me the output.
The output of dumpe2fs is also much easier for me to parse than your
ad-hoc data dumps....

					- Ted
