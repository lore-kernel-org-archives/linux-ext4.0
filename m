From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 22:12:07 -0500
Message-ID: <539A6C07.5090904@redhat.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <539A63C1.8010809@redhat.com> <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaFMDMF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2014 23:12:05 -0400
In-Reply-To: <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/12/14, 10:02 PM, JP Abgrall wrote:
> On Thu, Jun 12, 2014 at 7:36 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> IOWS: your commit log says what, but not why.
> 
> Will upload a version with some more "why".
> 
> 
>> You're adding a new high-level IOCTL, so let's get a bit more
>> visibility than just linux-ext4; linux-fsdevel cc'd.
> 
> Wasn't too sure about that one, because I didn't feel like committing
> to other FSes for now even if they do have FITRIM.
> Will remember to include them.

You don't need to implement it for other filesystems, but whether or
not this should be a new fs-level ioctl is something worth airing
out on linux-fsdevel.

Thanks,
-Eric
