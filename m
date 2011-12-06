From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/5 resend] Thaw the journal when you unfreeze the fs.
Date: Tue, 06 Dec 2011 10:22:58 -0600
Message-ID: <4EDE4162.3070200@redhat.com>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>  <1323118489-16326-3-git-send-email-kamal@canonical.com> <1323169644.4838.13.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Matt Fleming <matt@console-pimps.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1LFQXl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Dec 2011 11:23:41 -0500
In-Reply-To: <1323169644.4838.13.camel@mfleming-mobl1.ger.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/6/11 5:07 AM, Matt Fleming wrote:
> On Mon, 2011-12-05 at 12:54 -0800, Kamal Mostafa wrote:
>> From: Surbhi Palande <surbhi.palande@canonical.com>
>>
>> Thaw the journal so that transactions can resume
>>
>> BugLink: https://bugs.launchpad.net/bugs/897421
>> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
>> Cc: Kamal Mostafa <kamal@canonical.com>
>> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
>> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>> ---
>>  fs/ext4/super.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> Shouldn't this patch really be merged with [PATCH 1/5] ? Otherwise it's
> possible to freeze a journal that will never be unfrozen, if say, you're
> doing a git bisect and you have [PATCH 1/5] applied but not [PATCH 2/5].

I second that; I was going to send the same comment but you beat
me to it.  Doing it this way will make it a tough go when bisecting
freeze issues, it needs to be rolled into patch 1.

Thanks,
-Eric
