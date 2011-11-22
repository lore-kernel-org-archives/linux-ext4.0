From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2] jbd: clear revoked flag on buffers before a new
 transaction started
Date: Tue, 22 Nov 2011 09:55:17 +0800
Message-ID: <CAGBYx2YjzYSXXnTCej_YzdJ+2q9cMTOG24bso7FHB4ZJwa_Ttw@mail.gmail.com>
References: <1321695269-3319-1-git-send-email-xiaoqiangnk@gmail.com>
	<20111122002326.GH4017@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39592 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1KVBzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 20:55:18 -0500
Received: by ggnr5 with SMTP id r5so3029274ggn.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2011 17:55:18 -0800 (PST)
In-Reply-To: <20111122002326.GH4017@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 22, 2011 at 8:23 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 19-11-11 17:34:29, Yongqiang Yang wrote:
>> Currently, we clear revoked flag only when a block is reused. =A0How=
ever,
>> this can tigger a false journal error. =A0Consider a situation when =
a block
>> is used as a meta block and is deleted(revoked) in ordered mode, the=
n the
>> block is allocated as a data block to a file. =A0At this moment, use=
r changes
>> the file's journal mode from ordered to journaled and truncates the =
file.
>> The block will be considered re-revoked by journal because it has re=
voked
>> flag still pending from the last transaction and an assertion trigge=
rs.
>>
>> We fix the problem by keeping the revoked status more uptodate - we =
clear
>> revoked flag when switching revoke tables to reflect there is no rev=
oked
>> buffers in current transaction any more.
> =A0Thanks. Merged into my tree. Will you create the same patch for JB=
D2 as
> well?
YES!  I had sent out the patch for jbd2.  It seems that Ted is busy the=
se days.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/jbd/commit.c =A0 =A0 | =A0 =A06 ++++++
>> =A0fs/jbd/revoke.c =A0 =A0 | =A0 34 ++++++++++++++++++++++++++++++++=
++
>> =A0include/linux/jbd.h | =A0 =A01 +
>> =A03 files changed, 41 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
>> index 8799207..f2b9a57 100644
>> --- a/fs/jbd/commit.c
>> +++ b/fs/jbd/commit.c
>> @@ -392,6 +392,12 @@ void journal_commit_transaction(journal_t *jour=
nal)
>> =A0 =A0 =A0 jbd_debug (3, "JBD: commit phase 1\n");
>>
>> =A0 =A0 =A0 /*
>> + =A0 =A0 =A0* Clear revoked flag to reflect there is no revoked buf=
fers
>> + =A0 =A0 =A0* in the next transaction which is going to be started.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 journal_clear_buffer_revoked_flags(journal);
>> +
>> + =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Switch to a new revoke table.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 journal_switch_revoke_table(journal);
>> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
>> index 034eb82..501d363 100644
>> --- a/fs/jbd/revoke.c
>> +++ b/fs/jbd/revoke.c
>> @@ -47,6 +47,10 @@
>> =A0 * =A0 overwriting the new data. =A0We don't even need to clear t=
he revoke
>> =A0 * =A0 bit here.
>> =A0 *
>> + * We cache revoke status of a buffer in the current transaction in=
 b_states
>> + * bits. =A0As the name says, revokevalid flag indicates that the c=
ached revoke
>> + * status of a buffer is valid and we can rely on the cached status=
=2E
>> + *
>> =A0 * Revoke information on buffers is a tri-state value:
>> =A0 *
>> =A0 * RevokeValid clear: =A0 =A0 =A0 =A0no cached revoke status, nee=
d to look it up
>> @@ -474,6 +478,36 @@ int journal_cancel_revoke(handle_t *handle, str=
uct journal_head *jh)
>> =A0 =A0 =A0 return did_revoke;
>> =A0}
>>
>> +/*
>> + * journal_clear_revoked_flag clears revoked flag of buffers in
>> + * revoke table to reflect there is no revoked buffers in the next
>> + * transaction which is going to be started.
>> + */
>> +void journal_clear_buffer_revoked_flags(journal_t *journal)
>> +{
>> + =A0 =A0 struct jbd_revoke_table_s *revoke =3D journal->j_revoke;
>> + =A0 =A0 int i =3D 0;
>> +
>> + =A0 =A0 for (i =3D 0; i < revoke->hash_size; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct list_head *hash_list;
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct list_head *list_entry;
>> + =A0 =A0 =A0 =A0 =A0 =A0 hash_list =3D &revoke->hash_table[i];
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(list_entry, hash_list) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct jbd_revoke_record_s=
 *record;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 record =3D (struct jbd_rev=
oke_record_s *)list_entry;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D __find_get_block(jo=
urnal->j_fs_dev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 record->blocknr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 journal->j_blocksize);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bh) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buff=
er_revoked(bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __brelse(b=
h);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +}
>> +
>> =A0/* journal_switch_revoke table select j_revoke for next transacti=
on
>> =A0 * we do not want to suspend any processing until all revokes are
>> =A0 * written -bzzz
>> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
>> index 0f9f0b6..5aa964e 100644
>> --- a/include/linux/jbd.h
>> +++ b/include/linux/jbd.h
>> @@ -918,6 +918,7 @@ extern int =A0 =A0 =A0 =A0journal_set_revoke(jou=
rnal_t *, unsigned int, tid_t);
>> =A0extern int =A0 journal_test_revoke(journal_t *, unsigned int, tid=
_t);
>> =A0extern void =A0journal_clear_revoke(journal_t *);
>> =A0extern void =A0journal_switch_revoke_table(journal_t *journal);
>> +extern void =A0journal_clear_buffer_revoked_flags(journal_t *journa=
l);
>>
>> =A0/*
>> =A0 * The log thread user interface:
>> --
>> 1.7.5.1
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
