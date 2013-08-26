From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Block allocation in EXT4
Date: Mon, 26 Aug 2013 19:45:44 +0200
Message-ID: <CACyNnZMBqXqS78vcmwvmY0oL-NqENoXFhw2nqdSkxyEAxMUR=Q@mail.gmail.com>
References: <CAEUQceiEUQOHf8ujjbJF2Q3HSvcqo7r=KOfgoCkFGB_tE6EdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62462 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3HZRpp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Aug 2013 13:45:45 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so3739126pdj.15
        for <linux-ext4@vger.kernel.org>; Mon, 26 Aug 2013 10:45:44 -0700 (PDT)
In-Reply-To: <CAEUQceiEUQOHf8ujjbJF2Q3HSvcqo7r=KOfgoCkFGB_tE6EdcA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm no expert, but I think that you should read i_node.i_flags and
check it for the flag EXT4_EXTENTS_FL to determine which inodes use
the old or the new (extents) method of allocation.

I'm not sure what your objective is, so hopefully this helps something =)

-- 
Felipe Monteiro de Carvalho
