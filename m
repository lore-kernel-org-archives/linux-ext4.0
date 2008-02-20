From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ext4_find_next_zero_bit needs an aligned address
 on some arch
Date: Wed, 20 Feb 2008 08:49:56 -0600
Message-ID: <47BC3E14.4050708@redhat.com>
References: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYBTOxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 09:53:55 -0500
In-Reply-To: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> ext4_find_next_zero_bit and ext4_find_next_bit needs a long aligned
> address on x8_64. Add mb_find_next_zero_bit and mb_find_next_bit
> and use them in the mballoc.
> 
> Fix: https://bugzilla.redhat.com/show_bug.cgi?id=433286
> 
> Eric Sandeen debugged the problem and suggested the fix.

Also, Ted & Mingming: we probably should get this into 2.6.25; at least
w/ the way the Fedora kernel is configured, ext4 is pretty much DOA w/o
this change.  I'm not sure why it started showing up now, but it is, in
a big way. :)

Thanks,
-Eric
