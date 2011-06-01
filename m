From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
Date: Wed, 01 Jun 2011 00:34:36 -0500
Message-ID: <4DE5CF6C.4080707@redhat.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>	<4DE5C1FE.8080006@redhat.com> <BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com> <4DE5CC8E.1090208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: XFS <xfs@oss.sgi.com>, Sergey Ivanov <sergey57@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DE5CC8E.1090208@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 6/1/11 12:22 AM, Eric Sandeen wrote:
> On 5/31/11 11:56 PM, Amir Goldstein wrote:
>> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>
>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>>> formatted with mkfs.ext4dev.
>>>> quota tools and various util-linux utils are also aware of ext4dev,
>>>> so ext4dev shares the same capabilities as ext4.
>>>>
>>>> While testing on Fedora 15, we encoutered a buggy fsck utility, which
>>>> invokes fsck.ext4, even though it was called with -t ext4dev argument.
>>>> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
>>>> doesn't know, so the generic_fs_check fails.
>>>> Since we have no real use of the extra capabilities provided by fsck util,
>>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
>>>
>>> Adding ext4dev to every case seems harmless enough.  TBH I thought I had
>>> it there already but I guess not.
>>>
>>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
>>>
>>> What issue are you avoiding?  wouldn't fsck -t ext4dev invoke fsck.ext4dev anyway?
>>>
>>> It seems like it should be harmless, but I don't understand how it helps you.
>>>
>>
>> As I wrote in the patch description, the fsck utility in Fedora 15 invokes
>> fsck.ext4 for some reason when calling fsck -t ext4dev.
> 
> Oh, right.
> 
>> this fails because fsck.ext4 doesn't know the snapshot feature.
>> I didn't debug fsck utility for that. it seemed pointless.
> 
> Did you file a bug with Fedora?  I'd rather fix the root cause than work around it...
> Feel free to cc: me on the bug.

RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes fsck.ext4; but this
is because blkid identifies it as ext4, not ext4dev, despite the test_fs flag being set.

ISTR this is due to some tortured logic about when ext4dev isn't ext4dev, but
I don't remember the details... I don't know if this is the same situation
you're seeing; just to double check - does blkid correctly identify it as ext4dev
on F15?

-Eric

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

