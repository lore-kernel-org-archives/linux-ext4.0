From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 30 Mar 2012 14:19:36 +0100
Message-ID: <20120330131936.GB26221@amd.home.annexia.org>
References: <20120330125726.GA26221@amd.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839Ab2C3NTp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2012 09:19:45 -0400
Content-Disposition: inline
In-Reply-To: <20120330125726.GA26221@amd.home.annexia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 30, 2012 at 01:57:26PM +0100, Richard W.M. Jones wrote:
> [I'm tracking this issue here:
> https://bugzilla.redhat.com/show_bug.cgi?id=808421]

A bit of further investigation:

I'm currently not passing EXT2_FLAG_64BITS when opening the
filesystem.  Passing this flag fixes the issue, so I'm going to do
that (are there any downsides?)

It seems like a non-64-bit-compatible bitmap was being created, and
that doesn't have the bitmap->bitmap_ops field initialized because
gen_bitmap.c doesn't use this field.  Somehow, though, we end up
calling a function in gen_bitmap64.c which requires that this field be
defined.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
