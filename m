From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file
 systems
Date: Mon, 3 Sep 2012 22:14:12 -0400
Message-ID: <20120904021412.GG5066@thunk.org>
References: <20120903164525.GD5066@thunk.org>
 <1346690758-21072-1-git-send-email-tytso@mit.edu>
 <1346690758-21072-2-git-send-email-tytso@mit.edu>
 <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Liao <kevinlia@gmail.com>,
	Anssi Hannula <anssi.hannula@iki.fi>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48683 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab2IDCOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 22:14:19 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 04, 2012 at 09:59:55AM +0800, Yongqiang Yang wrote:
> Hi Kevin,
> 
>   Ted has sent out the patches on online resizing for meta_bg and
> 64bits, so you can have a try again. It seems that the bug in
> e2fsprogs has been fixed.

Make sure you use the latest version of the kernel patches that I just
sent out.  There quite a number of bugs in the Yongqiang's original
patch set which I tripped over while I was testing 64-bit resize ---
and please note that there are definitely still rough edges
(especially for in cases where the file system was created < 16TB, but
with the 64-bit feature and resize_inode features enabled).  There may
also be bugs for the straightforward case of resizing very large file
systems.

So while I very much appreciate users giving the code a try and
sending us feedback, please do think twice before using this code on
file systems with data that hasn't been backed up recently.  (Of
course, being good System Administrators you are all keeping --- and
verifying --- regular backups, right?  :-)

Regards,

						- Ted
