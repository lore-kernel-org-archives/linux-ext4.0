From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/4] ext4: fix possible use-after-free ext4_remove_li_request()
Date: Fri, 20 May 2011 12:49:31 -0500
Message-ID: <4DD6A9AB.1060501@redhat.com>
References: <1304956630-20384-1-git-send-email-lczerner@redhat.com> <1304956630-20384-4-git-send-email-lczerner@redhat.com> <4DD57827.9060104@redhat.com> <alpine.LFD.2.00.1105201122510.5226@dhcp-27-109.brq.redhat.com> <20110520160313.GA29282@thunk.org> <4DD692D5.6010400@redhat.com> <20110520174719.GD29282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1ETRte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 13:49:34 -0400
In-Reply-To: <20110520174719.GD29282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/20/11 12:47 PM, Ted Ts'o wrote:
> On Fri, May 20, 2011 at 11:12:05AM -0500, Eric Sandeen wrote:
>>
>> But skipping thorough review simply because the window is open now
>> doesn't make sense to me.
> 
> Sure, but adding a 24-hour turnaround for at least simple fix ups
> (commit descriptions, comments, white space, etc) doesn't make a lot
> of sense either.
> 
> 						- Ted

I think you are free to use your discretion for those things :)

I mean if the last review comment is "you have a typo here" and
you really want to make the window, it seems quite reasonable to
fix it up, with a note in the commit log.

-Eric
