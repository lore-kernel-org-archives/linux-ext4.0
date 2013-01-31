From: Jan Kara <jack@suse.cz>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 23:28:17 +0100
Message-ID: <20130131222817.GB13525@quack.suse.cz>
References: <20730.1955.395545.141779@fisica.ufpr.br>
 <20130121054741.GB321@thunk.org>
 <20746.49010.569691.44452@fisica.ufpr.br>
 <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
 <20746.49740.638811.698394@fisica.ufpr.br>
 <20130131220312.GA15322@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>,
	Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab3AaW2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 17:28:30 -0500
Content-Disposition: inline
In-Reply-To: <20130131220312.GA15322@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-01-13 17:03:12, Ted Tso wrote:
> On Thu, Jan 31, 2013 at 05:13:16PM -0200, Carlos Carvalho wrote:
> > Ah, fine. It works, fortunately :-). Thanks.
> > 
> > It's not clear what can be dropped and what must still be used in the
> > new implementation. It'd be nice to state it in the man page of
> > tune2fs, for example. I thought that if we wanted to stop quotas it'd
> > be necessary to umount and tune2fs again.
> 
> This sequence documents the biggest set of issues with the new
> implementation:
> 
> 1) Create a file system.  Populate it with files.  I untarred the
> e2fsprogs source tree as root, so there were a lot of files owned by
> root.
> 
> 2)  unmount the filesystem and run tune2fs -O quota /dev/XXX
> 
> 3) mount the file system; observe that the quota tools don't realize
> that they should be trying to do the quota thing.
  What version of quota-tools are you using? If I didn't screw up
something, version 4.01 shouldn't need the -o quota mount option anymore...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
