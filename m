From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: dump a sparse file as a new sparse file
Date: Tue, 1 Jan 2013 15:57:09 -0500
Message-ID: <20130101205709.GC12554@thunk.org>
References: <20130101020841.GA9641@thunk.org>
 <20130101201012.3146.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gnehzuil.liu@gmail.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41229 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3AAU5N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 15:57:13 -0500
Content-Disposition: inline
In-Reply-To: <20130101201012.3146.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 03:10:12PM -0500, George Spelvin wrote:
> > Note: this is a non-standard/non-portable GCC extension.  The best way
> > to fix this is to explicitly malloc the buffer and then free it before
> > dump_file exits.
> 
> Er... isn't that also in C99?  That should be portable enough.
> Is there an actual compiler of interest that doesn't support it?

There are people who compile e2fsprogs under Windows (e.g. for FUSE
for Windows support), and MSVC does not support VLA's or C99 in
general In general I tend to be very conservative about what compiler
features are used in e2fsprogs, and I do care about portability beyond
just Linux systems.

Regards,

					- Ted
