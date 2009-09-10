From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Thu, 10 Sep 2009 08:46:41 -0700
Message-ID: <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
	 <20090909225429.GB24951@mit.edu>
	 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
	 <20090910013540.GF24951@mit.edu>
	 <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:1548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZIJPqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 11:46:43 -0400
Received: from zps77.corp.google.com (zps77.corp.google.com [172.25.146.77])
	by smtp-out.google.com with ESMTP id n8AFkiPp004179
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 16:46:44 +0100
Received: from pzk42 (pzk42.prod.google.com [10.243.19.170])
	by zps77.corp.google.com with ESMTP id n8AFkVAG012611
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 08:46:42 -0700
Received: by pzk42 with SMTP id 42so168544pzk.31
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 08:46:41 -0700 (PDT)
In-Reply-To: <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 9, 2009 at 11:54 PM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, Sep 09, 2009 at 09:35:40PM -0400, Theodore Tso wrote:
>> On Wed, Sep 09, 2009 at 05:07:28PM -0700, Curt Wohlgemuth wrote:
>> >
>> > First, ext4_journal_forget() is called from ext4_forget() only whe=
n
>> > we're journalling; without a journal, ext4_journal_forget() is onl=
y
>> > called for various non-extent paths. =A0ext4_forget() could be cha=
nged,
>> > of course...
>>
>> Ext4_forget() calls either ext4_journal_forget() or
>> ext4_journal_revoke(). =A0So we need to fix up both functions.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 - Ted
>>
>> commit 4afdf0958f6f7b878e6d85cb4e0c0c12a0bd74e2
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date: =A0 Wed Sep 9 21:32:41 2009 -0400
>>
>> =A0 =A0 ext4: Use bforget() in no journal mode for ext4_journal_{for=
get,revoke}()
>>
>> =A0 =A0 When ext4 is using a journal, a metadata block which is deal=
located
>> =A0 =A0 must be passed into the journal layer so it can be dropped f=
rom the
>> =A0 =A0 current transaction and/or revoked. =A0This is done by calli=
ng the
>> =A0 =A0 functions ext4_journal_forget() and ext4_journal_revoke(), w=
hich call
>> =A0 =A0 jbd2_journal_forget(), and jbd2_journal_revoke(), respective=
ly.
>>
>> =A0 =A0 Since the jbd2_journal_forget() and jbd2_journal_revoke() ca=
ll
>> =A0 =A0 bforget(), if ext4 is not using a journal, ext4_journal_forg=
et() and
>> =A0 =A0 ext4_journal_revoke() must call bforget() to avoid a dirty m=
etadata
>> =A0 =A0 block overwriting a block after it has been reallocated and =
reused for
>> =A0 =A0 another inode's data block.
>>
>
> I am sure i am missing something. But where are we adding the buffer_=
head
> to the mapping->private_list ?. For ext2 when we allocate meta data b=
locks
> we do mark_buffer_dirty_inode which add the buffer_head to the inodes
> private_list. Shouldn't we do something similar with Ext4 without jou=
rnal ?

As Ted explained to me, all buffer heads pointing to metadata blocks
are attached to the block device inode.  So pdflush writes of these
pages go through the block device address space ops.  Explicit
sync_dirty_buffer() calls for the metadata buffer heads still work, of
course.

Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
