From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Mon, 22 Feb 2010 17:36:20 -0700
Message-ID: <ADD1602D-8D39-4329-9089-A19F7164B0B7@sun.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
 <4B50C78D.2000807@redhat.com> <20100115201521.GE7256@thunk.org>
 <4B50CD5B.9050804@redhat.com>
 <532480951001151347w2f1bf2b2j34bb88b58a766f9c@mail.gmail.com>
 <20100122204715.GA6781@shell>
 <532480951002191656m17ce0880n75cedd0534689365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Valerie Aurora <vaurora@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>, tytso@mit.edu,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56973 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0BWQyf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 11:54:35 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1NGsZ7q015516
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 08:54:35 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KYA00N00ZFX0O00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 23 Feb 2010 08:54:35 -0800 (PST)
In-reply-to: <532480951002191656m17ce0880n75cedd0534689365@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-19, at 17:56, Michael Rubin wrote:
> On Fri, Jan 22, 2010 at 12:47 PM, Valerie Aurora  
> <vaurora@redhat.com> wrote:
>> Don't let the perfect be the enemy of the good. :) I'd love to see
>> what you've got now, even if you have to leave out the closed part  
>> of it.
>
> We are currently reviewing a paper to send out this data.
> Sorry to take so long but we have been very busy with the ext4  
> upgrade.
> We plan on publishing other papers about our experiences with ext4
> this summer also.
> Out of curiosity is there anything anyone is curious about in the file
> system space?


What are you asking for, in particular.  I'd of course be interested  
to know if you have numbers for bandwidth/latency improvements for  
ext4, e2fsck time improvements (if the system is doing this), etc.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

