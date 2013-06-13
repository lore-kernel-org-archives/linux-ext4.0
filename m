From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 6/6] jbd2: remove debug dependency on debug_fs; update
 help text
Date: Thu, 13 Jun 2013 10:47:04 -0400
Message-ID: <51B9DB68.6080208@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com> <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com> <1370990670-49249-7-git-send-email-paul.gortmaker@windriver.com> <20130613030831.GG16959@thunk.org> <51B9CE63.9000509@windriver.com> <20130613141431.GE13429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:45855 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3FMOqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 10:46:32 -0400
In-Reply-To: <20130613141431.GE13429@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-06-13 10:14 AM, Theodore Ts'o wrote:
> On Thu, Jun 13, 2013 at 09:51:31AM -0400, Paul Gortmaker wrote:
>> On 13-06-12 11:08 PM, Theodore Ts'o wrote:
>>> On Tue, Jun 11, 2013 at 06:44:30PM -0400, Paul Gortmaker wrote:
>>>> commit b6e96d0067d8 ("jbd2: use module parameters instead of debugfs
>>>> for jbd_debug") removed any need for a dependency on DEBUG_FS.  It
>>>> also moved the /sys variables out from underneath the typical debugfs
>>>> mount point.  Delete the dependency and update the /sys path to where
>>>> the debug settings are currently.
>>>>
>>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>>
>>> Applied, thanks.
>>
>> Just a heads up -- it seems some script threw away the 1st line of the
>> commit log here.
> 
> Thanks for noticing this.  Guilt is apparently stripping lines that
> begin with "commit".  Using "Commit" avoids this.

It appears that Guilt is guilty of clobbering the author dates with
the commit date too, which might not be desirable...

https://lkml.org/lkml/2013/6/9/200

Paul.
--

> 
>       	   	      	    	     	    - Ted
> 
