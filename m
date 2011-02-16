From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 17:56:22 -0500
Message-ID: <20110216225622.GF26780@thunk.org>
References: <4D5C1380.2020602@redhat.com>
 <4D5C15C6.5000802@redhat.com>
 <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
 <4D5C252B.2010102@redhat.com>
 <20110216214910.GB26780@thunk.org>
 <4D5C473D.5030009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55994 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1BPW4g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 17:56:36 -0500
Content-Disposition: inline
In-Reply-To: <4D5C473D.5030009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 03:53:01PM -0600, Eric Sandeen wrote:
> Whoops, I didn't realize that acls were in the same boat, of "config
> on and then turn on with a mount option"
> 
> Ok, sure, adding that makes sense to me too...
> 
> Is sticking it in the _initialize() function ok with you?  It's a
> little odd, but ...

I think it's probably better to put it in the misc/mke2fs.c; we set a
number of superblock options there already.  But either place is fine...

						- Ted
