From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Thu, 10 Sep 2009 21:54:35 +0530
Message-ID: <20090910162435.GA5321@skywalker.linux.vnet.ibm.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
 <20090909225429.GB24951@mit.edu>
 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
 <20090910013540.GF24951@mit.edu>
 <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
 <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:42277 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZIJQYp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 12:24:45 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8AGOjNQ010930
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 21:54:45 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8AGOjiA2121834
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 21:54:45 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8AGOi6Q030064
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 02:24:45 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 08:46:41AM -0700, Curt Wohlgemuth wrote:
> On Wed, Sep 9, 2009 at 11:54 PM, Aneesh Kumar
> K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> > On Wed, Sep 09, 2009 at 09:35:40PM -0400, Theodore Tso wrote:
> >> On Wed, Sep 09, 2009 at 05:07:28PM -0700, Curt Wohlgemuth wrote:
> >> >
> >> > First, ext4_journal_forget() is called from ext4_forget() only w=
hen
> >> > we're journalling; without a journal, ext4_journal_forget() is o=
nly
> >> > called for various non-extent paths. =A0ext4_forget() could be c=
hanged,
> >> > of course...
> >>
> >> Ext4_forget() calls either ext4_journal_forget() or
> >> ext4_journal_revoke(). =A0So we need to fix up both functions.
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 - Ted
> >>
> >> commit 4afdf0958f6f7b878e6d85cb4e0c0c12a0bd74e2
> >> Author: Theodore Ts'o <tytso@mit.edu>
> >> Date: =A0 Wed Sep 9 21:32:41 2009 -0400
> >>
> >> =A0 =A0 ext4: Use bforget() in no journal mode for ext4_journal_{f=
orget,revoke}()
> >>
> >> =A0 =A0 When ext4 is using a journal, a metadata block which is de=
allocated
> >> =A0 =A0 must be passed into the journal layer so it can be dropped=
 from the
> >> =A0 =A0 current transaction and/or revoked. =A0This is done by cal=
ling the
> >> =A0 =A0 functions ext4_journal_forget() and ext4_journal_revoke(),=
 which call
> >> =A0 =A0 jbd2_journal_forget(), and jbd2_journal_revoke(), respecti=
vely.
> >>
> >> =A0 =A0 Since the jbd2_journal_forget() and jbd2_journal_revoke() =
call
> >> =A0 =A0 bforget(), if ext4 is not using a journal, ext4_journal_fo=
rget() and
> >> =A0 =A0 ext4_journal_revoke() must call bforget() to avoid a dirty=
 metadata
> >> =A0 =A0 block overwriting a block after it has been reallocated an=
d reused for
> >> =A0 =A0 another inode's data block.
> >>
> >
> > I am sure i am missing something. But where are we adding the buffe=
r_head
> > to the mapping->private_list ?. For ext2 when we allocate meta data=
 blocks
> > we do mark_buffer_dirty_inode which add the buffer_head to the inod=
es
> > private_list. Shouldn't we do something similar with Ext4 without j=
ournal ?
>=20
> As Ted explained to me, all buffer heads pointing to metadata blocks
> are attached to the block device inode.  So pdflush writes of these
> pages go through the block device address space ops.  Explicit
> sync_dirty_buffer() calls for the metadata buffer heads still work, o=
f
> course.

But how would it work for fsync ? I mean=20

I would expect for no journal mode ext4_sync_file  should be doing
simple_fsync(). That should be forcing the metadata buffer_heads
via sync_mapping_buffers. And if we reuse these meta buffers we
drop them the inode->mapping->private_list using bforget.

But I don't see any of the above in code

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
