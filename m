From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Tue, 13 Sep 2011 09:49:45 -0500
Message-ID: <4E6F6D89.5040905@redhat.com>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab1IMOtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 10:49:47 -0400
In-Reply-To: <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/13/11 4:01 AM, Matt Parnell wrote:

> Interestingly, this also happened and worked, which I think is a bug,
> how can barrier=0 and 1 at the same time?
> 
> EXT4-fs (sdb1): re-mounted. Opts: user_xattr,barrier=1,barrier=0

Fairly certain that the parser will just take the last value specified
for the option.

/proc/mounts likely says "nobarrier" when you specify it this way?

-Eric
