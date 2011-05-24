From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH -v2] ext4: use truncate_setsize() unconditionally
Date: Tue, 24 May 2011 15:06:49 -0700
Message-ID: <BANLkTinAsaFUUEhren4pcyzBw=iyrs8r4w@mail.gmail.com>
References: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>
	<1306178341-17632-1-git-send-email-tytso@mit.edu>
	<4DDBC0EA.7000609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:38484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933169Ab1EXWGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 18:06:54 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p4OM6qbM009054
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 15:06:52 -0700
Received: from gyh4 (gyh4.prod.google.com [10.243.50.196])
	by hpaq6.eem.corp.google.com with ESMTP id p4OM6oM7005971
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 15:06:51 -0700
Received: by gyh4 with SMTP id 4so3278277gyh.12
        for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 15:06:50 -0700 (PDT)
In-Reply-To: <4DDBC0EA.7000609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 7:30 AM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 5/23/11 2:19 PM, Theodore Ts'o wrote:
>> In commit c8d46e41 (ext4: Add flag to files with blocks intentionall=
y
>> past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_truncate()
>> before calling vmtruncate(). =A0This caused any allocated but unwrit=
ten
>> blocks created by calling fallocate() with the FALLOC_FL_KEEP_SIZE
>> flag to be dropped. =A0This was done to make to make sure that
>> EOFBLOCKS_FL would not be cleared while still leaving blocks past
>> i_size allocated. =A0This was not necessary, since ext4_truncate()
>> guarantees that blocks past i_size will be dropped, even in the case
>> where truncate() has increased i_size before calling ext4_truncate()=
=2E
>>
>> So fix this by removing the EOFBLOCKS_FL special case treatment in
>> ext4_setattr(). =A0In addition, use truncate_setsize() followed by a
>> call to ext4_truncate() instead of using vmtruncate(). =A0This is mo=
re
>> efficient since it skips the call to inode_newsize_ok(), which has
>> been checked already by inode_change_ok(). =A0This is also in a win =
in
>> the case where EOFBLOCKS_FL is set since it avoids calling
>> ext4_truncate() twice.
>>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>> =A0Jiayingz pointed out that in the case where we fallocate 12k, wri=
te 4k, and
>> =A0then truncate to 4k, we should discard the excess fallocate'd blo=
cks. =A0So if
>> =A0attr->ia_size =3D=3D inode.i_size, we can skip the truncate_setsi=
ze() call, but
>> =A0if the EOFBLOCKS_FL flag is set, we should still call ext4_trunca=
te().
>
> are there xfstests which cover this explicitly? =A0It should be simpl=
e to write.
>
Vivek has written a xfstest to cover this and more fallocate/truncate c=
ases:
http://old.nabble.com/-PATCH--xfstests%3A-test-fallocate%2C-write%2C-ft=
runcate-combinations.-to31666685.html#a31666685

Jiaying

> If filesystem behavior differs we can always make ext4-only tests.
>
> -Eric
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
