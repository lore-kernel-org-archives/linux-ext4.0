From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Fri, 12 Aug 2011 08:45:43 -0700
Message-ID: <CAO81RMYcvpd2--Y-u2xOb2+3U=fOK2UtaW7d9iP43_u38hYgZA@mail.gmail.com>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com>
	<BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
	<alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
	<4E44E374.7080103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:8667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1HLPpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 11:45:47 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p7CFjjK2032703
	for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 08:45:45 -0700
Received: from qyk38 (qyk38.prod.google.com [10.241.83.166])
	by wpaz21.hot.corp.google.com with ESMTP id p7CFjhb7003163
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 08:45:44 -0700
Received: by qyk38 with SMTP id 38so474000qyk.5
        for <linux-ext4@vger.kernel.org>; Fri, 12 Aug 2011 08:45:43 -0700 (PDT)
In-Reply-To: <4E44E374.7080103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I don't know much about data=3Djournal, but I've been running xfstests
with it, and it's a disaster, given that data=3Djournal doesn't support
O_DIRECT.  What kind of testing do people do on data=3Djournal?

And worse, I consistently crash my machine running xfstests 074 on a
data=3Djournal partition.  I just repeated this to make sure, on
3.1.0-rc1; I've also seen it with 3.0.0.  There's a BUG_ON firing in
jbd2_journal_dirty_metadata():

[ 2174.697692] ------------[ cut here ]------------
[ 2174.698627] kernel BUG at fs/jbd2/transaction.c:1112!
[ 2174.698627] invalid opcode: 0000 [#1] SMP
[ 2174.698627] CPU 11
=2E..
[ 2174.698627] Call Trace:
[ 2174.698627]  [<ffffffff8127f9a3>] __ext4_handle_dirty_metadata+0x83/=
0x120
[ 2174.698627]  [<ffffffff8127fd1e>] ? __ext4_journal_get_write_access+=
0x3e/0x80
[ 2174.698627]  [<ffffffff81253a78>] __ext4_journalled_writepage+0x338/=
0x3e0
[ 2174.698627]  [<ffffffff81254244>] ext4_writepage+0x234/0x2f0
[ 2174.698627]  [<ffffffff81158327>] __writepage+0x17/0x40
[ 2174.698627]  [<ffffffff811597ae>] write_cache_pages+0x1fe/0x650

This is at the J_ASSERT_JH below:

	/*
	 * Metadata already on the current transaction list doesn't
	 * need to be filed.  Metadata on another transaction's list must
	 * be committing, and will be refiled once the commit completes:
	 * leave it alone for now.
	 */
	if (jh->b_transaction !=3D transaction) {
		JBUFFER_TRACE(jh, "already on other transaction");
		J_ASSERT_JH(jh, jh->b_transaction =3D=3D
					journal->j_committing_transaction);      <=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
		J_ASSERT_JH(jh, jh->b_next_transaction =3D=3D transaction);
		/* And this case is illegal: we can't reuse another
		 * transaction's data buffer, ever. */
		goto out_unlock_bh;
	}

Curt

On Fri, Aug 12, 2011 at 1:25 AM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> On 08/12/2011 09:16 AM, Lukas Czerner wrote:
>>
>> On Thu, 11 Aug 2011, Andreas Dilger wrote:
>>
>>> On 2011-08-11, at 9:01 AM, Lukas Czerner wrote:
>>>>
>>>> On Tue, 28 Jun 2011, Lukas Czerner wrote:
>>>>>
>>>>> Data journalling mode (data=3Djournal) is known to be neglected b=
y
>>>>> developers and only minority of people is actually using it. This
>>>>> mode is also less tested than the other two modes by the develope=
rs.
>>>>>
>>>>> This creates a dangerous combination, because the option which se=
ems
>>>>> *safer* is actually less safe the others. So this commit adds a w=
arning
>>>>> message in case that data=3Djournal mode is used, so the user is =
informed
>>>>> that the mode might be removed in the future.
>>>>
>>>> Any comments on this ? Is that feasible to remove is someday ?
>>>
>>> I'm less in favour of removing data=3Djournal. =A0Jan made some fix=
es to
>>> data=3Djournal mode in the last few weeks, which means that people =
are
>>> still using this.
>>
>> I think that Jan was actually the one who was in favour of this chan=
ge
>> IIRC. But you're right that there are still some (very little possib=
ly?)
>> users of this. But this change does not remove it, but just let the
>> users know that it might be removed someday, hence discouraging them=
 from
>> using it.
>>
>> Also we were discussing that several times, so I think that letting
>> users know that we are considering it is a good thing.
>>
>> Thanks!
>> -Lukas
>
> I think that this will be very useful to have - users should definite=
ly
> chime in when they see this warning if they are using data journal mo=
de.
>
> The only work load that I know that benefits from a performance point=
 of
> view is one which involves an fsync() heavy, small file creation work=
load.
> =A0Any workload with larger files tends to lose roughly 50% of the wr=
ite
> bandwidth under streaming writes since we end up writing everything t=
wice.
>
> Regards,
>
> Ric
>
>
>>
>>>>> Signed-off-by: Lukas Czerner<lczerner@redhat.com>
>>>>> ---
>>>>> fs/ext4/super.c | =A0 =A05 +++++
>>>>> 1 files changed, 5 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>>>> index 9ea71aa..9d189cf 100644
>>>>> --- a/fs/ext4/super.c
>>>>> +++ b/fs/ext4/super.c
>>>>> @@ -1631,6 +1631,11 @@ static int parse_options(char *options, st=
ruct
>>>>> super_block *sb,
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sbi->s_min_batch_t=
ime =3D option;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_data_journal:
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(sb, KERN_W=
ARNING,
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"Using data=3Djournal may be removed in
>>>>> the "
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"future. Please, contact "
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"linux-ext4@vger.kernel.org if you are
>>>>> "
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"using this feature.");
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data_opt =3D EXT4_=
MOUNT_JOURNAL_DATA;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto datacheck;
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_data_ordered:
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
