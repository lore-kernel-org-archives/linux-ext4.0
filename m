From: Manuel Benitez <rickyb@google.com>
Subject: Re: Tool to view extent metadata
Date: Mon, 13 Jul 2009 08:03:26 -0700
Message-ID: <23904f640907130803w20089c79md6f6ceef54ff8f8e@mail.gmail.com>
References: <23904f640907091517w10608fa4y9b3b8b3a631217c@mail.gmail.com>
	 <20090709225507.GH5073@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:45050 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZGMPD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jul 2009 11:03:29 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n6DF3T5X010835
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 08:03:29 -0700
Received: from pzk42 (pzk42.prod.google.com [10.243.19.170])
	by zps35.corp.google.com with ESMTP id n6DF3QkV011130
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 08:03:27 -0700
Received: by pzk42 with SMTP id 42so1879956pzk.17
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 08:03:26 -0700 (PDT)
In-Reply-To: <20090709225507.GH5073@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas,

Thank you for the reply. I wrote a program that uses FIEMAP to see
what I could get from it. It gives the same information that you can
extract from FIBMAP except that it is much more efficient (one ioctl
call per extent rather than one call per block). Unfortunately, it
does not give much insight into the structure of the metadata, so
there is no way to tell how efficiently the metadata represents the
file (depth of extent tree, number of internal and leaf nodes, etc.).

-Ricky

On Thu, Jul 9, 2009 at 3:55 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Jul 09, 2009 =A015:17 -0700, Manuel Benitez wrote:
>> I'm currently evaluating the ext4 allocator and one thing I've come
>> across is the lack of a tool that displays the exact structure of th=
e
>> extents making up a file. I've found plenty of tools that will tell =
me
>> how many contiguous segments a file contains, but nothing so far to
>> let me see the actual makeup of the extents that map the inode to th=
e
>> blocks that comprise the file. Have I just missed something obvious,
>> or would this be something worth me spending some time doing?
>>
>> If so, one option would be to either modify the stat command or add =
a
>> similar command in debugfs to show the extents from the roots throug=
h
>> the root down to the leafs. Anyone have preferences or opinions?
>
> The "filefrag" tool in recent e2fsprogs should provide such informati=
on,
> using the FIEMAP ioctl to extract extent information from the kernel.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
