From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
Date: Wed, 1 Jun 2011 09:37:15 +0300
Message-ID: <BANLkTimoRUrY7xVnamBT=yFPzafhADA=tA@mail.gmail.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
	<BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
	<4DE5CC8E.1090208@redhat.com>
	<4DE5CF6C.4080707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: XFS <xfs@oss.sgi.com>, Sergey Ivanov <sergey57@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49400 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1FAGhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 02:37:17 -0400
In-Reply-To: <4DE5CF6C.4080707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 1, 2011 at 8:34 AM, Eric Sandeen <sandeen@redhat.com> wrote=
:
> On 6/1/11 12:22 AM, Eric Sandeen wrote:
>> On 5/31/11 11:56 PM, Amir Goldstein wrote:
>>> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com> w=
rote:
>>>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>>
>>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>>>> formatted with mkfs.ext4dev.
>>>>> quota tools and various util-linux utils are also aware of ext4de=
v,
>>>>> so ext4dev shares the same capabilities as ext4.
>>>>>
>>>>> While testing on Fedora 15, we encoutered a buggy fsck utility, w=
hich
>>>>> invokes fsck.ext4, even though it was called with -t ext4dev argu=
ment.
>>>>> In our setup fsck.ext4dev knows about new fs features that fsck.e=
xt4
>>>>> doesn't know, so the generic_fs_check fails.
>>>>> Since we have no real use of the extra capabilities provided by f=
sck util,
>>>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>>>>
>>>> Adding ext4dev to every case seems harmless enough. =A0TBH I thoug=
ht I had
>>>> it there already but I guess not.
>>>>
>>>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>>>>
>>>> What issue are you avoiding? =A0wouldn't fsck -t ext4dev invoke fs=
ck.ext4dev anyway?
>>>>
>>>> It seems like it should be harmless, but I don't understand how it=
 helps you.
>>>>
>>>
>>> As I wrote in the patch description, the fsck utility in Fedora 15 =
invokes
>>> fsck.ext4 for some reason when calling fsck -t ext4dev.
>>
>> Oh, right.
>>
>>> this fails because fsck.ext4 doesn't know the snapshot feature.
>>> I didn't debug fsck utility for that. it seemed pointless.
>>
>> Did you file a bug with Fedora? =A0I'd rather fix the root cause tha=
n work around it...
>> Feel free to cc: me on the bug.

No, I didn't file a bug.
In any case, it was Sergey, who tested and reported the problem on F15.

Would you agree to fix the problem in xfstests now, so that F15 users c=
an
test ext4dev and fix the bug in fsck regardless?

>
> RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes fsck.e=
xt4; but this
> is because blkid identifies it as ext4, not ext4dev, despite the test=
_fs flag being set.
>
> ISTR this is due to some tortured logic about when ext4dev isn't ext4=
dev, but
> I don't remember the details... I don't know if this is the same situ=
ation
> you're seeing; just to double check - does blkid correctly identify i=
t as ext4dev
> on F15?


=46or me (on Ubuntu) blkid identifies ext4dev, but maybe the tortured l=
ogic
finds unknown features a justification for declaring ext4dev?
Segrey, can you answer the question for F15?
Did you set FSTYP to ext4dev manually or did blkid identified it for yo=
u?

>
> -Eric
>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
