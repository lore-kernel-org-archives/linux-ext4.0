From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Thu, 25 Jun 2009 14:05:49 -0700
Message-ID: <20090625210549.GM20311@mail.oracle.com>
References: <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
 <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
 <20090624150714.c7264768.akpm@linux-foundation.org>
 <20090625132544.GB9995@mit.edu>
 <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu>
 <20090625194423.GB6472@mit.edu>
 <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
 <20090625203743.GD6472@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36201 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYVH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jun 2009 17:07:57 -0400
Content-Disposition: inline
In-Reply-To: <20090625203743.GD6472@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2009 at 04:37:43PM -0400, Theodore Tso wrote:
> Nicely spotted.  Yeah, that's a bug; we need to do something about
> that one, too.  And what we're doing is a bit silly; it may make sense
> to use __get_free_pages if filesystem blocksize == PAGE_SIZE, but
> otherwise we should be using a sub-page allocator.  Right now, we're
> chewing up a 16k PPC page for every 4k filesystem metadata page
> allocated in journal_write_metadata_buffer(), and on x86, for the
> (admittedly uncommon) 1k block filesystem, we'd be chewing up a 4k
> page for a 1k block buffer.
> 
> 
> Both of these problems exist for both ext3 and ext4.

	And ocfs2.

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
