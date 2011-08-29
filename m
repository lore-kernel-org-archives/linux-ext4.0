From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Mon, 29 Aug 2011 22:46:02 +0200
Message-ID: <20110829204602.GI5672@quack.suse.cz>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
 <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1H2UqF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Aug 2011 16:46:05 -0400
Content-Disposition: inline
In-Reply-To: <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 20-08-11 09:58:38, Andreas Dilger wrote:
> On 2011-08-19, at 1:06 PM, Aditya Kali <adityakali@google.com> wrote:
> 
> > This patch is an attempt towards supporting quotas as first class
> > feature in ext4. It is based on the proposal at:
> > https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4
> > This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA which, when
> > turned on, enables quota accounting at mount time iteself. 
> 
> > 6) With the QUOTA feature set, since the quota inodes are hidden, some of the
> >   utilities from quota-tools will no longer work correctly. Instead, e2fsprogs
> >   will include support for fixing the quota files.
> 
> It would be preferable from a usability point of view to have the
> existing quota tools to work with the new quota files instead of having
> to introduce new quota utilities. 
  They will generally work - e.g. quota(1), edquota(8), setquota(8)
commands will work just fine. Quotacheck(8) does not make sense when quota
is handled as filesystem metadata and doing necessary things in e2fsck is
not only logical but also faster since it reads all necessary data anyway.
The only pain point is repquota(8) - that needs a new kernel interface to
work reliably (for ocfs2 and xfs we workaround the inability to iterate
over all quota structures from userspace by using getpwent but that's just
ugly).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
