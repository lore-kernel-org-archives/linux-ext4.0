From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Check for cases where EOFBLOCKS_FL is unnecessarily
 set
Date: Tue, 11 May 2010 20:10:06 -0500
Message-ID: <4BE9FFEE.9030102@redhat.com>
References: <1273609878-22746-1-git-send-email-tytso@mit.edu> <4BE9D4F3.9080003@redhat.com> <20100512004452.GY18762@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab0ELBKM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 21:10:12 -0400
In-Reply-To: <20100512004452.GY18762@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Tue, May 11, 2010 at 05:06:43PM -0500, Eric Sandeen wrote:
>> Theodore Ts'o wrote:
>>> Some kernels will crash if EOFBLOCKS_FL is set when it is it not
>> Is there a kernel fix to go with this, then?
> 
> There will be; Dmitry sent a patch in the ext4 patch a while back.
> 
> http://patchwork.ozlabs.org/patch/50469/
> 
> The fix to prevent the crash is tiny.  The rest of the patch I need to
> review more carefully....  I'll get to it RSN.

Ok sorry, I didn't put 2 & 2 together, there.  :)

Thanks for the reminder,

-Eric
 
> 					- Ted

