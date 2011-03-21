From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: fix callers of ext4_handle_release_buffer() API
Date: Mon, 21 Mar 2011 06:34:02 +0200
Message-ID: <AANLkTinbRfmwo9w8wn56ihE0jSOsHoeRzu15TH3M5qxW@mail.gmail.com>
References: <AANLkTi=KXX9zjBKSGs18OpZUzOD-yyKj9hNVSBi_iBAB@mail.gmail.com>
	<20110321024324.GF4135@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60008 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1CUEeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 00:34:04 -0400
Received: by qwk3 with SMTP id 3so3907899qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 21:34:03 -0700 (PDT)
In-Reply-To: <20110321024324.GF4135@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 4:43 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 01, 2011 at 03:30:24PM +0200, Amir Goldstein wrote:
>> ext4_handle_release_buffer() is an API, which is not being used prop=
erly.
>> This is not so bad considering that it calls jbd2_journal_release_bu=
ffer(),
>> which does nothing, but the snapshots implementation of this API doe=
s
>> something.
>>
>> ext4_jbd2.h defines 2 identical wrapper functions:
>> ext4_journal_release_buffer() and ext4_handle_release_buffer().
>> The former has no callers, so it was removed.
>
> Note that there are some commented-out calls to
> ext4_journal_release_buffer() in resize.c; they're probably commented
> out because at least today, jbd2_journal_release_buffer() is indeed a
> no-op.
>
> I'll update resize.c to use the preferred call. =A0Speaking of which,
> how does on-line resize work in the face of the snapshot feature? =A0=
Is
> that something that is or isn't supported?

Yes, it is supported. (offline resize isn't supported).
The old snapshots sizes (i_disksize) represent the file system
size at the time of the snapshot.

>
> Note also that there may be places where a buffer has
> get_write_access() called on it, only for it to be never modified.
> resize.c is an example of that.

Those places can be a problem (since COW does happen and use
up transaction credits) and calling buffer_release can help
(it tries to extend the transaction), but specifically, resize.c is not
a problem, since blocks outside the active snapshot's i_disksize
are never COWed.

>
>> There are 2 users of the API:
>> ext4_new_inode() calls ext4_handle_release_buffer() and
>> ext4_xattr_block_set() calls jbd2_journal_release_buffer() directly.
>> The latter was chagned to call the wrapper API.
>>
>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>
> I'll apply this patch the changes.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
