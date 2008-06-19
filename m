From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 23:42:46 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0806182341000.2907@woody.linux-foundation.org>
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbYFSGnR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 02:43:17 -0400
In-Reply-To: <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 19 Jun 2008, Dave Airlie wrote:
> 
> This is a bug in rawhide in gcc miscompiling something...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=451068

Gaah. I should read all my email instead of wasting my time trying to 
match up the code with what I can reproduce..

		Linus
