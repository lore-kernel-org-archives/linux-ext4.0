From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sat, 9 Aug 2014 13:24:27 -0400
Message-ID: <20140809172427.GF15431@thunk.org>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52472 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaHIRYp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 13:24:45 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 09, 2014 at 10:24:59PM +0800, Li Xi wrote:
> Given the fact that project indentifier is naturally like UID/GID, project ID
> should be managed in the similar way like UID/GID. And that is what people are
> actually doing right now. We already have kuid_t/kgid_t/kprojid_t and a series
> of similar functions for both UIG/GID and project ID. I don't think it is
> necessary to break this kind of self-consistency when we are trying to add
> project quota support. It would be really straightfoward for a new user to
> understand what project ID and project quota means, if we are able to explain
> that project quota has exactly the same semantics with user/group quota.

There is a very big and fundamental difference about project id's
versus user/group id's, and that is that project id's are not first
class objects in the file system.  That is, stat() doesn't understand
them.  Processes do not belong to one (or more) projects, the way they
do for user and group id's.

As a result, project id's are a massive administration nightmare.  You
can't easily see which project a file belongs to, since "ls" and
"stat" has no support for the project id.  So if a file is created in
one directory, the file will inherent that project id from its parent
directory.  Suppose that file is 100 gigabytes, and it chews up most
of the project quota for that project.  Now suppose that file is moved
to some other directory.

How in the world is the administrator supposed to find the file which
is chewing up 100GB of quota?  Find doesn't support project id's
either....

The last time I asked why in the world anyone would want to use this
feature, the only use case that I heard was people who were using
containers, and where the all of the project id's were inside a
chroot.  Hence, any questions I asked about what happens when a file
gets moved out from the hierarchy were hand-waved away, since inside a
chroot, it could never happen.

The question is what are the sane semantics when you don't have the
chroot restriction, and having free-range inodes with project quotas
that can moved all over the file system, seems to me to result in a
not very usable system in the end.

Regards,

						- Ted
