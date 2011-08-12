From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Deprecate data=journal mount option
Date: Fri, 12 Aug 2011 10:16:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108121013280.4535@dhcp-27-109.brq.redhat.com>
References: <1309260363-19012-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108111700500.29009@dhcp-27-109.brq.redhat.com> <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1HLIRE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 04:17:04 -0400
In-Reply-To: <BEF6D87F-AEA5-4BF8-B71D-6BBA540C3731@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 11 Aug 2011, Andreas Dilger wrote:

> On 2011-08-11, at 9:01 AM, Lukas Czerner wrote:
> > On Tue, 28 Jun 2011, Lukas Czerner wrote:
> >> Data journalling mode (data=journal) is known to be neglected by
> >> developers and only minority of people is actually using it. This
> >> mode is also less tested than the other two modes by the developers.
> >> 
> >> This creates a dangerous combination, because the option which seems
> >> *safer* is actually less safe the others. So this commit adds a warning
> >> message in case that data=journal mode is used, so the user is informed
> >> that the mode might be removed in the future.
> > 
> > Any comments on this ? Is that feasible to remove is someday ?
> 
> I'm less in favour of removing data=journal.  Jan made some fixes to
> data=journal mode in the last few weeks, which means that people are
> still using this.

I think that Jan was actually the one who was in favour of this change
IIRC. But you're right that there are still some (very little possibly?)
users of this. But this change does not remove it, but just let the
users know that it might be removed someday, hence discouraging them from
using it.

Also we were discussing that several times, so I think that letting
users know that we are considering it is a good thing.

Thanks!
-Lukas

> 
> >> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> >> ---
> >> fs/ext4/super.c |    5 +++++
> >> 1 files changed, 5 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index 9ea71aa..9d189cf 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -1631,6 +1631,11 @@ static int parse_options(char *options, struct super_block *sb,
> >> 			sbi->s_min_batch_time = option;
> >> 			break;
> >> 		case Opt_data_journal:
> >> +			ext4_msg(sb, KERN_WARNING,
> >> +				 "Using data=journal may be removed in the "
> >> +				 "future. Please, contact "
> >> +				 "linux-ext4@vger.kernel.org if you are "
> >> +				 "using this feature.");
> >> 			data_opt = EXT4_MOUNT_JOURNAL_DATA;
> >> 			goto datacheck;
> >> 		case Opt_data_ordered:
> >> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 

-- 
