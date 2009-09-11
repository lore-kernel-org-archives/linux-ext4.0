From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Fri, 11 Sep 2009 10:36:25 -0700
Message-ID: <6601abe90909111036h40686334ndc236238f4f8b13a@mail.gmail.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
	 <20090909225429.GB24951@mit.edu>
	 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
	 <20090910013540.GF24951@mit.edu>
	 <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
	 <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com>
	 <20090910162435.GA5321@skywalker.linux.vnet.ibm.com>
	 <20090910185826.GC23700@mit.edu>
	 <20090911172125.GA10155@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:21809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZIKRg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Sep 2009 13:36:26 -0400
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id n8BHaST8022493
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 10:36:29 -0700
Received: from pzk28 (pzk28.prod.google.com [10.243.19.156])
	by spaceape23.eur.corp.google.com with ESMTP id n8BHa6QM017795
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 10:36:26 -0700
Received: by pzk28 with SMTP id 28so1055247pzk.20
        for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 10:36:25 -0700 (PDT)
In-Reply-To: <20090911172125.GA10155@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2009 at 10:21 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Thu, Sep 10, 2009 at 02:58:26PM -0400, Theodore Tso wrote:
>> On Thu, Sep 10, 2009 at 09:54:35PM +0530, Aneesh Kumar K.V wrote:
>> >
>> > But how would it work for fsync ? I mean
>> >
>> > I would expect for no journal mode ext4_sync_file =A0should be doi=
ng
>> > simple_fsync(). That should be forcing the metadata buffer_heads
>> > via sync_mapping_buffers. And if we reuse these meta buffers we
>> > drop them the inode->mapping->private_list using bforget.
>> >
>> > But I don't see any of the above in code
>>
>> Aneesh, you're addressing a different problem than the one that Curt
>> were trying to deal with this patch. =A0The problem we are worry abo=
ut
>> is one where an inode's extent tree or indirect blocks are modified
>> right before the inode is deleted, and then one or more of those
>> metadata blocks get reallocated and written right away (most likely
>> this will happen via an O_DIRECT write), and then, because we didn't
>> use bforget(), the dirty metadata block in the buffer cache would ge=
t
>> written out, overwriting the O_DIRECT block.
>>
>> What you're worrying about, is a different issue. =A0You're concerne=
d
>> about the fact that since we are not associating an inode's extent
>> tree or indirect blocks with the inode, those blocks won't get force=
d
>> out to disk on an fsync() in ext4 no-journal mode. =A0This may not b=
e a
>> big deal for applications which expect to recover from an unclean
>> using mke2fs (and thus probably don't use fsync in any case), but
>> here's a patch to deal with the problem you've raised.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> But the patch you posted is using bforget which is removing the
> buffer_head from the inode->mapping->private_list. What i am
> trying to figure out is where does the buffer_head getting added
> to the private_list. ?

I don't think the buffer_head's b_assoc_map is set, because as you
say, mark_buffer_dirty_inode() isn't called from ext4.

All the bforget() call does in this case is clear the BH dirty bit,
which prevents it from being written out during writeback.

Unless I'm missing something too...

Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
