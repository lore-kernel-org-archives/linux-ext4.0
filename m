From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5 v2] tests: Print out list of failed tests
Date: Thu, 15 Sep 2011 23:56:22 -0400
Message-ID: <20110916035622.GV28181@thunk.org>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
 <1313167380-3283-5-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33887 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1IPD4Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 23:56:25 -0400
Content-Disposition: inline
In-Reply-To: <1313167380-3283-5-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 12, 2011 at 06:43:00PM +0200, Lukas Czerner wrote:
> Currently we need to grep, list or just search for failed tests when
> running 'make check' which is annoying. This commit simply prints out
> the list of failed test names at the end of the output.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied to the next branch.

						- Ted
