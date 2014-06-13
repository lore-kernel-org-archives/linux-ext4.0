From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 20:19:04 -0700
Message-ID: <CAKP4w2RPvGNq+qOrNCU_VH=apmesFUEFyfD4YBRdrOBvhef7fQ@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com>
 <539A6C07.5090904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35057 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFMDTZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2014 23:19:25 -0400
Received: by mail-ob0-f173.google.com with SMTP id va2so2345414obc.18
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2014 20:19:24 -0700 (PDT)
In-Reply-To: <539A6C07.5090904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 8:12 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 6/12/14, 10:02 PM, JP Abgrall wrote:
>> On Thu, Jun 12, 2014 at 7:36 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> You're adding a new high-level IOCTL, so let's get a bit more
>>> visibility than just linux-ext4; linux-fsdevel cc'd.
>>
>> Wasn't too sure about that one, because I didn't feel like committing
>> to other FSes for now even if they do have FITRIM.
>> Will remember to include them.
>
> You don't need to implement it for other filesystems, but whether or
> not this should be a new fs-level ioctl is something worth airing
> out on linux-fsdevel.

 FITRIM/SFITRIM
vs
 FITRIM/EXT4_IOC_SFITRIM ?

I don't mind either way.
