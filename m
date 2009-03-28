From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 20:14:04 -0400
Message-ID: <49CD6BCC.6080602@garzik.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> <20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz> <20090327230902.GG5176@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55017 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZC1AOa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 20:14:30 -0400
In-Reply-To: <20090327230902.GG5176@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> OTOH, the really big databases will tend to use direct I/O, so they
> won't be dirtying the page cache anyway.  So maybe it's not worth the

Not necessarily...  From what I understand, a lot of the individual 
low-level components in cloud storage, such as GoogleFS's chunk 
server[1] do not bypass the page cache, even though they do care about 
the details of data caching and data consistency.

I am looking at the same areas for my own distributed storage work, and 
am finding that the current crop of Linux-specific, 
database/server-friendly syscalls permit more application control over 
pagecache usage than in past years, decreasing the need for O_DIRECT. 
Things like readahead(2), sync_file_range(2), fadvise(3), really help.

	Jeff


[1] http://labs.google.com/papers/gfs-sosp2003.pdf

