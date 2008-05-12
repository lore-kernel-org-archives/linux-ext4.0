From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: barriers off by default?
Date: Mon, 12 May 2008 14:15:19 -0500
Message-ID: <48289747.7000301@redhat.com>
References: <482868A5.1000102@redhat.com>	 <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>	 <482883FD.8060001@redhat.com>	 <72c5d9a0805121150j58482bc6qd57a87089ce4414e@mail.gmail.com>	 <72c5d9a0805121151m2d838f3cxe61368b928dc5db2@mail.gmail.com>	 <482893C2.7000709@redhat.com> <72c5d9a0805121211l50e1b136xf33e0b3b7fda103c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric A <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYELTPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 15:15:22 -0400
In-Reply-To: <72c5d9a0805121211l50e1b136xf33e0b3b7fda103c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric A wrote:

> I agree; it's just something that's been bugging me since I started
> searching for a solution for zfs-fuse. Maybe performance is the
> reason? Flushing the write cache is kind of slow.

So is journal=ordered, so is journaling at all for that matter.

But if 32MB of your just-flushed-from-log metadata evaporates on power
loss, it was all a bit of a waste IMHO...

-Eric
