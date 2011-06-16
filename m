From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Thu, 16 Jun 2011 15:39:07 -0500
Message-ID: <4DFA69EB.3060907@redhat.com>
References: <4D5C1103.8060403@redhat.com> <20110220231015.GA4001@thunk.org> <4D84C5C9.1060507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, mitchb@mit.edu,
	Bruce Cassidy <bruce@whamcloud.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab1FPUjK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2011 16:39:10 -0400
In-Reply-To: <4D84C5C9.1060507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/19/11 10:03 AM, Eric Sandeen wrote:
> On 2/20/11 5:10 PM, Ted Ts'o wrote:
>> On Wed, Feb 16, 2011 at 12:01:39PM -0600, Eric Sandeen wrote:
>>> After debian bug #192277, debian/rules started making a symlink
>>> to com_err.h in /usr/include.  Now I have Fedora bug #550889
>>> for the same issue, and perhaps it's time to make this symlink
>>> by default, rather than fixing it up in packaging steps?
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Pulled into the e2fsprogs tree, with the following change:
>>
>>     [ Changed by tytso to remove the explicit -s option; this will
>>       default to creating a hard link by default, which slightly faster.
>>       If people want to use symlinks for all links during the install
>>       process, they can use configure option --enable-symlink-install.
>>       The reason for this change is that some file systems, like AFS,
>>       don't support symlinks, and AFS users complain when they can't build
>>       or install into AFS.  So I don't want to use symlinks
>>       unconditionally without a way of switching things back and forth,
>>       and it's easier if we just make all links made during the install
>>       process to be hard links or sym links. ]
>>
>>
>>       	      	    	       	      	     - Ted
> 
> Hm, now in a "make rpm" build which has source in one place and rpm build
> area in another:
> 
> /bin/ln: creating hard link `/home/sandeen/rpmbuild/BUILDROOT/e2fsprogs-1.41.14-0.x86_64/usr/include/com_err.h' => `/usr/include/et/com_err.h': Invalid cross-device link
> 
> so I'm not quite sure how to work around this.
> 
> Maybe in the end it does have to be packaging-specific, with the
> link created by the distro pkg scripts...?

Ted, your change broke any builds span 2 different filesystems.

Now what?

-Eric
