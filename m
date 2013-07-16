From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Tue, 16 Jul 2013 08:14:26 +0200
Message-ID: <CACyNnZOgfC+BqvULLSoyo=ZZDaRtS8ydpOm9ZCZ3VerMkPdA0w@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
	<CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
	<20130715134357.GA26359@thunk.org>
	<CACyNnZPnzEbcFj69+fGjm1rkLay51WTXFMqr25AOzY3vtvegpw@mail.gmail.com>
	<20130715163720.GC26359@thunk.org>
	<CACyNnZMxN7p9k0UOFLNmKL6sV0k+grNh85UpPJVyHck9pA7M5w@mail.gmail.com>
	<20130715181037.GD26359@thunk.org>
	<CACyNnZN7jGKYp5P87+OYJzAa-iVWMvBSujBh==A=w642RFDUvQ@mail.gmail.com>
	<20130715185953.GE26359@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41147 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3GPGO1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jul 2013 02:14:27 -0400
Received: by mail-pd0-f176.google.com with SMTP id t12so318626pdi.7
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 23:14:26 -0700 (PDT)
In-Reply-To: <20130715185953.GE26359@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

wow, that was a genial catch, thank you very much =)

With this tip I managed to find what was wrong in the code and then
fixed some other stuff and now it seams that my ext4 reader is fully
working correctly =D

It did come to my mind the size of group descriptors many days ago,
but I had supposed that the _hi elements would be filled with zeroes,
not that they would be completely removed.

Also good to know about debugfs and dumpe2fs

thanks again for all the help and sorry for any disturbance, =)
-- 
Felipe Monteiro de Carvalho
