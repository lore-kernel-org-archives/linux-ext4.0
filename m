From: Ted Ts'o <tytso@mit.edu>
Subject: Re: 2.6.32 ext3 assertion j_running_transaction != NULL fails in
 commit.c
Date: Tue, 26 Apr 2011 08:23:38 -0400
Message-ID: <20110426122338.GE9486@thunk.org>
References: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D082BE@EMEADALEXMB1.corp.nai.org>
 <20110425231454.GB9486@thunk.org>
 <BCB84D936723884B91E4CC5CA0A7C54AA4F6D08501@EMEADALEXMB1.corp.nai.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Martin_Zielinski@mcafee.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59841 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1DZMXk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2011 08:23:40 -0400
Content-Disposition: inline
In-Reply-To: <BCB84D936723884B91E4CC5CA0A7C54AA4F6D08501@EMEADALEXMB1.corp.nai.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 04:07:11AM -0500, Martin_Zielinski@mcafee.com wrote:
> Ted!
> Thank you a lot!
> We observed this bug on ~10 out of 40 machines after an uptime from about 3 weeks. All run under comparable conditions.
> I will have a closer look on the debugfs output to verify if the situation can  happen within this short time range. Additionally we installed a crash kernel and I changed the BUG into a panic(). 
> So I will be able to look at the journal structure if this happens again.

If you would be willing to install the debugging code that is in the
jbd2 patch into the jbd patch, and this put this on your production
machines, that would be really great.  I can send you a revised jbd
patch if that would help (the debugging in code in jbd2 should move
over to the jbd patch really simply).

							- Ted
