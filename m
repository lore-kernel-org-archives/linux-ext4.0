From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch
Date: Sat, 08 Dec 2012 11:31:01 -0600
Message-ID: <50C37955.9090407@redhat.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com> <CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: forrest <forrestl@synology.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888Ab2LHRbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 12:31:05 -0500
In-Reply-To: <CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/4/12 6:29 AM, forrest wrote:
> This problem is easily to reproduce
> 
> Create a file with size larger than 1GB.
> 
> dd if=/dev/zero of=/test_file bs=1M count=1024
> 
> Punch every even block in test_file, and then use debugfs to dump
> extents,  followings is dumped result
> 
>  2/ 2 339/340 231197 - 231197   3917597 -   3917597      1
>  2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>  0/ 2   2/  2 231201 - 262143   3901486              30943
>  1/ 2   1/ 46 231201 - 231880   3901488                680
>  2/ 2   1/340 231201 - 231201   3917601 -   3917601      1
>  2/ 2   2/340 231203 - 231203   3917603 -   3917603      1
> 
> Punch blocks #231779 ~#231201 , 

Can you explain what you mean by the above?  Which blocks get punched?

-Eric

> to remove extent index, and then use
> debugfs to dump extents,  followings is dumped result


