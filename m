From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/2] jbd: allocate transacion from special cache
Date: Mon, 14 Nov 2011 07:22:03 -0800
Message-ID: <CAE0An6csGmxsnUVtwpHSD-1hOqBe_h2vGUFHHCLAnX0=-0JONw@mail.gmail.com>
References: <1321183772-6181-1-git-send-email-xiaoqiangnk@gmail.com> <20111114125357.GH5230@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42415 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1KNPWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 10:22:24 -0500
Received: by gyc15 with SMTP id 15so4978086gyc.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Nov 2011 07:22:24 -0800 (PST)
In-Reply-To: <20111114125357.GH5230@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 14, 2011 at 4:53 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 13-11-11 19:29:31, Yongqiang Yang wrote:
>> transaction_t is 100 bytes under 32-bit systems. Transactions
>> allocated from general cache comsume 128 bytes. This patch
>> lets jbd allocates transacion from special cache.
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> =A0Space saving isn't probably a good argument here since the number =
of
> transactions on the system is going to be rather low (a couple per ex=
t3
> filesystem). The reason why I wanted this change for JBD2 is that it =
makes
> debugging of memory corruption of a transaction structure much easier=
 (and
> I've been tracking down issues like this several times already).
>
> That being said, I don't find strong need to have this in ext3 and th=
us
> I'll take the change in jbd/ext3

I had submitted a similar patch for ext3, but it was rejected by
Andrew Morton. http://lists.openwall.net/linux-ext4/2011/06/13/15

> if Ted takes the similar change to
> jbd2/ext4 to keep compatibility. Manish Katiyar was working on it
> (http://comments.gmane.org/gmane.comp.file-systems.ext4/25884) but it=
 seems
> it wasn't merged yet.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
Honza
>
>> ---
>> =A0fs/jbd/checkpoint.c =A0| =A0 =A02 +-
>> =A0fs/jbd/journal.c =A0 =A0 | =A0 =A03 +++
>> =A0fs/jbd/transaction.c | =A0 31 +++++++++++++++++++++++++++++--
>> =A0include/linux/jbd.h =A0| =A0 =A05 +++++
>> =A04 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
>> index f94fc48..4d98046 100644
>> --- a/fs/jbd/checkpoint.c
>> +++ b/fs/jbd/checkpoint.c
>> @@ -764,5 +764,5 @@ void __journal_drop_transaction(journal_t *journ=
al, transaction_t *transaction)
>>
>> =A0 =A0 =A0 trace_jbd_drop_transaction(journal, transaction);
>> =A0 =A0 =A0 jbd_debug(1, "Dropping transaction %d, all done\n", tran=
saction->t_tid);
>> - =A0 =A0 kfree(transaction);
>> + =A0 =A0 journal_free_transaction(transaction);
>> =A0}
>> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
>> index 9fe061f..45ca982 100644
>> --- a/fs/jbd/journal.c
>> +++ b/fs/jbd/journal.c
>> @@ -2004,6 +2004,8 @@ static int __init journal_init_caches(void)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D journal_init_journal_head_cache(=
);
>> =A0 =A0 =A0 if (ret =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D journal_init_handle_cache();
>> + =A0 =A0 if (ret =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D journal_init_transaction_cache();
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>> @@ -2012,6 +2014,7 @@ static void journal_destroy_caches(void)
>> =A0 =A0 =A0 journal_destroy_revoke_caches();
>> =A0 =A0 =A0 journal_destroy_journal_head_cache();
>> =A0 =A0 =A0 journal_destroy_handle_cache();
>> + =A0 =A0 journal_destroy_transaction_cache();
>> =A0}
>>
>> =A0static int __init journal_init(void)
>> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
>> index 7e59c6e..20d76f1 100644
>> --- a/fs/jbd/transaction.c
>> +++ b/fs/jbd/transaction.c
>> @@ -30,6 +30,32 @@
>>
>> =A0static void __journal_temp_unlink_buffer(struct journal_head *jh)=
;
>>
>> +static struct kmem_cache *transaction_cache;
>> +int __init journal_init_transaction_cache(void)
>> +{
>> + =A0 =A0 J_ASSERT(!transaction_cache);
>> + =A0 =A0 transaction_cache =3D KMEM_CACHE(transaction_s,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
>> + =A0 =A0 if (transaction_cache)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 return -ENOMEM;
>> +}
>> +
>> +void __init journal_destroy_transaction_cache(void)
>> +{
>> + =A0 =A0 if (transaction_cache) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_destroy(transaction_cache);
>> + =A0 =A0 =A0 =A0 =A0 =A0 transaction_cache =3D NULL;
>> + =A0 =A0 }
>> +}
>> +
>> +void journal_free_transaction(transaction_t *transaction)
>> +{
>> + =A0 =A0 if (unlikely(ZERO_OR_NULL_PTR(transaction)))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 kmem_cache_free(transaction_cache, transaction);
>> +}
>> +
>> =A0/*
>> =A0 * get_transaction: obtain a new transaction_t object.
>> =A0 *
>> @@ -100,11 +126,12 @@ static int start_this_handle(journal_t *journa=
l, handle_t *handle)
>>
>> =A0alloc_transaction:
>> =A0 =A0 =A0 if (!journal->j_running_transaction) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 new_transaction =3D kzalloc(sizeof(*new_tr=
ansaction), GFP_NOFS);
>> + =A0 =A0 =A0 =A0 =A0 =A0 new_transaction =3D kmem_cache_alloc(trans=
action_cache, GFP_NOFS);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!new_transaction) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 congestion_wait(BLK_RW_A=
SYNC, HZ/50);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto alloc_transaction;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(new_transaction, 0, sizeof(*new_tra=
nsaction));
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 jbd_debug(3, "New handle %p going live.\n", handle);
>> @@ -233,7 +260,7 @@ repeat_locked:
>> =A0 =A0 =A0 lock_map_acquire(&handle->h_lockdep_map);
>> =A0out:
>> =A0 =A0 =A0 if (unlikely(new_transaction)) =A0 =A0 =A0 =A0 =A0/* It'=
s usually NULL */
>> - =A0 =A0 =A0 =A0 =A0 =A0 kfree(new_transaction);
>> + =A0 =A0 =A0 =A0 =A0 =A0 journal_free_transaction(new_transaction);
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
>> index c7acdde..0f9f0b6 100644
>> --- a/include/linux/jbd.h
>> +++ b/include/linux/jbd.h
>> @@ -807,6 +807,11 @@ journal_write_metadata_buffer(transaction_t =A0=
 =A0 =A0 =A0*transaction,
>> =A0/* Transaction locking */
>> =A0extern void =A0 =A0 =A0 =A0 =A0__wait_on_journal (journal_t *);
>>
>> +/* Transaction cache support */
>> +extern void journal_destroy_transaction_cache(void);
>> +extern int =A0journal_init_transaction_cache(void);
>> +extern void journal_free_transaction(transaction_t *);
>> +
>> =A0/*
>> =A0 * Journal locking.
>> =A0 *
>> --
>> 1.7.5.1
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
