From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 22:24:11 -0500
Message-ID: <539A6EDB.8000409@sandeen.net>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <539A63C1.8010809@redhat.com> <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com> <539A6C07.5090904@redhat.com> <CAKP4w2RPvGNq+qOrNCU_VH=apmesFUEFyfD4YBRdrOBvhef7fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35915 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaFMDYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2014 23:24:07 -0400
In-Reply-To: <CAKP4w2RPvGNq+qOrNCU_VH=apmesFUEFyfD4YBRdrOBvhef7fQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/12/14, 10:19 PM, JP Abgrall wrote:
> On Thu, Jun 12, 2014 at 8:12 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 6/12/14, 10:02 PM, JP Abgrall wrote:
>>> On Thu, Jun 12, 2014 at 7:36 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>> You're adding a new high-level IOCTL, so let's get a bit more
>>>> visibility than just linux-ext4; linux-fsdevel cc'd.
>>>
>>> Wasn't too sure about that one, because I didn't feel like committing
>>> to other FSes for now even if they do have FITRIM.
>>> Will remember to include them.
>>
>> You don't need to implement it for other filesystems, but whether or
>> not this should be a new fs-level ioctl is something worth airing
>> out on linux-fsdevel.
> 
>  FITRIM/SFITRIM
> vs
>  FITRIM/EXT4_IOC_SFITRIM ?
> 
> I don't mind either way.

Well, no, I'm not talking about making it another ext4-only implementation
- I'm talking about whether or not it's a good idea at all;
see for example Dave's reply.

If it's deemed a good idea, then yes, define SFITRIM, and implement
it for ext4, and let others follow.

If it's not a good idea then... well, perhaps don't do it at all.

This gets back to the "why" - what do you want to accomplish?
When would a user use this?  What if they have mounted -o discard,
or already issued an FITRIM?

What's the ultimate goal, here?

-Eric
