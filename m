From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Thu, 3 Aug 2017 20:55:30 -0500
Message-ID: <0fee91d8-d58c-b03b-79f1-7956619c1a0f@redhat.com>
References: <20170802084855.52xnbunchkggipbz@linux>
 <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
 <20170803013433.qki2jn7jg3j4fjcs@hqi2-mobl3.ccr.corp.intel.com>
 <c2c93913-9d4e-8a50-f7d3-1c88db7595f2@gmail.com>
 <20170804014927.edt3ulvqi22qsbem@haikuoyu-mobl4.ccr.corp.intel.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>,
        Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751916AbdHDBzc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Aug 2017 21:55:32 -0400
In-Reply-To: <20170804014927.edt3ulvqi22qsbem@haikuoyu-mobl4.ccr.corp.intel.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/3/17 8:49 PM, Dai Xiang wrote:
> On Thu, Aug 03, 2017 at 09:27:34AM +0300, Nikolay Borisov wrote:


>>> What the difference between them? Does it mean above link has
>>> abandoned?

(it has)

>> SGI have essentially abandoned all xfs-related infrastructure hosting.
>> As a result the mailing list got moved to kernel.org infrastructure and
>> the development branches as well. I'd suggest to always use the xfs
>> repos hosted on git.kernel.org
> 
> I want to install xfsprogs to a specified path but i do not find
> configure but configure.ac, how can i use it?

# make configure
# ./configure <options>

-Eric
