From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v3)
Date: Tue, 29 May 2012 08:23:58 -0600
Message-ID: <4BBC10FC-93A4-4490-B28C-AA1AE59894F6@whamcloud.com>
References: <1338245904-31827-1-git-send-email-adilger@whamcloud.com> <20120529012859.GF5610@thunk.org> <37AFC02E-AB57-4B17-906A-D5FE643B7226@whamcloud.com> <20120529123349.GB16351@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43429 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2E2OYC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 10:24:02 -0400
Received: by pbbrp8 with SMTP id rp8so6013761pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 07:24:02 -0700 (PDT)
In-Reply-To: <20120529123349.GB16351@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-29, at 6:33 AM, Ted Ts'o wrote:
> On Tue, May 29, 2012 at 01:02:11AM -0600, Andreas Dilger wrote:
>> 
>> Hrm, one reason I made the generated files read-only is to avoid
>> accidentally editing the generated copy, and then losing the resulting
>> changes when the file is recreated (as happened several times with the
>> test_script file, when rebasing the patch).  I'd prefer to mark the
>> generated files read-only, and then have the Makefile rules delete the
>> file before recreating it.
> 
> I tend to just edit the foo.in file; the Makefile dependencies
> automatically take care of rebuiling the test_one and test_script
> files --- and it's much easier just to type "make" to retry the
> generated scripts....

Sure, that is what I'm trying to encourage.

>> That avoids accidentally having developers edit the file, while allowing
>> the always-remembering Makefile rule to recreate the file without errors.
> 
> Yeah, but I don't want to encourage developers editing generated
> files...  it's much better to make things much more convenient for
> them to do things in the "right" way.  In the long run that's much
> more effective at avoiding lost work, and it saves you effort (since
> otherwise you might forget to fix the foo.in file before you commit
> the change, etc.)

That's my whole point.  If the generated file is read-only, there is
no way to edit it, and no way to accidentally lose work.  Ideally,
everyone would remember to edit the .in files and this would not be
an issue.   In practise I find myself accidentally editing the
generated files, especially in cases where I don't even know that
the file is generated, since I'm not as familiar with the code as
you.  I expect most other developers are even less familiar than
I am with the generated files.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




