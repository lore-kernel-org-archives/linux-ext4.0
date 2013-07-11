From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Thu, 11 Jul 2013 09:37:05 +0200
Message-ID: <CACyNnZPc8-r3Qa+_MWiwB+niMkpbpgSfH8MHEOY0tM0n66LFgA@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
	<CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
	<20130701165524.GB23896@thunk.org>
	<CACyNnZPoAt2VNgGfRwzcvVdJHF8xKhE93zS7dGrmodg9Lm=cNQ@mail.gmail.com>
	<20130710172409.GC28076@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55582 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3GKHhG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jul 2013 03:37:06 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so7605393pbc.17
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jul 2013 00:37:05 -0700 (PDT)
In-Reply-To: <20130710172409.GC28076@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

That would be great, but then how to explain that
EXT4_FEATURE_INCOMPAT_FLEX_BG is present in
superblock^.s_feature_incompat

Which indicates that knowledge of this feature is necessary in the reader

-- 
Felipe Monteiro de Carvalho
