From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 corruption on 17TB file system during power cycle test
Date: Wed, 13 Jun 2012 09:42:34 -0500
Message-ID: <4FD8A6DA.90404@redhat.com>
References: <2CE44BD3DBCF9541909CCB42F11CA392828AAC@SFO1EXC-MBXP06.nbttech.com> <4FD89F5C.4040600@redhat.com> <2CE44BD3DBCF9541909CCB42F11CA392828B4D@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ming Lei <Ming.Lei@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2FMOmg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 10:42:36 -0400
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA392828B4D@SFO1EXC-MBXP06.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/13/12 9:30 AM, Ming Lei wrote:
> We actually ran into problem in our real power cycle testing. We used
> fsck -p option and then mount the ext4 file system but during test
> after the power cycle, kernel found EXT4 error and then force ext4
> mount become read only. Do you think the problem is inside kernel?

Hm you said:

> After the box came up, I ran fsck -f to check inconsistency.

But you you say:

> We used fsck -p option an then mount the ext4 filesystem

so which was it?

I'm not clear on the steps you took in this test.

But it's quite possible that userspace log replay left errors that the kernel later discovered.

Again, I'll suggest retesting with e2fprogs-1.42.4, and preferably an upstream kernel.  If you still have problems, we can investigate further.  If it's only present on your distro versions, you can file a bug w/ the distro.

-Eric
