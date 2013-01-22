From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: hole punching in ext4
Date: Tue, 22 Jan 2013 09:30:14 -0600
Message-ID: <50FEB086.4080101@redhat.com>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com> <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab3AVPxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 10:53:12 -0500
In-Reply-To: <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/22/13 8:34 AM, Bradley C. Kuszmaul wrote:
> Hi,
> 
> Do any of the ext file systems support hole punching?  

ext4 does:

[esandeen@host linux-2.6]$ grep -l FALLOC_FL_PUNCH_HOLE fs/ext?/*.[ch]
fs/ext4/extents.c

> If so, do the redhat distributions support it?

Normally a question for Red Hat support, but yes, recent RHEL6
supports punch in ext4.

> Can someone provide an example of a
> program that punches a hole in a file in an ext4 file system?

Upstream fallocate command does with the -p option, for example.

-Eric

> -Bradley
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

