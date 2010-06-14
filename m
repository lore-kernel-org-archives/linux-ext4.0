From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 14 Jun 2010 09:41:30 -0500
Message-ID: <4C163F9A.2080908@redhat.com>
References: <E1OO9sy-0006P1-Nr@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0FNOlg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 10:41:36 -0400
In-Reply-To: <E1OO9sy-0006P1-Nr@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:

...

> What are things that are still left to be done before we 64-bit support
> is completely supported?  Just a few things:
> 
> * Currently the badblocks list mechanism only supports 32-bit blocks.
>   This may be OK, since running "badblocks" on a really large disk is
>   probably a fool's errand.  But how we handle this is an open question;
>   should we just refuse "mke2fs -c" or "e2fsck -c" for really big file
>   systems?  Should we deprecate the badblocks inode altogether?
> 
> * The online resizing code, which relies on using a resize inode and
>   indirect blocks, will not scale to 64-bit filesystems.  We have the
>   beginnings of support for the "meta_bg" style of resizing, which is
>   supported by the kernel and the e2fsprogs code --- but it hasn't been
>   implemented in the kernel yet.  We need to add that.

* Lazy inode table initialization so that large fs mkfs time is acceptable.

-Eric
