From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How to disable TRIM
Date: Tue, 01 Jul 2014 09:52:58 -0500
Message-ID: <53B2CB4A.9010408@redhat.com>
References: <CAHohGC8WtcfcsKFd2OjUbeQnUyw7qKmvUYuPtbCjPpQNfLxCaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: rishabh.singh.cse11@iitbhu.ac.in,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbaGAOxB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jul 2014 10:53:01 -0400
In-Reply-To: <CAHohGC8WtcfcsKFd2OjUbeQnUyw7qKmvUYuPtbCjPpQNfLxCaQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/1/14, 12:41 AM, Rishabh Singh B.Tech., CSE, IIT-BHU, Varanasi (INDIA) wrote:
> I have enabled the TRIM option in SSDs by adding "discard" to the
> /etc/fstab.

Removing the discard option does indeed stop "real time" trim/discards 
from being sent by the filesystem when blocks are freed.

> But even after removing the "discard" the TRIM does not
> appear to be disabled.  This I can conclude from the write and read
> speeds. How do I disable it?

Your methodology for reaching your conclusion must be flawed.  :)


(of course you remounted after changing fstab, right, and "discard"
no longer shows up in /proc/mounts for this filesystem?)

-Eric
