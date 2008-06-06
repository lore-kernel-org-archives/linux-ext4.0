From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 10871] New: Apparent infinite loop on reading broken
 filesystem
Date: Fri, 6 Jun 2008 11:17:12 -0700
Message-ID: <20080606111712.7c241070.akpm@linux-foundation.org>
References: <bug-10871-27@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYFFSSB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:18:01 -0400
In-Reply-To: <bug-10871-27@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri,  6 Jun 2008 05:43:38 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10871
> 
>            Summary: Apparent infinite loop on reading broken filesystem

This gentleman has fuzzed his ext2 filesystem and it apparently broke.

ext3 broke worse, but no details on that yet.

I cheekily cc'ed Eric on the report as he likes this stuff so much :)
