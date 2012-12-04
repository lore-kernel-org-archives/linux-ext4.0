From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 4 Dec 2012 14:08:29 -0500
Message-ID: <20121204190829.GA7790@thunk.org>
References: <50B967E2.7090703@infradead.org>
 <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
 <50B990CB.3080607@infradead.org>
 <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca>
 <50BD017F.1070400@infradead.org>
 <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com>
 <50BE3639.7090704@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36746 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2LDTIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 14:08:35 -0500
Content-Disposition: inline
In-Reply-To: <50BE3639.7090704@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 09:43:21AM -0800, Darren Hart wrote:
> > "modify_inode" is not a terribly easy use interface. Probably better to add something like "chmod" and "chown" for debugfs as well. 
> 
> I was thinking the same thing.
> 

modify_inode is the old command, and it is indeed hard to use.  The
new one (and the one I use all the time) is set_inode_field
(abbreviation "sif"):

    sif /bin/su mode 0104755
    sif /bin/su uid 0

BTW, one of the things that I've always toyed with was to create a
shim layer between the libss API and the tcl embedding API, which
would add some scripting, aliases, and automation relatively easily to
debugfs.

What people have done in practice who have cared about this is to
create perl scripts which emits a series of commands which they then
feed to a pipe which has debugfs on the other end.

						- Ted
