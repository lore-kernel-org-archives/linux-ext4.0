From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 00/19] vfs: hot data tracking
Date: Mon, 29 Oct 2012 20:31:45 +0800
Message-ID: <CAEH94LjASvpA_q4zTURR7A+EaDdVm3SSFOGgnwH6EXeH0pzz8g@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<m2boflr2o4.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58511 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2J2Mbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 08:31:47 -0400
In-Reply-To: <m2boflr2o4.fsf@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 6:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> zwu.kernel@gmail.com writes:
>>
>> TODO List:
>>
>>  1.) Need to do scalability or performance tests.
>
> You're changing some of the most performance critical code in the
> kernel. This step is absolutely not optional.
ah, i know, but now i need to make sure all the codes are correct at
first, then do these tests.

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only



-- 
Regards,

Zhi Yong Wu
