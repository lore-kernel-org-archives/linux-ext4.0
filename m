From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: fix ext2fs_extent_get for uninit leaf
	extents
Date: Thu, 20 Mar 2008 16:20:25 -0400
Message-ID: <20080320202025.GM13719@mit.edu>
References: <47E17582.2030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61260 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbYCTUVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 16:21:19 -0400
Content-Disposition: inline
In-Reply-To: <47E17582.2030507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 19, 2008 at 03:20:18PM -0500, Eric Sandeen wrote:
> Fix ext2fs_extent_get for uninit leaf extents
> 
> From: Eric Sandeen <sandeen@redhat.com>

I'm guessing you used git-format-patch but not git-send-mail to send
out the patch?  Not a big deal, but it meant I had to do a "git commit
--amend" to edit out the aboe two lines after doing a "git am".

Suggested workflow that results in a nice patch series being sent to
linux-ext4, as well as making it easy for a maintainer using git to
suck it into git:

% git-format-patch -n --subject-prefix="PATCH, E2FSPROGS" -o /tmp/to-send master

	This creates the patch series for all commits starting at the
	branch master (substitute next if you are basing your
	development branch off of next, etc.), and places the results
	in the directory /tmp/to-send, which will be created if it
	doesn't exist.  It will use the first line of the commit log
	as the subject line, prefixed with [I/N PATCH, E2FSPROGS],
	where I/N will be 1/10, 2/10, 3/10, etc.  "Git am" will take
	the subject, strip out what is in square brackets and use that
	as the first line of the commit log.

% git-send-email --to=linux-ext4@vger.kernel.org /tmp/to-send

	This will send the patches found in /tmp/to-send to
	linux-ext4@vger.kernel.org, appropritaely formated.  If you
	want to add an introductory message, add the option --compose
	to the above command-line.  If you want to make the patch
	series be a reply to some message thread, just note the
	Message-ID of the message you want to reply to, and just copy
	and paste it into git-send-email when it prompts you to do so.
	If you want the patch series to start a new thread, just hit
	return when the program prompts you for a In-Reply-To message-ID.

Anyway, I've applied the patch and it's in the e2fsprogs tree.  Thanks
for noticing it!

						- Ted
