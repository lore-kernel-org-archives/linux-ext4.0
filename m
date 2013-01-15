From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debuge2fs not displaying /dev folder
Date: Tue, 15 Jan 2013 15:14:42 -0500
Message-ID: <20130115201442.GI17719@thunk.org>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com>
 <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43586 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab3AOUOo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 15:14:44 -0500
Content-Disposition: inline
In-Reply-To: <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 11:31:53AM +0530, Prashant Shah wrote:
> 
> When using debuge2fs on a ext3 partition the /dev partition does not
> show any entries at all. While running it on a ext4 partition only
> part of entries are shown for /dev.

Are you sure you don't have a pseudo-filesystem mounted on top of
/dev?

What does "df /dev" report.  If it's something like this, you are
using a pseudo-filesystem for /dev:

% df /dev
Filesystem     1K-blocks  Used Available Use% Mounted on
udev               10240     0     10240   0% /dev

In that case, what debugfs is showing is the entries in your /dev
directory before the udev file system is mounted on top of /dev.

Regards,

					- Ted
