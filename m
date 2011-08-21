From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Sun, 21 Aug 2011 17:29:07 +0400
Message-ID: <87zkj2dhb0.fsf@dmbot.sw.ru>
References: <1313780769-21713-1-git-send-email-adityakali@google.com> <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger\@dilger.ca" <adilger@dilger.ca>,
	"tytso\@mit.edu" <tytso@mit.edu>, "jack\@suse.cz" <jack@suse.cz>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Aditya Kali <adityakali@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
	Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60472 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1HUN3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Aug 2011 09:29:14 -0400
Received: by bke11 with SMTP id 11so3133903bke.19
        for <linux-ext4@vger.kernel.org>; Sun, 21 Aug 2011 06:29:12 -0700 (PDT)
In-Reply-To: <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > 6) With the QUOTA feature set, since the quota inodes are hidden, some of the
> >   utilities from quota-tools will no longer work correctly. Instead, e2fsprogs
> >   will include support for fixing the quota files.
>
> It would be preferable from a usability point of view to have the existing quota tools to work with the new quota files instead of having to introduce new quota utilities. 

> There are a number of ways that this could be facilitated:
> - make the quota files visible to userspace, but immutable
IMHO direct quota file access is always bad thing, and unfortunately
tools was designed that way, now we have a chance to fix that.
More than less one of the goals of FCQ is to enable quota accounting
on mount. So quota file's content will always be out of date due to
page-cache tricks. But if we export virtual files instead of real ones
this allow to solve both issues at a time. OpenVZ use this trick to
handle per container quota  via unmodified quotatools.
