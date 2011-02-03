From: Michael Rubin <mrubin@google.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Thu, 3 Feb 2011 11:32:01 -0800
Message-ID: <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:16354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1BCTcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 14:32:25 -0500
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com [172.25.105.79])
	by smtp-out.google.com with ESMTP id p13JWN3O010875
	for <linux-ext4@vger.kernel.org>; Thu, 3 Feb 2011 11:32:23 -0800
Received: from yxd30 (yxd30.prod.google.com [10.190.1.222])
	by kpbe15.cbf.corp.google.com with ESMTP id p13JVSwH028287
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Feb 2011 11:32:22 -0800
Received: by yxd30 with SMTP id 30so649830yxd.30
        for <linux-ext4@vger.kernel.org>; Thu, 03 Feb 2011 11:32:22 -0800 (PST)
In-Reply-To: <4D4AC4E2.701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen <sandeen@redhat.com> wrote=
:
> If we can have a real plan for moving in this direction though, I'd
> support it. =A0I'm just not sure how we get enough real testing under
> our belts to be comfortable with dropping ext[23], especially as
> most distros now default to ext4 anyway.

Eric what sort of testing are you looking for?

I admit I like having ext2 around for comparisons in bug situations.
It really helps to isolate the problem area. How painful is the
upkeep?

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
