From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: clean up sed filtering of test output
Date: Sat, 15 Jun 2013 18:46:25 -0400
Message-ID: <20130615224625.GA32754@thunk.org>
References: <1367281645-10595-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [67.18.176.11] ([67.18.176.11]:58245 "EHLO imap.thunk.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab3FOWrA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Jun 2013 18:47:00 -0400
Content-Disposition: inline
In-Reply-To: <1367281645-10595-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 29, 2013 at 06:27:25PM -0600, Andreas Dilger wrote:
> The sed filters for test outputs that are used to remove build and
> test specific information (such as version strings, dates, times,
> UUIDs) were unconditionally deleting the first line of output.  This
> would normally contain the tool version string, but in some cases
> contained other information that was being lost.  This can lead to
> difficulty debugging test failures.
> 
> The sed filtering has been changed to only remove the actual version
> strings.  As well, similar filter strings were duplicated throughout
> many scripts, and "sed" and "tr" were often called multiple times in
> a pipeline.  These have been consolidated into a single filter.sed
> file to avoid having to maintain these filters in multiple places.
> 
> In a few cases, accidentally deleted messages have been restored to
> the expect output for the tests.  In other cases, trivial whitespace
> has been changed in the expect files.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
