From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 00/25] e2fsprogs: Misc cleanups & fixes
Date: Fri, 16 Sep 2011 17:27:09 -0500
Message-ID: <4E73CD3D.2060601@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com> <4E73BF52.4090704@redhat.com> <20110916220540.GC16246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab1IPW1N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:27:13 -0400
In-Reply-To: <20110916220540.GC16246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/16/11 5:05 PM, Ted Ts'o wrote:
> On Fri, Sep 16, 2011 at 04:27:46PM -0500, Eric Sandeen wrote:
>>
>> Heh, and I should have pulled from github prior to doing all this.  :(
>>
>> I take back that comment about recent work, at least slightly.
>>
>> Is the quota library really full of void functions which cannot return
>> errors?  My fault for not reviewing while it was on the list, sorry.
> 
> Yeah, the quota library is going to need a lot of fixups before 1.42
> ships.  I don't consider the ABI (or the function naming, since it
> doesn't have any kind of namespace discpline) fixed in stone yet.
> Perhaps I shouldn't have integrated the patches right away but we'll
> get it fixed up before 1.42 goes out the door.

sounds like a plan ... though too bad that's One More Thing which
must be done prior to a 64-bit-capable release :(

by the way, any plans to put a new -WIP-tagged tarball anywhere?

Thanks,
-Eric

>        	     	       	    	     	 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

