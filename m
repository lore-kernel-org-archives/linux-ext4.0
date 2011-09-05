From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Fix a possible corruption in dx_probe.
Date: Mon, 05 Sep 2011 10:17:52 +0800
Message-ID: <4E643150.4040904@tao.ma>
References: <1314806452-8763-1-git-send-email-tm@tao.ma> <20110904135740.GD3461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37623 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751693Ab1IECR4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 22:17:56 -0400
In-Reply-To: <20110904135740.GD3461@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/04/2011 09:57 PM, Ted Ts'o wrote:
> On Thu, Sep 01, 2011 at 12:00:52AM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> For all the callers of dx_probe, frame_in is passed in uninitialized.
>> So we should set frame->bh to NULL in the beginning of while, not
>> the end. Otherwise, the first "goto fail2" will try to brelse(frame->bh)
>> while frame->bh is still invalid.
> 
> There's a "frame->bh = NULL" statement at the very beginning of
> dx_probe().   Shouldn't that do the trick?
Oh, sorry for the false alarm.

Thanks
Tao
