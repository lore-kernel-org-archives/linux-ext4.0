From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
 htree hash algorithms
Date: Fri, 24 Oct 2008 11:25:29 -0700
Message-ID: <49021319.4050302@goop.org>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu> <20081022172221.c1a8c5b5.akpm@linux-foundation.org> <20081023025646.GD10369@mit.edu> <20081023192618.GS3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:54061 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYJXSZa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 14:25:30 -0400
In-Reply-To: <20081023192618.GS3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
>
>> Hmm..... is it considered safe to depend on the userspace limits.h
>> header file?  I guess if we trust that header file to be correct we
>> could check the value of CHAR_MIN and/or CHAR_MAX as defined by
>> limits.h.
>>     
>
> That would likely fail on cross-compiled environments, right?
>   

/usr/include/limits.h uses #include_next to pick up gcc's private 
limits.h, so it should be safe to use in a kernel cross-build 
environment.  (Picking up the compiler's limits.h directly would be better.)

    J
