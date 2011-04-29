From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Sat, 30 Apr 2011 03:42:07 +0800
Message-ID: <BANLkTikQ+-WVzntJgQS=Po-YOxWvc-JN-Q@mail.gmail.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
	<4DB71844.5030103@linux.vnet.ibm.com>
	<BANLkTi=7VsvPGztFtAOFh5trGZ0dHH7rWQ@mail.gmail.com>
	<4DB7B8F7.9020306@linux.vnet.ibm.com>
	<BANLkTikWzUgmiRQ6_g+UKjbB5QNSBDnRog@mail.gmail.com>
	<4DB9C537.9060100@linux.vnet.ibm.com>
	<4DBB0EAB.1090800@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63441 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1D2TmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2011 15:42:08 -0400
Received: by vws1 with SMTP id 1so3001527vws.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2011 12:42:08 -0700 (PDT)
In-Reply-To: <4DBB0EAB.1090800@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 30, 2011 at 3:16 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/28/2011 12:51 PM, Allison Henderson wrote:
>>
>> On 4/27/2011 11:05 PM, Yongqiang Yang wrote:
>>>
>>> Hi Allison,
>>>
>>> Could you send punch hole patch and fsx(if you modified it) to me? =
I
>>> can not reproduce the bug on my system without punch hole.
>>>
>>> Thank you,
>>> Yongqiang.
>>>
>>
>> Sure, I have a patch for fsx to enable fallocate, and another patch =
that
>> adds punch hole to the test suite. Right now I'm just working on
>> getting our patches through the fsx that only has fallocate enabled.=
 I
>> thought it might be best if we work out all the bugs with that first
>> before we deal with the more complex tests.
>>
>> Also, I have a debug patch that fits on top of the punch hole patch.
>> Initially I hadn't planned to send it out, but maybe it might help y=
ou
>> so I will include it too.
>>
>> Allison Henderson
>
> Hi all,
>
> Just some updates on this issue. =A0We are currently still trying to =
track
> down all the remaining bugs, and I hadn't planed on sending out anoth=
er
> version of punch hole until we caught them all, but there is another
> suggestion to re-order the patch sets such that the RFC patch set app=
lies on
> top of the punch hole set.
>
> In the updated punch hole patch set that I have not yet sent out, the
> modifications to the split extents routine have been dropped (patch 2=
/6 in
> the punch hole v5 patch set), because those changes were being done i=
n the
> underlying RFC patch set. =A0If we re-order the patch sets, I would h=
ave to
> retain the split extents modifications, which means that the RFC set =
would
> have to be modified to deal with that.
>
> I did think of one other option though. =A0There were two versions of=
 the RFC
> patch set, and we only had to make a small modification to the first =
RFC set
> to make it work. After that, I didnt have any trouble with any of the=
 test
> cases. =A0So a third option would be to push forward with an updated =
version
> of the first RFC set. =A0That would save Yongqaing from having to go =
back and
> deal with patch 2/6 of punch hole, and then only the remaining code t=
hat
> optimizes zeroing out extents would have to be made to apply on top o=
f punch
> hole. =A0But I wasn't sure if that idea would be preferable to moving=
 the
> entire set on top of punch hole, or if it is just better for us to co=
ntinue
> pushing forward with debugging what we have now. =A0In the end, what =
ever
> combination of sets we choose to do should still be passing all the t=
ests,
> but what would everyone prefer to do? =A0Thx!
Hi,

I think we should push forward with the updated version without
optimization for zeroing out extents.  After split-extent and
punch-hole patches are merged into the tree, I will try to optimize
zeroing out extents.

I will send out the patches Allison has tested well.

Allison, thank you for testing the patches.

Yongqiang.

>
> Allison Henderson
>
>
>
>
>>
>>> On Wed, Apr 27, 2011 at 2:34 PM, Allison Henderson
>>> <achender@linux.vnet.ibm.com> wrote:
>>>>
>>>> On 4/26/2011 9:48 PM, Yongqiang Yang wrote:
>>>>>
>>>>> On Wed, Apr 27, 2011 at 3:08 AM, Allison Henderson
>>>>> <achender@linux.vnet.ibm.com> wrote:
>>>>>>
>>>>>> On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
>>>>>>>
>>>>>>> v0->v1:
>>>>>>> fix a bug in ext4_ext_convert_to_initialized() reported by
>>>>>>> Allison<achender@linux.vnet.ibm.com>.
>>>>>>>
>>>>>>> optimize ext4_ext_convert_to_initialized().
>>>>>>>
>>>>>>> -- factor common code
>>>>>>> These patches factor common code from
>>>>>>> ext4_ext_convert_to_initialized()
>>>>>>> and
>>>>>>> ext4_split_unwritten_extents() so that extent-move-on-write in
>>>>>>> snapshot
>>>>>>> and
>>>>>>> punch hole can be built on the common code.
>>>>>>>
>>>>>>> -- optimization
>>>>>>> the 4th and the 5th patch optimize ext4_ext_convert_to_initiali=
zed()
>>>>>>> by
>>>>>>> zeroing out in memory.
>>>>>>>
>>>>>>>
>>>>>>> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and=
 left.
>>>>>>> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
>>>>>>> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten=
=2E
>>>>>>> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
>>>>>>> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initializ=
ed().
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-ext4" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.ht=
ml
>>>>>>
>>>>>> Hi there,
>>>>>>
>>>>>> Just an update on your patch set. Im am working on getting the p=
unch
>>>>>> hole
>>>>>> patch to work with this new set, but I'm am having trouble getti=
ng it
>>>>>> through the stress test. It gets up to around 48265 file
>>>>>> operations, and
>>>>>> then hangs. So I am currently trying to narrow down the problem.=
 It
>>>>>> looks
>>>>>> like it does it with or with out the extra punch hole patches, b=
ut you
>>>>>> may
>>>>>> need to enable fallocate in the fsx Makefile to recreate the
>>>>>> problem. I
>>>>>> will keep you posted if I find any more clues.
>>>>>
>>>>> Hi,
>>>>>
>>>>> Could you tell me how to get fsx? I can not find that.
>>>>
>>>> Hi there,
>>>>
>>>> I believe you can find it in both xfstests and ltp. The one I am u=
sing I
>>>> got from xfstests here:
>>>>
>>>> http://xfs.org/index.php/Getting_the_latest_source_code
>>>>
>>>> Once you have it configured and built, there is a sub folder calle=
d ltp.
>>>> Execute this command from that folder:
>>>>
>>>> ./fsx -d -b 1 -N 100000 -S 1 /mnt/ext4MntPt/holePunch/testFile
>>>>
>>>> Where "/mnt/ext4MntPt/holePunch/testFile" is a file on an ext4 fil=
e
>>>> system.
>>>> It should then try to run through 100000 random file operations, b=
ut get
>>>> stuck on number 48256.
>>>>
>>>> If you do not see any fallocate operations running, you may have t=
o go
>>>> enable it in the ltp/Makefile. I had to change "ifeq ($(HAVE_FALLO=
CATE),
>>>> true)" to "ifeq ($(HAVE_FALLOCATE), yes)" to allow the extra
>>>> fallocate code
>>>> to compile in. Let me know if you have any trouble recreating the =
bug.
>>>>
>>>>>
>>>>> Thank you,
>>>>> Yongqiang.
>>>>>>
>>>>>> Allison Henderson
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
