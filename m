From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] Reserve feature flags and fields needed for the Next3
	snapshot feature
Date: Thu, 3 Jun 2010 14:40:29 +0300
Message-ID: <AANLkTincgBeE9-rzO47RWohcxMPTQRXivY9tLP5l5K5E@mail.gmail.com>
References: <1275489795-25639-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0FCLkc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 07:40:32 -0400
Received: by bwz11 with SMTP id 11so635545bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 04:40:29 -0700 (PDT)
In-Reply-To: <1275489795-25639-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 2, 2010 at 5:43 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The documentation is not (as of this writing) fully complete, but
> there is some documentation here:
>
> http://sourceforge.net/apps/mediawiki/next3/index.php?title=Code_documentation
> http://sourceforge.net/apps/mediawiki/next3/index.php?title=On-disk_format
> http://sourceforge.net/projects/next3/files/Next3_Snapshots.pdf/download
>
> ... which will hopefully be updated soon to be fully up to date with
> these assignments and more details about how things work.
>

Thanks, this is great news :-)

I've updated this page to the finalized format:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=On-disk_format

I've also added this page to reflect some of your suggestions to the API:
https://sourceforge.net/apps/mediawiki/next3/index.php?title=User-kernel_API

I'll send you the patches when I finish the migration.

Amir.
