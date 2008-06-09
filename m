From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 10871] New: Apparent infinite loop on reading broken filesystem
Date: Sun, 08 Jun 2008 22:38:57 -0500
Message-ID: <484CA5D1.8050709@redhat.com>
References: <bug-10871-27@http.bugzilla.kernel.org/> <20080606111712.7c241070.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbYFIDjA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Jun 2008 23:39:00 -0400
In-Reply-To: <20080606111712.7c241070.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> On Fri,  6 Jun 2008 05:43:38 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=10871
>>
>>            Summary: Apparent infinite loop on reading broken filesystem
> 
> This gentleman has fuzzed his ext2 filesystem and it apparently broke.
> 
> ext3 broke worse, but no details on that yet.
> 
> I cheekily cc'ed Eric on the report as he likes this stuff so much :)

Love it... LOVE IT!  :)

But seriously, it's hard to argue with a reproducible testcase.  :)

-Eric
