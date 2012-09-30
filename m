From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 12:50:02 -0700
Message-ID: <20120930195002.GA30441@elie.Belkin>
References: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41722 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2I3TuL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Sep 2012 15:50:11 -0400
Content-Disposition: inline
In-Reply-To: <1349034499-4731-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:

> Since __block_page_mkwrite() only has three years,
> block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the

years = callers?
