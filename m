From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tests: clean up sed filtering of test output
Date: Mon, 29 Apr 2013 18:35:40 -0600
Message-ID: <36AC98A8-1E7F-4644-903F-157654CD7CBB@dilger.ca>
References: <1367281645-10595-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42269 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D3AfQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 20:35:16 -0400
Received: by mail-ie0-f170.google.com with SMTP id at1so8288539iec.29
        for <linux-ext4@vger.kernel.org>; Mon, 29 Apr 2013 17:35:15 -0700 (PDT)
In-Reply-To: <1367281645-10595-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-29, at 6:27 PM, Andreas Dilger wrote:
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

I found this while trying to test the "-R deprecation" patch.  It
was failing because the "deprecation" message was being eaten, but
the version line was not.

I was considering trying to make the output line-for-line compatible
with the old output, adding in a few "echo" lines to keep the old
whitespace the same, but it didn't seem worthwhile to add complexity
for this.  I don't think there are a huge number of m_* tests out
in the wild that will be broken, but I could be convinced otherwise.

The two patches aren't dependent on each other.

Cheers, Andreas





