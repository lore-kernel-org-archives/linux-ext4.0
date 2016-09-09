From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH]:ext4 these lines are too long while reading
Date: Fri, 9 Sep 2016 09:34:14 -0500
Message-ID: <d5dbbe4a-6558-504f-4f42-1cbe9c7b3c3a@redhat.com>
References: <57D281D1.6020208@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: norton <norton.zhu@huawei.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752707AbcIIOeQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Sep 2016 10:34:16 -0400
In-Reply-To: <57D281D1.6020208@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/9/16 4:33 AM, norton wrote:
> Hi, all
> 
> I'm a freshman in ext4 file system and I'm reading its source code now.
> This patch did nothing but make it looks better.(
> some lines are too long in vim :( ).

Aside from Ted's point about not taking patches which simply rewrap
lines, it's worth knowing that the better practice, IMHO, when adding
long text strings is not:

+				ext4_msg(sb, KERN_WARNING, "Remounting file "
+					"system with no journal so "
+					"ignoring journalled data option");

but:

+				ext4_msg(sb, KERN_WARNING,
+"Remounting file system with no journal so ignoring journalled data option");

so that the strings can be found by a grep, if needed, while still
avoiding 120-column lines.

At least that's my time-tested opinion :)

So if you ever find yourself in the position of needing to add a string like
that, or are hitting it as part of other work, it's something to consider.

-Eric


