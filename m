From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] e2fsck: Discard only unused parts of inode table
Date: Tue, 6 Mar 2012 17:22:34 -0500
Message-ID: <20120306222234.GB5472@thunk.org>
References: <1330014566-2020-1-git-send-email-lczerner@redhat.com>
 <4F4D0159.1090409@sandeen.net>
 <alpine.LFD.2.00.1202290812530.4926@dhcp-27-109.brq.redhat.com>
 <4F4FB37F.60405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
	psusi@ubuntu.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58703 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab2CFWWg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 17:22:36 -0500
Content-Disposition: inline
In-Reply-To: <4F4FB37F.60405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 01, 2012 at 11:35:59AM -0600, Eric Sandeen wrote:
> > 
> > So do you want me to separate those unrelated changes to a separate
> > patch ? Those are pretty small changes..
> 
> They are, but they are completely separate fixes, and not described in the changelog.

I agree with Eric; it's a lot better both for me as a maintainer, and
for people who are perusing the git logs / history in the future, to
have things completely separated out.

						- Ted
