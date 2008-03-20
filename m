From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix ext2fs_extent_get for uninit leaf	extents
Date: Thu, 20 Mar 2008 16:04:47 -0500
Message-ID: <47E2D16F.2010407@redhat.com>
References: <47E17582.2030507@redhat.com> <20080320202025.GM13719@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562AbYCTVJI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 17:09:08 -0400
In-Reply-To: <20080320202025.GM13719@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Mar 19, 2008 at 03:20:18PM -0500, Eric Sandeen wrote:
>> Fix ext2fs_extent_get for uninit leaf extents
>>
>> From: Eric Sandeen <sandeen@redhat.com>
> 
> I'm guessing you used git-format-patch but not git-send-mail to send
> out the patch?  Not a big deal, but it meant I had to do a "git commit
> --amend" to edit out the aboe two lines after doing a "git am".
> 
> Suggested workflow that results in a nice patch series being sent to
> linux-ext4, as well as making it easy for a maintainer using git to
> suck it into git:

Thanks... I'm still embarassingly git-illiterate.  Will do better next
time :)

-Eric

> % git-format-patch -n --subject-prefix="PATCH, E2FSPROGS" -o /tmp/to-send master
> 
> 	This creates the patch series for all commits starting at the
> 	branch master (substitute next if you are basing your
> 	development branch off of next, etc.), and places the results
> 	in the directory /tmp/to-send, which will be created if it
> 	doesn't exist.  It will use the first line of the commit log
> 	as the subject line, prefixed with [I/N PATCH, E2FSPROGS],
> 	where I/N will be 1/10, 2/10, 3/10, etc.  "Git am" will take
> 	the subject, strip out what is in square brackets and use that
> 	as the first line of the commit log.
> 
> % git-send-email --to=linux-ext4@vger.kernel.org /tmp/to-send
> 
> 	This will send the patches found in /tmp/to-send to
> 	linux-ext4@vger.kernel.org, appropritaely formated.  If you
> 	want to add an introductory message, add the option --compose
> 	to the above command-line.  If you want to make the patch
> 	series be a reply to some message thread, just note the
> 	Message-ID of the message you want to reply to, and just copy
> 	and paste it into git-send-email when it prompts you to do so.
> 	If you want the patch series to start a new thread, just hit
> 	return when the program prompts you for a In-Reply-To message-ID.
> 
> Anyway, I've applied the patch and it's in the e2fsprogs tree.  Thanks
> for noticing it!
> 
> 						- Ted

