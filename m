From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Mon, 15 Jul 2013 12:20:01 +0200
Message-ID: <CACyNnZOkmpkTtDU_-6D9iC3aKOnP4n-XoO1_XJq=Hn2=BnEQYQ@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43349 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3GOKUC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jul 2013 06:20:02 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so11106939pab.10
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 03:20:01 -0700 (PDT)
In-Reply-To: <20130623115953.GA16193@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 23, 2013 at 1:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This had two difficulties.  The first is that every 128MB (assuming a
> 4k blocksize and the default/maximum number of blocks per block
> group), there would be file system metadata, thus breaking up the
> maximum contiguous free space available for data blocks.

But the break up of contiguous free space still occurs, because each
group has a group descriptor in it's beginning, right?

-- 
Felipe Monteiro de Carvalho
