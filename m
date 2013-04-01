From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Mon, 01 Apr 2013 14:49:00 -0500
Message-ID: <5159E4AC.7050307@redhat.com>
References: <51546EED.8030507@redhat.com> <5154AAB4.2000701@redhat.com> <5159A8D5.1000204@redhat.com> <20130401181718.GB22443@thunk.org> <5159D03F.5000606@redhat.com> <20130401190804.GD22443@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465Ab3DATtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 15:49:46 -0400
In-Reply-To: <20130401190804.GD22443@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/1/13 2:08 PM, Theodore Ts'o wrote:
> On Mon, Apr 01, 2013 at 01:21:51PM -0500, Eric Sandeen wrote:
>>> This would allow a bit more flexibility than just requiring that the
>>> ioctl be issued just after the opendir(), and allow it just after a
>>> call to rewinddir().
>>
>> I guess I do wonder what real-world use that might have, though.
> 
> To be honest, I can't think of one.  And if the presumption is this is
> just going to be a special case hack, maybe we shouldn't worry about
> the general-use case.
> 
> Thinking about this some more, keeping this simple might be better way
> to go.  It's not like we really want to be encouraging people to use
> this interface....
> 
> What do you think?

Urgh, I guess if we are adding an interface which will live "forever,"
we may as well make it full featured & flexible, as long as the complexity
isn't out of hand, and I don't think it will be in this case.  So I'm at
least half inclined to go ahead & allow toggling it on and off under the
right circumstances, even though it goes against what I think is my better
judgement.  ;)

-Eric

> 						- Ted
> 

