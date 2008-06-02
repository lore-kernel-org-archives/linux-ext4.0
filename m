From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix use of uninitialized data
Date: Mon, 02 Jun 2008 09:23:32 -0500
Message-ID: <48440264.7090000@redhat.com>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080602000842.GA24339@mit.edu> <4843F8C0.7060503@redhat.com> <20080602141719.GA20714@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, alex@clusterfs.com, adilger@sun.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYFBO1C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 10:27:02 -0400
In-Reply-To: <20080602141719.GA20714@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Jun 02, 2008 at 08:42:24AM -0500, Eric Sandeen wrote:

>> so it's fine... but why are we carrying around a field in the sbi to
>> hold a constant that cannot be changed runtime?
> 
> We can tune that via MB_PROC_FOPS(group_prealloc);

MB_PROC_VALUE_WRITE()....

ah, cleverly hidden from cscope with a macro.  :)

Ok, so technically then this could be big enough to overflow fe_len:

        value = simple_strtol(str, NULL, 0);                    \
        if (value <= 0)                                         \
                return -ERANGE;                                 \
        sbi->s_mb_##name = value;                               \


but I guess it's probably not the first thing we need to worry about.

-Eric
