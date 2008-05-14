From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: printk stack trace on ext4_error, ext4_abort and
	ext4_warning.
Date: Wed, 14 May 2008 15:44:44 -0400
Message-ID: <20080514194444.GC7054@mit.edu>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <482B3862.6040809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47099 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761185AbYENTph (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 15:45:37 -0400
Content-Disposition: inline
In-Reply-To: <482B3862.6040809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 14, 2008 at 02:07:14PM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > This helps in better debugging of the problem reported.
> 
> ext4_error happens potentially often in some scenarios, and if I chose
> errors=continue I'm not sure I'd want to dump this much.
> 
> Would it be worth limiting how often this goes off (maybe just once per fs?)

We should really do an audit of the calls to ext4_error() and
determine when it is due to a filesystem corruption (where the stack
dump is not useful, and in fact the ext4_error messages should be
detailed enough so that it is obvious where the corruption is --- in
some cases I've wished that the inode number or block group number
where the problem was detected was included) and where it is more of
an assertion failure, where the stack dump is useful.

If there seems to be a need to include dump_stack(), the first
question I would ask is whether ext4_error() was really the right way
of flagging a problem in the first place, as opposed to using a WARN()
or WARN_ON().

The same is true for ext4_warning().  There should be a very clear
distinction between filesystem corruption, I/O errors, and programming
faults, as much as possible.

							- Ted
