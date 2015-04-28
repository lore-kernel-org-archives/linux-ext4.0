From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
 small fs
Date: Tue, 28 Apr 2015 10:46:12 -0500
Message-ID: <553FAB44.9050009@redhat.com>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com> <553ABAF0.2020702@redhat.com> <D2BC34F2-AB5D-4923-A2D6-28CEC2807C9A@dilger.ca> <20150427161451.GA22448@quack.suse.cz> <553E6277.3040800@redhat.com> <20150428122102.GA9955@quack.suse.cz> <alpine.LFD.2.00.1504281423330.2386@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965801AbbD1PqU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2015 11:46:20 -0400
In-Reply-To: <alpine.LFD.2.00.1504281423330.2386@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/28/15 7:24 AM, Luk=E1=9A Czerner wrote:
> On Tue, 28 Apr 2015, Jan Kara wrote:
>=20
>> Date: Tue, 28 Apr 2015 14:21:02 +0200
>> From: Jan Kara <jack@suse.cz>
>> To: Eric Sandeen <sandeen@redhat.com>
>> Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
>>     Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
>> Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt bloc=
ks on
>>     small fs
>>
>> On Mon 27-04-15 11:23:19, Eric Sandeen wrote:
>>> On 4/27/15 11:14 AM, Jan Kara wrote:
>>>> On Fri 24-04-15 22:25:06, Andreas Dilger wrote:
>>>>> On Apr 24, 2015, at 3:51 PM, Eric Sandeen <sandeen@redhat.com> wr=
ote:
>>>>>> On 3/25/15 5:46 AM, Lukas Czerner wrote:
>>>>>>> Currently we're unable to online resize very small (smaller tha=
n 32 MB)
>>>>>>> file systems with 1k block size because there is not enough spa=
ce in the
>>>>>>> journal to put all the reserved gdt blocks.
>>>>>>
>>>>>> So, I'll get to the patch review if I need to, but this all seem=
ed a little
>>>>>> odd; this is a regression, so do we really need to restrict thin=
gs at mkfs
>>>>>> time?
>>>>>>
>>>>>> On the userspace side, things were ok until:
>>>>>>
>>>>>> 9f6ba88 resize2fs: add support for new in-kernel online resize i=
octl
>>>>>>
>>>>>> and even with that, on the kernelspace side, things were ok unti=
l:
>>>>>>
>>>>>> 8f7d89f jbd2: transaction reservation support
>>>>>>
>>>>>> I guess I'm trying to understand why that jbd2 commit regressed =
this.
>>>>>> I've not been paying enough attention to ext4 lately.  ;)
>>>>>>
>>>>>> I mean, the threshold got chopped in half:
>>>>>>
>>>>>> -       if (nblocks > journal->j_max_transaction_buffers) {
>>>>>> +       /*
>>>>>> +        * 1/2 of transaction can be reserved so we can practica=
lly handle
>>>>>> +        * only 1/2 of maximum transaction size per operation
>>>>>> +        */
>>>>>> +       if (WARN_ON(blocks > journal->j_max_transaction_buffers =
/ 2)) {
>>>>>>                printk(KERN_ERR "JBD2: %s wants too many credits =
(%d > %d)\n",
>>>>>> -                      current->comm, nblocks,
>>>>>> -                      journal->j_max_transaction_buffers);
>>>>>> +                      current->comm, blocks,
>>>>>> +                      journal->j_max_transaction_buffers / 2);
>>>>>>                return -ENOSPC;
>>>>>>        }
>>>>>>
>>>>>> so it's clear why the behavior changed, I guess, but it feels li=
ke I
>>>>>> must be missing something here.
>>>>>
>>>>> Is there some way to reserve these journal blocks only in the cas=
e of
>>>>> delalloc usage?  This has caused a performance regression with Lu=
stre
>>>>> servers on 3.10 kernels because the journal commits twice as ofte=
n.
>>>>> We've worked around this for now by doubling the journal size, bu=
t it
>>>>> seems a bit of a hack since we can never use the whole journal an=
ymore.
>>>>   Hum, so the above hunk only limits maximum number of credits use=
d by a
>>>> single handle. Multiple handles can still consume upto maximum tra=
nsaction
>>>> size buffers (at least that's the intention :). So I don't see how=
 that can
>>>> cause the problem you describe.  What can happen though is that th=
ere are
>>>> quite a few outstanding reserved handles and so we have to reserve=
 space
>>>> for them in the running transaction. Do you use dioread_nolock opt=
ion? That
>>>> enables the use of reserved handles in ext4 for conversion of unwr=
itten
>>>> extents...
>>>
>>> You're probably asking Andreas, but just in case, for my testcase, =
it's
>>> all defaults & standard options.
>>>
>>> i.e. just this fails, after the above commit, whereas it worked bef=
ore.
>>>
>>> mkfs.ext4 /dev/sda 20M
>>> mount /dev/sda /mnt/test
>>> resize2fs /dev/sda 200M
>>   Yeah, I understand your failure - transaction reservation has redu=
ced
>> max transaction size to a half. After that your fs resize exceeds ma=
x
>> transaction size and we are in trouble. I'd prefer solution for that=
 to be
>> in resize code though because it's really a corner case and I wouldn=
't like
>> to slow down the common transaction start path for it...
>=20
> Hi Jan,
>=20
> if you have not already, please see the patch which started the
> discussion.

It just doesn't feel right to me to place limits on fs geometry for thi=
s
reason.  We could, but it seems like a stopgap.  Can we modify the
resize code so that it doesn't need such a large transaction?

In the "old" resize world, I think we played tricks with restarting
transactions, because until the resize was complete and superblocks wer=
e
updated, it was ok if we lost updates to new block groups (or something
like that...) i.e. we didn't need one giant atomic update of the filesy=
stem.

Maybe we can do something similar here?  I've kind of lost track
of how resize is working now, TBH.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
