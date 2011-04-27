From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Wed, 27 Apr 2011 15:19:19 +0800
Message-ID: <BANLkTim2RkarvOg5cai_XpPhwfUK=mT7yw@mail.gmail.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
	<4DB71844.5030103@linux.vnet.ibm.com>
	<BANLkTi=7VsvPGztFtAOFh5trGZ0dHH7rWQ@mail.gmail.com>
	<4DB7B8F7.9020306@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47349 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1D0HTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Apr 2011 03:19:20 -0400
Received: by pvg12 with SMTP id 12so1011419pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2011 00:19:19 -0700 (PDT)
In-Reply-To: <4DB7B8F7.9020306@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 27, 2011 at 2:34 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/26/2011 9:48 PM, Yongqiang Yang wrote:
>>
>> On Wed, Apr 27, 2011 at 3:08 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com> =A0wrote:
>>>
>>> On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
>>>>
>>>> v0->v1:
>>>> =A0 =A0fix a bug in ext4_ext_convert_to_initialized() reported by
>>>> =A0 =A0Allison<achender@linux.vnet.ibm.com>.
>>>>
>>>> =A0 =A0optimize ext4_ext_convert_to_initialized().
>>>>
>>>> -- factor common code
>>>> =A0 =A0These patches factor common code from
>>>> ext4_ext_convert_to_initialized()
>>>> and
>>>> =A0 =A0ext4_split_unwritten_extents() so that extent-move-on-write=
 in
>>>> snapshot
>>>> and
>>>> =A0 =A0punch hole can be built on the common code.
>>>>
>>>> -- optimization
>>>> =A0 =A0the 4th and the 5th patch optimize ext4_ext_convert_to_init=
ialized()
>>>> by
>>>> =A0 =A0zeroing out in memory.
>>>>
>>>>
>>>> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and le=
ft.
>>>> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
>>>> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
>>>> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
>>>> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized(=
).
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>
>>> Hi there,
>>>
>>> Just an update on your patch set. =A0Im am working on getting the p=
unch
>>> hole
>>> patch to work with this new set, but I'm am having trouble getting =
it
>>> through the stress test. =A0It gets up to around 48265 file operati=
ons, and
>>> then hangs. So I am currently trying to narrow down the problem. =A0=
It
>>> looks
>>> like it does it with or with out the extra punch hole patches, but =
you
>>> may
>>> need to enable fallocate in the fsx Makefile to recreate the proble=
m. =A0I
>>> will keep you posted if I find any more clues.
>>
>> Hi,
>>
>> Could you tell me how to get fsx? =A0I can not find that.
>
> Hi there,
>
> I believe you can find it in both xfstests and ltp. =A0The one I am u=
sing I
> got from xfstests here:
>
> http://xfs.org/index.php/Getting_the_latest_source_code
>
> Once you have it configured and built, there is a sub folder called l=
tp.
> =A0Execute this command from that folder:
>
> ./fsx -d -b 1 -N 100000 -S 1 /mnt/ext4MntPt/holePunch/testFile
>
> Where "/mnt/ext4MntPt/holePunch/testFile" is a file on an ext4 file s=
ystem.
> =A0It should then try to run through 100000 random file operations, b=
ut get
> stuck on number 48256.
>
> If you do not see any fallocate operations running, you may have to g=
o
> enable it in the ltp/Makefile. =A0I had to change "ifeq ($(HAVE_FALLO=
CATE),
> true)" to "ifeq ($(HAVE_FALLOCATE), yes)" to allow the extra fallocat=
e code
> to compile in. =A0Let me know if you have any trouble recreating the =
bug.
Thank you.
>
>>
>> Thank you,
>> Yongqiang.
>>>
>>> Allison Henderson
>>>
>>
>>
>>
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
