From: Theodore Tso <tytso@mit.edu>
Subject: Re: +
	ext3-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesys
	tems.patch added to -mm tree
Date: Wed, 11 Feb 2009 10:03:13 -0500
Message-ID: <20090211150312.GJ29220@mini-me.lan>
References: <200902102259.n1AMxMDL008883@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: yjwei@cn.fujitsu.com, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33771 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZBKPQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 10:16:18 -0500
Content-Disposition: inline
In-Reply-To: <200902102259.n1AMxMDL008883@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2009 at 02:59:22PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      ext3: fix support for empty directory blocks in 64k blocksize filesystems
> has been added to the -mm tree.  Its filename is
>      ext3-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch

NACK; I think we need to discuss this some more.  See the discussion
around the similar patch for ext4.

							- Ted
