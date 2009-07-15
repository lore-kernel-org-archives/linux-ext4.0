From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: More buffer head reference leaks
Date: Wed, 15 Jul 2009 08:00:43 -0700
Message-ID: <6601abe90907150800m4924e35fi13dd4eea6fe7f327@mail.gmail.com>
References: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
	 <20090715055227.GA17310@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:36417 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbZGOPAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 11:00:48 -0400
Received: from spaceape12.eur.corp.google.com (spaceape12.eur.corp.google.com [172.28.16.146])
	by smtp-out.google.com with ESMTP id n6FF0kPv025200
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:00:47 -0700
Received: from pzk34 (pzk34.prod.google.com [10.243.19.162])
	by spaceape12.eur.corp.google.com with ESMTP id n6FF0hCn026838
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:00:44 -0700
Received: by pzk34 with SMTP id 34so1550161pzk.4
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 08:00:43 -0700 (PDT)
In-Reply-To: <20090715055227.GA17310@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 10:52 PM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, Jul 14, 2009 at 01:58:29PM -0700, Curt Wohlgemuth wrote:
>> After the patch I posted last week regarding buffer head ref leaks i=
n
>> no-journal mode, I looked at all the code that uses buffer heads and
>> searched for more potential leaks.
>>
>> The patch below fixes the issues I found; these can occur even when =
a
>> journal is present.
>>
>> The change to inode.c fixes a double release if
>> ext4_journal_get_create_access() fails.
>>
>> The changes to namei.c are more complicated. =A0add_dirent_to_buf() =
will
>> release the input buffer head EXCEPT when it returns -ENOSPC. =A0The=
re are
>> some callers of this routine that don't always do the brelse() in th=
e event
>> that -ENOSPC is returned. =A0Unfortunately, to put this fix into ext=
4_add_entry()
>> required capturing the return value of make_indexed_dir() and
>> add_dirent_to_buf().
>>
>> I'd appreciate comments on these changes, in particular if I'm just =
missing
>> something obvious here.
>>
>> =A0 =A0 =A0 =A0Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>>
>> ---
>> diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
>> --- orig/fs/ext4/inode.c =A0 =A0 =A02009-07-14 11:19:01.000000000 -0=
700
>> +++ new/fs/ext4/inode.c =A0 =A0 =A0 2009-07-14 11:51:42.000000000 -0=
700
>> @@ -758,8 +758,9 @@
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(bh, "call get_create_access=
");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_journal_get_create_access(h=
andle, bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Don't brelse(bh) here; =
it's done in journal_forget()
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* below */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unlock_buffer(bh);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto failed;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>
> I am not able to find the journal_foget call in the path. brelse is
> dropping the buffer_head reference got from sb_getblk right ? Can you
> tell me what is that i am missing ?

Look at the code at the "failed" label.  For each of the allocated BHs
thus far, there's a call to ext4_journal_forget().

Oops, I should have put "ext4_journal_forget()" in the comment; my apol=
ogies.

I'll resend this out, along with a change to ext4_add_entry() to
remove the gotos.

Thanks,
Curt

>
>
>> diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
>> --- orig/fs/ext4/namei.c =A0 =A0 =A02009-07-14 11:19:46.000000000 -0=
700
>> +++ new/fs/ext4/namei.c =A0 =A0 =A0 2009-07-14 11:19:28.000000000 -0=
700
>> @@ -1498,12 +1498,14 @@
>
> .. snip..
>
> -aneesh
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
