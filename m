From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Thu, 28 Nov 2013 14:57:15 +0100
Message-ID: <20131128135715.GG31516@quack.suse.cz>
References: <20131126104034.GA4854@quack.suse.cz>
 <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
 <14955.1385644044@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, viro@ZenIV.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3K1N5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Nov 2013 08:57:18 -0500
Content-Disposition: inline
In-Reply-To: <14955.1385644044@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 28-11-13 13:07:24, David Howells wrote:
> Jan Kara <jack@suse.cz> wrote:
> 
> > > 		unsigned long long	st_blocks;
> >   When we are doing this, can we please also change 'st_blocks' to
> > 'st_bytes'? We track space usage in kernel in bytes for a long time so it
> > would be nice to propagate it to userspace via stat instead of a special
> > ioctl (at least quotacheck(8) needs to know the exact value).
> 
> Ummm...  I'm not sure about that.  Ideally, every field that is provided in
> the current stat() buffer must still be there.  On the other hand, since
> they're going to be moved around, presumably there will be a userspace
> translation layer.
  Yeah. If someone uses xstat directly, he should know from documentation
what to do. If someone uses older stat call and glibc translates it to
xstat, then it is trivial for it to translate st_bytes back to st_blocks
(kernel currently does this by >> 9).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
