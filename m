From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: remove unneeded variable.
Date: Sun, 20 Nov 2011 06:53:23 +0900
Message-ID: <CAKYAXd8BdKXOPEV0d4hN27Mb5kDbEfYnhcF5+Lxcw2nFkCKFpw@mail.gmail.com>
References: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
	<4EC80D6E.3090404@linux.vnet.ibm.com>
	<4EC81AF1.2080108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EC81AF1.2080108@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2011/11/20 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> On 11/20/2011 01:41 AM, Srivatsa S. Bhat wrote:
>> On 11/11/2011 08:32 PM, Namjae Jeon wrote:
>>> ret2 is not needed in ext4_flush_completed_IO().
>>>
>>
>> Not needed? I went through the code briefly, and I don't agree.
>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>>> ---
>>> =C2=A0fs/ext4/fsync.c | =C2=A0 =C2=A05 +----
>>> =C2=A01 files changed, 1 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
>>> index 00a2cb7..40397ac 100644
>>> --- a/fs/ext4/fsync.c
>>> +++ b/fs/ext4/fsync.c
>>> @@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
>>> =C2=A0 =C2=A0 =C2=A0struct ext4_inode_info *ei =3D EXT4_I(inode);
>>> =C2=A0 =C2=A0 =C2=A0unsigned long flags;
>>> =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
>>> - =C2=A0 =C2=A0int ret2 =3D 0;
>>>
>>> =C2=A0 =C2=A0 =C2=A0dump_completed_IO(inode);
>>> =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(&ei->i_completed_io_lock, fla=
gs);
>>> @@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *ino=
de)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrest=
ore(&ei->i_completed_io_lock, flags);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ext4_end_io=
_nolock(io);
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0)
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0ret2 =3D ret;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsave(&=
ei->i_completed_io_lock, flags);
>>> =C2=A0 =C2=A0 =C2=A0}
>>> =C2=A0 =C2=A0 =C2=A0spin_unlock_irqrestore(&ei->i_completed_io_lock=
, flags);
>>> - =C2=A0 =C2=A0return (ret2 < 0) ? ret2 : 0;
>>> + =C2=A0 =C2=A0return (ret < 0) ? ret : 0;
>>> =C2=A0}
>>
>> Please note that there is a while loop involved here. Which means, t=
hat ret2
>> is used to store the last negative value of ret. And due to the loop=
, ret can
>> be over-written in the next loop iteration, which we can afford, bec=
ause we
>> have already stored what we need to save, in ret2. And this ret2 val=
ue is used
>> to return appropriate value to the caller.
>>
>
> Actually, what I really meant was, removing ret2 as merely "unneeded"=
 might not
> be the right thing to do because once you apply your patch, you end u=
p altering
> the value returned by this function!
>
> If the return value is indeed wrong in the current code, you should r=
ather
> be saying that this is a bug fix, with appropriate justification IMO.
>
Thanks for your review. My thinking was reaching for to while loop().
I will remember your advice.
Thanks Srivatsa.
> Thanks,
> Srivatsa S. Bhat
>
>
