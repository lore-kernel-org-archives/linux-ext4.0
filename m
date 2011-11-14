From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext3/4: BUGS in changing journal mode in flight
Date: Mon, 14 Nov 2011 15:08:41 +0800
Message-ID: <CAGBYx2b_Rv_iGM=8mPoh06xhwad_=G1T=98C7X2aghNOBhrWYw@mail.gmail.com>
References: <CAGBYx2YaJZqCgC6akmUm-NF7RgXGZJSyZxeWpW1KYeh09egkbw@mail.gmail.com>
	<20111111152651.GD5050@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47645 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1KNHIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 02:08:42 -0500
Received: by yenr9 with SMTP id r9so4852613yen.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 23:08:41 -0800 (PST)
In-Reply-To: <20111111152651.GD5050@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 11, 2011 at 11:26 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> On Fri 11-11-11 16:20:21, Yongqiang Yang wrote:
>> Both ext3 and ext4 have an attribute 'j', thus users can change
>> journal mode of a file in flight. =A0However, neither ext3 or ext4
>> supports the feature rightly, specifically file systems will be
>> mounted RO due to I/O error in journal. =A0The error happens like th=
is:
> =A0I suppose you have tested this, right?
>
>> when the journal mode of a file is changed from ordered to journaled=
,
>> then data blocks will be revoked in truncate, if the revoked block w=
as
>> allocated as meta blocks last time, then its revoked flag is not
>> cleared, so revoke on a revoked buffer happens, then journal report =
an
>> I/O error.
> =A0So let me check whether I understand the problem: We have a buffer=
 that
> has been previously used for metadata, then truncated (BH_Revoked set=
),
> allocated as data, switched the inode to journal mode, and then delet=
ion of
> the inode causes error because we try to revoke a buffer with BH_Revo=
ked
> set. Nasty.
>
>> Now revoked flag is cleared in get_access, actually it can be cleare=
d
>> immediately after the transaction is closed(non-current transaction)=
=2E
> =A0I'm not sure what you mean by closed but there is a difference bet=
ween a
> BH_Revoked flag and the fact whether the buffer is recorded as revoke=
d in
> the journal. If we concentrate on the flag, which is the problem here=
, then
> the flag seems to be used as "is buffer revoked in the running trasac=
tion".
> Which means we can clear the flag as soon as we are done with adding
> buffers to the transation.
>
>> I can think of 3 solutions addressing the problem.
>>
>> 1. clear revoked flag on a buffer when allocating a block.
>> =A0 =A0 This solution introduces overhead to ordered mode, because w=
e have
>> to look up dev's buffer every time. So I think the solution can be
>> ignored.
>>
>> 2. clear revoked flag in commit_call_back function.
>> =A0 =A0This solution has some overhead too. =A0in ext3 commit_call_b=
ack is
>> not used at all, so changing to ext3 is not trivial.
>>
>> 3. clear revoked flag in write_revoke_table.
>> =A0 =A0IMHO, this solution is the best one. =A0We just need to add a=
 field
>> in in-memory journal super block pointing to the super block of host
>> file system.
>>
>> What's your opinions?
> =A0Hum, maybe journal_switch_revoke_table() would be a better place t=
han
> write_revoke_table() to do the clearing. Or we could just add a separ=
ate
> call just before journal_switch_revoke_table() which will also get a
> superblock as a parameter so that we don't have to store it in the jo=
urnal
> structure.
Sorry for noise.  There is block_device(j_fs_dev) holding client fs in
journal_s, so we can do this easily.

Thanks,
Yongqiang.
>
> =A0Thanks for spotting the problem!
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
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
