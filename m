From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to differentiate ext4 from ext2/3 in code?
Date: Wed, 12 Jun 2013 08:52:25 -0400
Message-ID: <20130612125225.GA26388@thunk.org>
References: <loom.20130531T090136-835@post.gmane.org>
 <20130531152845.GC19561@thunk.org>
 <CADzUK1JrWM+Mm72wYAs_GL6s2A661X1q5VDmfopgZCGajXOshQ@mail.gmail.com>
 <CACyNnZOXuPWvCDtPuAnGD72g41LWLTyuou_gCKRPHm+ZWemyXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Autif Khan <autif.mlist@gmail.com>, linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57235 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab3FLMw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 08:52:28 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZOXuPWvCDtPuAnGD72g41LWLTyuou_gCKRPHm+ZWemyXA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 07:00:57AM +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Thanks a lot, it was a really good answer =) Just to complement I see that
> some software out there uses EXT4_FEATURE_INCOMPAT_EXTENTS in the incompat
> list. It seams that this flag is usually (always?) set in ext4 but never
> (?) present in ext3
> 
> example:
> http://lists.alioth.debian.org/pipermail/parted-devel/2009-January/002488.html

It is true that the extents feature is supported by the ext4 file
system driver, and there exists no versions of the file system drivers
in the Linux kernel which supports the extents feature.

You can certainly construct file systems which have, say, the flex_bg
feature enabled has the same characteristics as the extents feature in
terms of support coverage by ext3 and ext4 implementations in the
Linux kernel, however.

It looks from the patch you've cited that parted is using some
hueristics for the purposes of displaying "ext2" vs "ext3" vs "ext4"
to the user.  That's fine from the perspective of simplifying the user
interface, but it can end up confusing the user for some unusual file
system configurations.

Regards,

					- Ted
