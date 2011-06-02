From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
Date: Wed, 1 Jun 2011 21:47:04 -0400
Message-ID: <20110602014704.GA16306@thunk.org>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
 <4DE5C1FE.8080006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, XFS <xfs@oss.sgi.com>,
	Sergey Ivanov <sergey57@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55288 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1FBEBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 00:01:12 -0400
Content-Disposition: inline
In-Reply-To: <4DE5C1FE.8080006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 31, 2011 at 11:37:18PM -0500, Eric Sandeen wrote:
> 
> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
> 
> What issue are you avoiding?  wouldn't fsck -t ext4dev invoke
> fsck.ext4dev anyway?

This is a change I make locally when I've been debugging my bigalloc
code as well.  There reason for that is because I want to override the
fsck.ext4 that would get used by using path hacking.  The problem was
that fsck -t ext4 will look for /sbin/fsck.ext4, where as I wanted it
to use the fsck.ext4 that was first in the PATH.

So I changed "/sbin/fsck -t $FSTYP" to "fsck.$FSTYP" and made sure
/sbin was tacked onto the path. 

It might be that the right answer is that fsck should have an
environment variable or some other way of controlling the search path
it uses to find the fsck.XXX binary.

						- Ted
