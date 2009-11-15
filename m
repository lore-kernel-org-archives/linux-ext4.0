From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: directory blocks must be treated as metadata by
	ext4_forget()
Date: Sun, 15 Nov 2009 15:48:10 -0800
Message-ID: <6601abe90911151548w5abb326ag637718d6a800d29b@mail.gmail.com>
References: <20091114232912.GF4221@mit.edu>
	 <1258245059-17687-1-git-send-email-tytso@mit.edu>
	 <20091115070447.GA26614@skywalker.linux.vnet.ibm.com>
	 <20091115204346.GE4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:4704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZKOXsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 18:48:10 -0500
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id nAFNmEA6002373
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 15:48:15 -0800
Received: from pzk31 (pzk31.prod.google.com [10.243.19.159])
	by zps36.corp.google.com with ESMTP id nAFNmAXN025145
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 15:48:12 -0800
Received: by pzk31 with SMTP id 31so3234791pzk.28
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2009 15:48:10 -0800 (PST)
In-Reply-To: <20091115204346.GE4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 12:43 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Nov 15, 2009 at 12:34:48PM +0530, Aneesh Kumar K.V wrote:
>>
>> I guess we need to make sure we call ext4_forget with correct
>> is_metadata values. I did the below patch. The xattr changes in the
>> patch should be split as a separate one. =A0I am not sure why we do =
a
>> get_bh there.
>
> It doesn't hurt to call ext4_forget() with the correct values, but I
> figured it was easier just to make ext4_forget() DTRT thing by
> checking the inode type since it has access to i_mode. =A0My patch
> didn't take into account symlinks, though. =A0 Good catch on your par=
t.
>
>> Another question i have is, do we actually supporting freeing
>> directory blocks when we delete directory entries ? I remember
>> reading we don't have support for that.
>
> No, we don't.
>
>> So may be Curt is not
>> seeing the ext4_forget being called because he is trying delete of
>> directory entries. I guess he will have to do a rmdir directory to
>> see the directory blocks freed.
>
> I'm assuming the problem that Curt was seeing was due to directories
> being deleted, and the blocks getting reused immediately afterwards
> for data blocks. =A0I'm guessing the right was done via direct I/O,
> which means it would have been posted right away, and somehow the
> dirty buffer head some managed to not get forgotten via bforget(). =A0=
In
> the non-journal case, I don't see how that could happen, but I must b=
e
> missing something with the code paths. =A0My experiments show that
> ext4_forget() is getting called, but apparently somehow bforget() mus=
t
> be getting called after that point.

Yes, I'm also assuming that the problem is with deleting directories.
And yes, DIO is used for the 8MB files that are being corrupted.

I'm not sure how I missed the call to ext4_forget() in
ext4_remove_blocks() and ext4_clear_blocks(), but I did -- or at least
I didn't realize they were called for all data blocks being freed.
Thanks.

As to why this happened on our systems where no journal is being used:
 I believe these were running older kernels that didn't have the
patches in c7acb4c16646943180bd221c167a077e0a084f9c, and hence weren't
calling bforget() properly.

Thanks,
Curt

>
>> If you think the changes are correct i will send proper patches with=
 s-o-b
>
> I already have a patch in the patch queue, and I'll just update it to
> include checking for S_ISLNK(inode->i_mode). =A0I suppose I can add y=
our
> change to set is_metadata in ext4_remove_blocks(), but that only
> handles the extents case. =A0The direct/indirect mapped case also has=
 a
> similar issue, which is why decided it was most straightforward to fi=
x
> it in ext4_forget().
>
>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>> index fed5b01..3c93a9a 100644
>> --- a/fs/ext4/xattr.c
>> +++ b/fs/ext4/xattr.c
>> @@ -482,9 +482,8 @@ ext4_xattr_release_block(handle_t *handle, struc=
t inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_bdebug(bh, "refcount now=3D0; freeing=
");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ce)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_cache_entry_free(ce);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle, inode, bh->b_bloc=
knr, 1, 1);
>> - =A0 =A0 =A0 =A0 =A0 =A0 get_bh(bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_forget(handle, 1, inode, bh, bh->b_=
blocknr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle, inode, bh->b_bloc=
knr, 1, 1);
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_add_cpu(&BHDR(bh)->h_refcount, -1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D ext4_handle_dirty_metadata(han=
dle, inode, bh);
>
> This change isn't needed, as you pointed out in a later e-mail,
> ext4_xattr_release_block() isn't supposed to change the refcount of
> the buffer_head; it is brelse'ed by its caller.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
