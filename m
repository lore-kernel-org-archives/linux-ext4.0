From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: loopback mount EXT3 oops
Date: Sun, 18 Feb 2007 19:40:23 -0600
Message-ID: <45D90007.5060006@redhat.com>
References: <1171842762.7918.47.camel@localhost.localdomain> <20070218163100.a4b95b3a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>, sct@redhat.com,
	adilger@clusterfs.com,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbXBSBlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Feb 2007 20:41:06 -0500
In-Reply-To: <20070218163100.a4b95b3a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Feb 2007 10:52:42 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> Hi all,
>>
>> 	This happened on 2.6.20-rc6-mm3, so I upgraded to 2.6.20-git14, and
>> same thing happened.  Doing a forced fsck on the (corrupted by
>> double-mounting I think) filesystem fixed it, but I took a copy before
>> doing that.
>>
>> Do we care about ext3 barfing on corrupted filesystems?
...
> 
> I thought Eric fixed that.  Maybe he broke it instead ;)

Eeek... I'll reserve judgment on who broke what until I see that 
corrupted image... ;)  is it available?  How huge?

-Eric
