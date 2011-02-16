From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 18:01:26 -0500
Message-ID: <20110216230126.GG26780@thunk.org>
References: <4D5C1380.2020602@redhat.com>
 <4D5C15C6.5000802@redhat.com>
 <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
 <4D5C252B.2010102@redhat.com>
 <20110216214910.GB26780@thunk.org>
 <4D5C473D.5030009@redhat.com>
 <20110216225622.GF26780@thunk.org>
 <4D5C569B.100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57408 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1BPXBe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 18:01:34 -0500
Content-Disposition: inline
In-Reply-To: <4D5C569B.100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 04:58:35PM -0600, Eric Sandeen wrote:
> 
> Ok, if we do it in mke2fs.c that's probably better.
> 
> Or - I wonder how hard it'd be to make this into a mke2fs.conf
> option instead?  I always forget about that route.
> 
> get_string_from_profile(... "default_mount_opts" ....) ?

That would certainly be more general.  I don't really think it matters
for acl and xattr, since I think it's better to make them be the
default in the kernel, and then long term make noacl and noxattr
disappear as mount options altogether.

One reason for doing this is just to make the output of /proc/mounts
look nicer.  :-)

					- Ted
