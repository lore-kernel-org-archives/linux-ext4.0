From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Thu, 12 Jun 2014 21:37:52 -0700
Message-ID: <CAKP4w2QzAJWX0_TchDsseKwrW_QeYJcqAk5+JFJoSpRmdJa_TQ@mail.gmail.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
 <539A63C1.8010809@redhat.com> <CAKP4w2Tux8nuWW-uOfY+t+B84=PMmt3sFZ8cA6UMg42dSTo0-A@mail.gmail.com>
 <539A6C07.5090904@redhat.com> <CAKP4w2RPvGNq+qOrNCU_VH=apmesFUEFyfD4YBRdrOBvhef7fQ@mail.gmail.com>
 <539A6EDB.8000409@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59431 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaFMEiN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jun 2014 00:38:13 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so2308888oag.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2014 21:38:12 -0700 (PDT)
In-Reply-To: <539A6EDB.8000409@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2014 at 8:24 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> - I'm talking about whether or not it's a good idea at all;
> see for example Dave's reply.

I see. I'll reply to in his comments.

> This gets back to the "why" - what do you want to accomplish?
> When would a user use this?
> What if they have mounted -o discard,
> or already issued an FITRIM?

Android. No -o discard. A user should not be able to FITRIM.
The system would do the SFITRIM.

> What's the ultimate goal, here?
It was to make sure that data was not left behind after some steps were taken.
And one of the steps seemed to be to replace the FITRIM used in
Android with something better knowing that their was no -o discard
(see my reply to Dave Chinner).

--
