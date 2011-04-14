From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH REC 0/3] ext4:Factor common code from convert and split unwritten.
Date: Thu, 14 Apr 2011 17:36:22 +0300
Message-ID: <BANLkTin0Vk-Q3jXV4rcJDkTPW9UVcB_reg@mail.gmail.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	<20110414141424.GG3682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	achender@linux.vnet.ibm.com, cmm@us.ibm.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59139 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab1DNOgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 10:36:23 -0400
Received: by ewy4 with SMTP id 4so471710ewy.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 07:36:22 -0700 (PDT)
In-Reply-To: <20110414141424.GG3682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 5:14 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 13, 2011 at 10:40:48PM -0700, Yongqiang Yang wrote:
>> These patches factor common code from ext4_ext_convert_to_initialize=
d() and
>> ext4_split_unwritten_extents(), so that extent-move-on-write in snap=
shot and
>> punch-hole can be built on the common code as well.
>>
>> ext4:Add a function merging extent right and left.
>> ext4:Add two functions splitting an extent.
>> ext4:Reimplement convert and split_unwritten.
>
> Hi Yongqiang,
>
> I'd like to hear back from Mingming and Allison about whether these
> patches conflict with their punch patches, since my understanding was
> they were planning on doing very similar things (and at least would b=
e
> working in the very similar parts of the code).
>
> I agree that the extents code here could definitely use this cleanup,
> and I'm really glad that you worked on this; thank you! =A0I just wan=
t
> to make sure work you are doing is coordinated with the work that
> Allison and Mingming are working on.
>

I did tell Mingming the patches are coming her way on LSF,
so she should be expecting them.
I hope Allison and Mingming like the results too :-)

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
