From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Too large value in inode.i_blocks[1]
Date: Mon, 1 Jul 2013 17:15:21 +0200
Message-ID: <CACyNnZNF6E6rY7oiBX084cuoT+aUMnyhQA_uJFr4=wnPwGAVwA@mail.gmail.com>
References: <loom.20130612T065900-326@post.gmane.org>
	<20130612125954.GB26388@thunk.org>
	<loom.20130612T152507-9@post.gmane.org>
	<20130612135204.GA27403@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42267 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GAPPW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jul 2013 11:15:22 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so5068098pad.23
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jul 2013 08:15:22 -0700 (PDT)
In-Reply-To: <20130612135204.GA27403@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 3:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The ext4_extent_tail is not used in i_blocks[].  There will be up to 4
> ext4_extent structures, or ext4_extent_idx structures, depending on
> the depth of the tree.  The ext4_extent_idx structures are used for
> the interior inodes of the tree.  The ext4_extent structures are used
> for the leaf nodes of the tree.  The ext4_extent_tail is used in
> extent tree blocks so we can checksum the metadata if the
> metadata_csum feature is enabled.  The entire inode is checksummed, so
> we don't need the ext4_extent_tail in i_blocks[].

Hello,

thanks, this part I understood fairly well, but what if eh_entries is
8, for example .... where are the other 4 structures?


-- 
Felipe Monteiro de Carvalho
