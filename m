From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Fri, 22 Mar 2013 15:36:13 -0400
Message-ID: <20130322193613.GA3987@thunk.org>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
 <877gl0yc2k.fsf@openvz.org>
 <CABFC-fO3HrWFXJhyPMPKRy6Up3vGp_JUQs_VJGRyXwph1M95Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: Greg Harmon <gharm@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55183 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab3CVTgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Mar 2013 15:36:20 -0400
Content-Disposition: inline
In-Reply-To: <CABFC-fO3HrWFXJhyPMPKRy6Up3vGp_JUQs_VJGRyXwph1M95Cw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 22, 2013 at 10:10:46AM -0700, Greg Harmon wrote:
> >>
> >> Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
> 
> Is this a publicly available commit? 

Commit 3c6fe77017bc?  Yes, it landed upstream as v3.2 (try doing git
tag --contains 3c6fe77017bc to find out when it hit upstream).

    	       		       	    	- Ted
