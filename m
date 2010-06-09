From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] Reserve feature flags and fields needed for the Next3
	snapshot feature
Date: Wed, 9 Jun 2010 22:10:56 +0300
Message-ID: <AANLkTimJgK32QwOF7mFQY_LgPtW9AZgSV9ZnNHkC7O55@mail.gmail.com>
References: <1275489795-25639-1-git-send-email-tytso@mit.edu>
	<AANLkTincgBeE9-rzO47RWohcxMPTQRXivY9tLP5l5K5E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab0FITK6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 15:10:58 -0400
Received: by fxm8 with SMTP id 8so3818204fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jun 2010 12:10:56 -0700 (PDT)
In-Reply-To: <AANLkTincgBeE9-rzO47RWohcxMPTQRXivY9tLP5l5K5E@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 3, 2010 at 2:40 PM, Amir G. <amir73il@users.sourceforge.net> wrote:
> On Wed, Jun 2, 2010 at 5:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> The documentation is not (as of this writing) fully complete, but
>> there is some documentation here:
>>
>> http://sourceforge.net/apps/mediawiki/next3/index.php?title=Code_documentation
>> http://sourceforge.net/apps/mediawiki/next3/index.php?title=On-disk_format
>> http://sourceforge.net/projects/next3/files/Next3_Snapshots.pdf/download
>>
>> ... which will hopefully be updated soon to be fully up to date with
>> these assignments and more details about how things work.
>>
>
> Thanks, this is great news :-)
>
> I've updated this page to the finalized format:
> http://sourceforge.net/apps/mediawiki/next3/index.php?title=On-disk_format
>
> I've also added this page to reflect some of your suggestions to the API:
> https://sourceforge.net/apps/mediawiki/next3/index.php?title=User-kernel_API
>
> I'll send you the patches when I finish the migration.
>
> Amir.
>

Hi Ted,

The patch series is ready for download at:
http://sourceforge.net/projects/next3/files/Latest%20patch%20series/e2fsprogs-git-next3-1.0.11_patches.tar.gz/download
(it applies against the master branch)

Next3 version 1.0.11 automatically migrate old on-disk format on mount
and on fsck.
1.0.11 has passed the sanity tests and migration tests, but is still
under regression testing.

CTERA has announced Next3 on Tuesday, see my blog post at:
http://blog.ctera.com/2010/06/story-of-next3-and-thin-provisioned.html

I wanted to thank you for helping me finalize the on-disk format in
time for the announcement
and I hope you will get around to reviewing the patches soon.

Let me know if you want me to post the patches by email or if you want
me to merge them with a difference branch.

Cheers,
Amir.
