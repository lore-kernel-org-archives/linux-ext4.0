From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Thu, 12 Jun 2008 21:35:25 +0100
Message-ID: <e9e943910806121335g4bd858bga91e2d336f5b9760@mail.gmail.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
	 <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
	 <1213298827.6382.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, "Andreas Dilger" <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:47723 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYFLUf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 16:35:26 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3771074wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 13:35:26 -0700 (PDT)
In-Reply-To: <1213298827.6382.2.camel@norville.austin.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/12 Dave Kleikamp <shaggy@linux.vnet.ibm.com>:
>> Whoops, I was matching the fields in ex4_inode, but I should have been
>> looking at ext4_inode_info. Shouldn't sparse have complained about
>> that?
>
> It does, but not by default.  You need to run sparse with
> -D__CHECK_ENDIAN__
>
> I use this alias:
> make_sparse is aliased to `make C=2 CF="-D__CHECK_ENDIAN__"'

That does the trick nicely, thanks!

> Shaggy

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
