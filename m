From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Thu, 16 Aug 2012 17:19:48 -0400
Message-ID: <20120816211948.GF31346@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <CANP3RGdMfM0tZbaJS9dFetRhXoGtyS0Nx4hZER_Qv0a061X_dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45123 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030460Ab2HPVT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 17:19:57 -0400
Content-Disposition: inline
In-Reply-To: <CANP3RGdMfM0tZbaJS9dFetRhXoGtyS0Nx4hZER_Qv0a061X_dQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 01:21:12PM -0700, Maciej =C5=BBenczykowski wrot=
e:
> This would probably be much more readable code if the 'i=3D0' init wa=
s
> before path=3Dkzalloc.

Good point, I agree.  I'll move the initialization so i gets
initialized in both branches of the if statement.

Maciej, you weren't able to reliably repro the crash were you?  I'm
pretty sure this should fix the crash, but it would be really great to
confirm things.

I suspect creating a file system with a really small journal may make
it easier to reproduce, but I haven't had time to try create a
reliable repro for this bug yet.

Thanks,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
