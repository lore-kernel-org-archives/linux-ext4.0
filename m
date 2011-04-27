From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Wed, 27 Apr 2011 09:14:19 +0800
Message-ID: <BANLkTi=wu6KKukfR9ACt_VAQtYfK77rO1Q@mail.gmail.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com>
	<4DB71844.5030103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61451 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1D0BOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 21:14:20 -0400
Received: by pvg12 with SMTP id 12so847754pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 18:14:19 -0700 (PDT)
In-Reply-To: <4DB71844.5030103@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 27, 2011 at 3:08 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
>>
>> v0->v1:
>> =A0 =A0fix a bug in ext4_ext_convert_to_initialized() reported by
>> =A0 =A0Allison<achender@linux.vnet.ibm.com>.
>>
>> =A0 =A0optimize ext4_ext_convert_to_initialized().
>>
>> -- factor common code
>> =A0 =A0These patches factor common code from ext4_ext_convert_to_ini=
tialized()
>> and
>> =A0 =A0ext4_split_unwritten_extents() so that extent-move-on-write i=
n snapshot
>> and
>> =A0 =A0punch hole can be built on the common code.
>>
>> -- optimization
>> =A0 =A0the 4th and the 5th patch optimize ext4_ext_convert_to_initia=
lized() by
>> =A0 =A0zeroing out in memory.
>>
>>
>> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and left=
=2E
>> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
>> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
>> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
>> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> Hi there,
>
> Just an update on your patch set. =A0Im am working on getting the pun=
ch hole
> patch to work with this new set, but I'm am having trouble getting it
> through the stress test. =A0It gets up to around 48265 file operation=
s, and
> then hangs. So I am currently trying to narrow down the problem. =A0I=
t looks
> like it does it with or with out the extra punch hole patches, but yo=
u may
> need to enable fallocate in the fsx Makefile to recreate the problem.=
 =A0I
> will keep you posted if I find any more clues.
ok. Thank you.
>
> Allison Henderson
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
