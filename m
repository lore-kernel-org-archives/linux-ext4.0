From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: hole punching in ext4
Date: Tue, 22 Jan 2013 11:38:11 -0500
Message-ID: <20130122163811.GB6021@localhost.localdomain>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com>
 <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab3AVQiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 11:38:16 -0500
Content-Disposition: inline
In-Reply-To: <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 supports it, and you can use fallocate(2) with flag FALLOC_FL_PUNCH_HOLE to
dealloc space of a specific file (please see `man 2 fallocate` for more info).

You can use `fallocate` cmdline program to test it.

Ex:

fallocate -p -o 1024 -l 4096 <filename>

fallocate is available on ext4 since linux 3.1 afaik


About Enterprise distros, it's usually better to contact the customer support to
get information about availability/supportability of a specific feature.


Cheers

On Tue, Jan 22, 2013 at 09:34:59AM -0500, Bradley C. Kuszmaul wrote:
> Hi,
> 
> Do any of the ext file systems support hole punching?  If so, do the
> redhat distributions support it?  Can someone provide an example of a
> program that punches a hole in a file in an ext4 file system?
> 
> -Bradley
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
