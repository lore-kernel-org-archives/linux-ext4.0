From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 14:44:25 -0600
Message-ID: <4B995629.6020402@redhat.com>
References: <4B991C81.5040506@redhat.com> <20100311194032.GI1497@thunk.org> <4B994A82.8010204@redhat.com> <20100311204020.GK1497@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0CKUob (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 15:44:31 -0500
In-Reply-To: <20100311204020.GK1497@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Thu, Mar 11, 2010 at 01:54:42PM -0600, Eric Sandeen wrote:
>> As long as it doesn't contaminate the "core" then sure, but the more twisty
>> paths we have, the less likely any of them will be maintainable.  :)
>>
>> I just think that before adding more knobs, we need to take a long hard
>> look at what it does to the big picture.  When documenting ext4 upstream,
>> how many "if ... else if ... else if" clauses do we need?
> 
> Fair enough.
> 
> I'm all for proposals to get rid of some knobs, too, if we don't think
> they serve a purpose.  Recent examples that we've started deprecated
> include minixdf --- and I really wonder if we need t have explicit
> mount options to enable xattr and acl's.  Anyone object if we just
> enable them all the time by default?
> 
>               	    	    	    - Ted

I'd be happy with that.  It always bites me when I forget ;)

Do we still need auto_da_alloc as a disable-able option?

-Eric
