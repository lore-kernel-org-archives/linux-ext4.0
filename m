From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Suggestion: don't default to ext4 lazy init (or warn about it)
Date: Mon, 13 Nov 2017 12:08:55 -0500
Message-ID: <20171113170855.hfyu6pzf44km4noo@thunk.org>
References: <CDF2F321-7726-417D-8163-2909B9DB9B19@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eduard Rozenberg <edrozenberg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40610 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753854AbdKMRI6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Nov 2017 12:08:58 -0500
Content-Disposition: inline
In-Reply-To: <CDF2F321-7726-417D-8163-2909B9DB9B19@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 13, 2017 at 07:00:38AM -0800, Eduard Rozenberg wrote:
> As I understand:
> * There is no way to force it to speed up

It is possible to speed it up.  Unmount the flie system, and then
mount it with the additional mount option "init_itable=0".  From
Documentation/filesystems/ext4.txt:

init_itable=n		The lazy itable init code will wait n times the
			number of milliseconds it took to zero out the
			previous block group's inode table.  This
			minimizes the impact on the system performance
			while file system's inode table is being initialized.


Hope this helps,

						- Ted
