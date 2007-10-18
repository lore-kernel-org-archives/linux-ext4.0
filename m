From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Date: Wed, 17 Oct 2007 21:09:25 -0700
Message-ID: <20071017210925.c3c66de5.akpm@linux-foundation.org>
References: <20070828190551.415127746@sgi.com>
	<20070828190735.292638294@sgi.com>
	<1188432669.3799.35.camel@localhost.localdomain>
	<1188434857.3799.76.camel@localhost.localdomain>
	<1191285346.11737.58.camel@localhost.localdomain>
	<20071004131207.65406a7b.akpm@linux-foundation.org>
	<20071011111849.GC7125@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sho@tnes.nec.co.jp, clameter@sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbXJREJc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 00:09:32 -0400
In-Reply-To: <20071011111849.GC7125@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 11 Oct 2007 13:18:49 +0200 Jan Kara <jack@suse.cz> wrote:

> With 64KB blocksize, a directory entry can have size 64KB which does not fit
> into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> value when read from / written to disk.

btw, this changes ext2's on-disk format.

a) is the ext2 format documented anywhere?  If so, that document will
   need updating.

b) what happens when an old ext2 driver tries to read and/or write this
   directory entry?  Do we need a compat flag for it?

c) what happens when old and new ext3 or ext4 try to read/write this
   directory entry?
