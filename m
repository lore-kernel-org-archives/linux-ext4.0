From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: BUG_ON triggered in ext4_mb_complex_scan_group()
Date: Mon, 5 Apr 2010 13:01:31 +0800
Message-ID: <i2gac8f92701004042201gbe239f33la21b31828752fd3c@mail.gmail.com>
References: <m2uac8f92701004042130o76a81f3az89d538ebe0afea31@mail.gmail.com>
	 <4BB968B6.1060005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42553 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0DEFBe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Apr 2010 01:01:34 -0400
Received: by gyg13 with SMTP id 13so1867612gyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 04 Apr 2010 22:01:33 -0700 (PDT)
In-Reply-To: <4BB968B6.1060005@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/5, Eric Sandeen <sandeen@redhat.com>:
> jing zhang wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Mon Apr 5 12:10:50     2010
>>
>> BUG_ON is triggered at [line:1762] in ext4_mb_complex_scan_group(),
>
> Do you have a test case which can trigger this BUG_ON?
>
> -Eric

No I do not have.

But you can check [line: 1762] and [line: 1321].

And please info me the result, if you like, after check.

                - zj
