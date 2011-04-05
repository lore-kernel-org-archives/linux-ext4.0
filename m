From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: sync the directory inode in ext4_sync_parent()
Date: Tue, 05 Apr 2011 12:46:07 -0700
Message-ID: <4D9B717F.3010300@redhat.com>
References: <1302031663-13547-1-git-send-email-curtw@google.com>	<4D9B6F0A.5080705@redhat.com> <BANLkTin2VdByS23f0Gg-m77wUr3RVYgkiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab1DETqM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 15:46:12 -0400
In-Reply-To: <BANLkTin2VdByS23f0Gg-m77wUr3RVYgkiQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/5/11 12:43 PM, Curt Wohlgemuth wrote:
> Well, you could argue that a failure to sync the parent shouldn't
> cause the inode's fsync() to fail, but I probably wouldn't :-) .  I'll
> resend a patch that implements this.
> 
> Thanks,
> Curt

It might be a valid argument, since we're doing it "just to be nice" - but if you're getting EIOs you'd probably rather know sooner than later...

-Eric
