From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 27/28] ext4: Convert BUG_ON checks to use ext4_error()
 instead
Date: Sat, 06 Mar 2010 23:51:36 -0600
Message-ID: <4B933EE8.8030408@redhat.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu> <1267553925-6308-28-git-send-email-tytso@mit.edu> <87r5nxsitn.fsf@linux.vnet.ibm.com> <20100307024531.GB5395@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frank Mayhar <fmayhar@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0CGFvq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Mar 2010 00:51:46 -0500
In-Reply-To: <20100307024531.GB5395@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Sat, Mar 06, 2010 at 06:33:48PM +0530, Aneesh Kumar K. V wrote:
>> I guess ext4_error and ext4_warning are now not taking __func__. So we
>> to be consistant with thos i this this can be in lower case even though
>> they are #defines.
> 
> Or maybe we should rename them be EXT4_ERROR and EXT4_WARNING.  What
> do other people think?
> 
> 						- Ted


As the originator of the lower-case ext4_error and ext4_warning macros,
I don't much care.

I find the lower case more readable, but if the expectation in fs/extN is 
that ALL_MACROS_SHALL_BE_UPPER_CASE, that's fine by me.

-Eric
