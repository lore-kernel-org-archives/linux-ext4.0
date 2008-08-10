From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Sun, 10 Aug 2008 15:04:00 -0500
Message-ID: <489F49B0.6020105@redhat.com>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <489F2B38.3060104@redhat.com> <20080810182231.GB15353@mit.edu> <489F397A.1040709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbYHJUEE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2008 16:04:04 -0400
In-Reply-To: <489F397A.1040709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> It may be; I tried this and then a quick filefrag run:
> 
> # filefrag  usr/include/*.h | grep -v extents | awk -F : '{print $2}' |
> sort | uniq -c
>     146  1 extent found
> 
> so everything came out contiguous.
> 
> This was with 2.6.27-0.186.rc0.git15.fc10.x86_64

Or better:

# find . -name \*.h | xargs filefrag | grep -v extents | awk -F :
'{print $2}' | sort | uniq -c
   2460  1 extent found

so *really* everything.

-Eric
