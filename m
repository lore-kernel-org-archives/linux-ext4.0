From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Re: Should we discard jbddirty bit if BH_Freed is set?
Date: Sat, 30 Jan 2010 14:41:07 +0800
Message-ID: <7bb361261001292241t7dda80d8sc5f467677ad34954@mail.gmail.com>
References: <7bb361261001261832wb4f9ac2u96fdb6460aa45fa2@mail.gmail.com>
	 <20100127122333.GA3149@quack.suse.cz>
	 <7bb361261001271723n4fdad0e9l2171aa092baa0523@mail.gmail.com>
	 <20100128125354.GA3124@quack.suse.cz>
	 <7bb361261001281743h1ba743a4iada7f7cce5975eb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00504501416d75f34e047e5c0971
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:61891 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0A3GlL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 01:41:11 -0500
Received: by iwn3 with SMTP id 3so2419560iwn.23
        for <linux-ext4@vger.kernel.org>; Fri, 29 Jan 2010 22:41:09 -0800 (PST)
In-Reply-To: <7bb361261001281743h1ba743a4iada7f7cce5975eb3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--00504501416d75f34e047e5c0971
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi,
   The attached is a patch to fix this problem,
please have a look.

2010/1/29 =B6=A1=B6=A8=BB=AA <dingdinghua85@gmail.com>:
> Hi,
>    I think what we need to do is to distinguish the buffers which can
> be discarded after
> this transaction commits and which we must wait until the next transactio=
n
> commits, and as you wrote, set b_next_transaction to running
> transaction and file them
> into t_forget list is a good way.
>
> 2010/1/28 Jan Kara <jack@suse.cz>:
>>  Hi,
>>
>> On Thu 28-01-10 09:23:43, =B6=A1=B6=A8=BB=AA wrote:
>>>     As you wrote, if T2!=3DT1, then T2 is committing transaction while =
T1
>>>     is running transaction, and if T1 complete commit, we don't care
>>>     about the content of buffers.  But there is a  prerequisite -->"T1
>>>     complete commit", if T1 start commit and another transaction T3
>>>     becomes the new running transaction, T3 may need to reuse T2 log
>>>     space and force checkpoint, and since we have clean the BH_dirty bi=
t
>>>     of buffers after T2 commits, so T2 may be freed before T1 complete
>>>     commit, and unfortunately, T1 doesn't complete commit, so after
>>>     replay, updates of T2 get lost, fs becomes inconsistent.
>>  Hmm, you are right. That could probably happen. It only hits ext3/4 in
>> data=3Djournaled mode but the bug is there. But it's hard to fix it in a
>> reasonable way - if we would just leave the dirty bit set, we will have
>> aliasing problems - buffer B is attached to some page which used to be f=
rom
>> file F, so unmap_underlying_metadata will not find it because it looks o=
nly
>> into page cache the block device, not to the pagecaches of individual
>> files. So if we reallocate the block of B for some other file G before t=
he
>> buffer B is checkpointed, we have two dirty buffers representing the sam=
e
>> block and thus data corruption can happen.
>>  Maybe we could handle them by setting b_next_transaction to the
>> transaction that deleted the buffer (in jbd2_journal_unmap_buffer) and
>> setting buffer freed like we do now. Commit code would handle freed
>> buffers like:
>> If b_next_transaction is set, file buffer to forget list of the next
>> transaction. If b_next_transaction isn't set, clear all dirty bits.
>> What do you think?
>>
>>                                                                Honza
>>
>>> 2010/1/27 Jan Kara <jack@suse.cz>:
>>> >  Hi,
>>> >
>>> > On Wed 27-01-10 10:32:18, =B6=A1=B6=A8=BB=AA wrote:
>>> >>         I'm a little confused about BH_Freed bit. The only place it =
is set
>>> >> is journal_unmap_buffer, which is called by jbd2_journal_invalidatep=
age when
>>> >> we want to truncate a file. Since jbd2_journal_invalidatepage is cal=
led
>>> >> outside of transaction, We can't make sure whether the "add to orpha=
n"
>>> >> operation belongs to committing transaction or not,  so we can't tou=
ch the
>>> >> buffer belongs to committing transaction, instead BH_Freed bit is se=
t to
>>> >> indicate that this buffer can be discarded in running transaction. B=
ut i
>>> >> think we shouldn't clear BH_JBDdirty in jbd2_journal_commit_transact=
ion, as
>>> >> following codes does:
>>> >>                 /* A buffer which has been freed while still being
>>> >>                  * journaled by a previous transaction may end up st=
ill
>>> >>                  * being dirty here, but we want to avoid writing ba=
ck
>>> >>                  * that buffer in the future now that the last use h=
as
>>> >>                  * been committed.  That's not only a performance ga=
in,
>>> >>                  * it also stops aliasing problems if the buffer is =
left
>>> >>                  * behind for writeback and gets reallocated for ano=
ther
>>> >>                  * use in a different page. */
>>> >>                 if (buffer_freed(bh)) {
>>> >>                         clear_buffer_freed(bh);
>>> >>                         clear_buffer_jbddirty(bh);
>>> >>                 }
>>> >> Note that, *We can't make sure "current running transaction" can com=
plete
>>> >> commit work.* If we clear BH_JBDdirty bit here, this buffer may be f=
reed
>>> >> here,  the log space of older transaction may be freed before the "c=
urrent
>>> >> running transaction" complete commit work, and if this happends, fil=
esystem
>>> >> will be inconsistent.
>>> >  Let me sketch the situation here:
>>> > The file F gets truncated. The inode is added to orphan list in some
>>> > transaction T1, only then jbd2_journal_invalidatepage can be called.
>>> > As you wrote above, it can happen that jbd2_journal_invalidatepage on
>>> > buffer B runs when some transaction T2 containing B is being committe=
d and
>>> > in that case we set BH_Freed.  If T2 !=3D T1 - i.e., T2 is being comm=
itted
>>> > and T1 is the running transaction, note that we clear the dirty bit o=
nly
>>> > when T2 is fully committed and we are processing forget list. So buff=
er has
>>> > been properly written to T2 and we just won't write it in the transac=
tion
>>> > T1. And that is fine because as soon as transaction T1 finishes commi=
t, we
>>> > don't care about what happens with buffers of F because the fact that=
 F is
>>> > truncated is recorded and in case of crash we finish truncate during
>>> > journal replay. And if we crash before T1 finishes commit, we don't c=
are
>>> > about contents of T1 either. If T2 =3D=3D T1, the above reasoning app=
lies as
>>> > well and the situation is even simpler.
>>> >
>>> >                                                                Honza
>>> > --
>>> > Jan Kara <jack@suse.cz>
>>> > SUSE Labs, CR
>>> >
>>>
>>>
>>>
>>> --
>>> =B6=A1=B6=A8=BB=AA
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
>>
>
>
>
> --
> =B6=A1=B6=A8=BB=AA
>



--=20
=B6=A1=B6=A8=BB=AA

--00504501416d75f34e047e5c0971
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-Jbd2-delay-discarding-buffers-in-journal_unmap_buff.patch"
Content-Disposition: attachment;
	filename="0001-Jbd2-delay-discarding-buffers-in-journal_unmap_buff.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5217xfh0

RnJvbSBlYjY1NjdkZTU3NmFjNGE5MzM3YzM5NzFhMmQwNTQ5YWY2NGUxNWYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBkaW5nZGluZ2h1YSA8ZGluZ2RpbmdodWFAbnJjaHBjLmFjLmNu
PgpEYXRlOiBTYXQsIDMwIEphbiAyMDEwIDE0OjIzOjI4ICswODAwClN1YmplY3Q6IFtQQVRDSF0g
SmJkMjogZGVsYXkgZGlzY2FyZGluZyBidWZmZXJzIGluIGpvdXJuYWxfdW5tYXBfYnVmZmVyCgpX
ZSBzaG91bGQgZGVsYXkgZGlzY2FyZGluZyBidWZmZXJzIHVudGlsIHdlIGtub3cgdGhhdCAiYWRk
IHRvIG9ycGhhbiIKb3BlcmF0aW9uIGhhcyBkZWZpbml0ZWx5IGJlZW4gY29tbWl0dGVkLCBvdGhl
cndpc2UgdGhlIGxvZyBzcGFjZSBvZgpjb21taXR0aW5nIHRyYW5zYXRpb24gbWF5IGJlIGZyZWVk
IGFuZCByZXVzZWQgYmVmb3JlIHRydW5jYXRlIGdldApjb21taXR0ZWQsIHVwZGF0ZXMgbWF5IGdl
dCBsb3N0IGlmIGNyYXNoIGhhcHBlbnMuCgotLS0KIGZzL2piZDIvY29tbWl0LmMgICAgICB8ICAg
IDYgKysrKy0tCiBmcy9qYmQyL3RyYW5zYWN0aW9uLmMgfCAgIDE4ICsrKysrKysrKystLS0tLS0t
LQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9qYmQyL2NvbW1pdC5jIGIvZnMvamJkMi9jb21taXQuYwppbmRleCAxYmM3
NGI2Li5jNWQxYzdjIDEwMDY0NAotLS0gYS9mcy9qYmQyL2NvbW1pdC5jCisrKyBiL2ZzL2piZDIv
Y29tbWl0LmMKQEAgLTkzNiw4ICs5MzYsMTAgQEAgcmVzdGFydF9sb29wOgogCQkgKiBiZWhpbmQg
Zm9yIHdyaXRlYmFjayBhbmQgZ2V0cyByZWFsbG9jYXRlZCBmb3IgYW5vdGhlcgogCQkgKiB1c2Ug
aW4gYSBkaWZmZXJlbnQgcGFnZS4gKi8KIAkJaWYgKGJ1ZmZlcl9mcmVlZChiaCkpIHsKLQkJCWNs
ZWFyX2J1ZmZlcl9mcmVlZChiaCk7Ci0JCQljbGVhcl9idWZmZXJfamJkZGlydHkoYmgpOworCQkJ
aWYgKCFqaC0+Yl9uZXh0X3RyYW5zYWN0aW9uKSB7CisJCQkJY2xlYXJfYnVmZmVyX2ZyZWVkKGJo
KTsKKwkJCQljbGVhcl9idWZmZXJfamJkZGlydHkoYmgpOworCQkJfQogCQl9CiAKIAkJaWYgKGJ1
ZmZlcl9qYmRkaXJ0eShiaCkpIHsKZGlmZiAtLWdpdCBhL2ZzL2piZDIvdHJhbnNhY3Rpb24uYyBi
L2ZzL2piZDIvdHJhbnNhY3Rpb24uYwppbmRleCBhMDUxMjcwLi4wZDAxOWYxIDEwMDY0NAotLS0g
YS9mcy9qYmQyL3RyYW5zYWN0aW9uLmMKKysrIGIvZnMvamJkMi90cmFuc2FjdGlvbi5jCkBAIC0x
Nzg4LDExICsxNzg4LDggQEAgc3RhdGljIGludCBqb3VybmFsX3VubWFwX2J1ZmZlcihqb3VybmFs
X3QgKmpvdXJuYWwsIHN0cnVjdCBidWZmZXJfaGVhZCAqYmgpCiAJCSAqIHJ1bm5pbmcgdHJhbnNh
Y3Rpb24gaWYgdGhhdCBpcyBzZXQsIGJ1dCBub3RoaW5nCiAJCSAqIGVsc2UuICovCiAJCXNldF9i
dWZmZXJfZnJlZWQoYmgpOwotCQlpZiAoamgtPmJfbmV4dF90cmFuc2FjdGlvbikgewotCQkJSl9B
U1NFUlQoamgtPmJfbmV4dF90cmFuc2FjdGlvbiA9PQotCQkJCQlqb3VybmFsLT5qX3J1bm5pbmdf
dHJhbnNhY3Rpb24pOwotCQkJamgtPmJfbmV4dF90cmFuc2FjdGlvbiA9IE5VTEw7Ci0JCX0KKwkJ
aWYgKGpvdXJuYWwtPmpfcnVubmluZ190cmFuc2FjdGlvbiAmJiBidWZmZXJfamJkZGlydHkoYmgp
KQorCQkJamgtPmJfbmV4dF90cmFuc2FjdGlvbiA9IGpvdXJuYWwtPmpfcnVubmluZ190cmFuc2Fj
dGlvbjsKIAkJamJkMl9qb3VybmFsX3B1dF9qb3VybmFsX2hlYWQoamgpOwogCQlzcGluX3VubG9j
aygmam91cm5hbC0+al9saXN0X2xvY2spOwogCQlqYmRfdW5sb2NrX2JoX3N0YXRlKGJoKTsKQEAg
LTE5NjksNyArMTk2Niw3IEBAIHZvaWQgamJkMl9qb3VybmFsX2ZpbGVfYnVmZmVyKHN0cnVjdCBq
b3VybmFsX2hlYWQgKmpoLAogICovCiB2b2lkIF9famJkMl9qb3VybmFsX3JlZmlsZV9idWZmZXIo
c3RydWN0IGpvdXJuYWxfaGVhZCAqamgpCiB7Ci0JaW50IHdhc19kaXJ0eTsKKwlpbnQgd2FzX2Rp
cnR5LCBqbGlzdDsKIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJoID0gamgyYmgoamgpOwogCiAJSl9B
U1NFUlRfSkgoamgsIGpiZF9pc19sb2NrZWRfYmhfc3RhdGUoYmgpKTsKQEAgLTE5OTEsOCArMTk4
OCwxMyBAQCB2b2lkIF9famJkMl9qb3VybmFsX3JlZmlsZV9idWZmZXIoc3RydWN0IGpvdXJuYWxf
aGVhZCAqamgpCiAJX19qYmQyX2pvdXJuYWxfdGVtcF91bmxpbmtfYnVmZmVyKGpoKTsKIAlqaC0+
Yl90cmFuc2FjdGlvbiA9IGpoLT5iX25leHRfdHJhbnNhY3Rpb247CiAJamgtPmJfbmV4dF90cmFu
c2FjdGlvbiA9IE5VTEw7Ci0JX19qYmQyX2pvdXJuYWxfZmlsZV9idWZmZXIoamgsIGpoLT5iX3Ry
YW5zYWN0aW9uLAotCQkJCWpoLT5iX21vZGlmaWVkID8gQkpfTWV0YWRhdGEgOiBCSl9SZXNlcnZl
ZCk7CisJaWYgKGJ1ZmZlcl9mcmVlZChiaCkpCisJCWpsaXN0ID0gQkpfRm9yZ2V0OworCWVsc2Ug
aWYgKGpoLT5iX21vZGlmaWVkKQorCQlqbGlzdCA9IEJKX01ldGFkYXRhOworCWVsc2UKKwkJamxp
c3QgPSBCSl9SZXNlcnZlZDsKKwlfX2piZDJfam91cm5hbF9maWxlX2J1ZmZlcihqaCwgamgtPmJf
dHJhbnNhY3Rpb24sIGpsaXN0KTsKIAlKX0FTU0VSVF9KSChqaCwgamgtPmJfdHJhbnNhY3Rpb24t
PnRfc3RhdGUgPT0gVF9SVU5OSU5HKTsKIAogCWlmICh3YXNfZGlydHkpCi0tIAoxLjUuNS42Cgo=
--00504501416d75f34e047e5c0971--
