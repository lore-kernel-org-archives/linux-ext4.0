From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Mon, 1 Jul 2013 17:23:13 +0200
Message-ID: <CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
References: <loom.20130612T140739-743@post.gmane.org>
	<loom.20130623T082353-563@post.gmane.org>
	<20130623115953.GA16193@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37979 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3GAPXN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jul 2013 11:23:13 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so4977984pbc.17
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jul 2013 08:23:13 -0700 (PDT)
In-Reply-To: <20130623115953.GA16193@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 23, 2013 at 1:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Historically, before flex_bg, the allocation bitmaps and inode tables
> for a particular block group had to be located within that block
> group, per the image that you've referenced above.

Thanks, but I'm still not sure: Are all groups flexible groups when
FLEX_BG feature is activated?

If not, I wonder how a reader will recognize which groups were merged ...

thanks,
-- 
Felipe Monteiro de Carvalho
