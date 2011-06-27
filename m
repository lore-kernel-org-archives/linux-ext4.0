From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Deprecate data=journal mount option
Date: Mon, 27 Jun 2011 19:56:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106271946220.3845@dhcp-27-109.brq.redhat.com>
References: <1309189044-21791-1-git-send-email-lczerner@redhat.com> <37B54DBB-F0DA-40B6-8C0D-448E2E2AF1CD@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"sandeen@redhat.com" <sandeen@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab1F0R46 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 13:56:58 -0400
In-Reply-To: <37B54DBB-F0DA-40B6-8C0D-448E2E2AF1CD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Jun 2011, Andreas Dilger wrote:

> On 2011-06-27, at 9:37 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > Data journalling mode (data=journal) is known to be neglected by
> > developers and only minority of people is actually using it. This
> > mode is also less tested than the other two modes by the developers.
> > 
> > This creates a dangerous combination, because the option which seems
> > *safer* is actually less safe the others. So this commit adds a warning
> > message in case that data=journal mode is used, so the user is informed
> > that the mode has been deprecated and we do not recommend using it.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > fs/ext4/super.c |    4 ++++
> > 1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 9ea71aa..d5a3dea 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1631,6 +1631,10 @@ static int parse_options(char *options, struct super_block *sb,
> >            sbi->s_min_batch_time = option;
> >            break;
> >        case Opt_data_journal:
> > +            ext4_msg(sb, KERN_WARNING,
> > +                 "Using data=journal is not recommended. It "
> > +                 "has been deprecated and can be removed "
> > +                 "in the future");
> 
> I'd rather reword this to be something like:
> 
> Using data=journal may be removed in the future. Contact linux-ext4@vger.kernel.org if you are using this feature.
> 
> And this should at least appear in some vendor kernels (e.g. RHEL6) before we make any decision on whether to remove it.

Hi Andreas,

thanks for the rewording, it sounds better. I kind of miss the mention
of "not supporting it", but that's ok. I agree that we would need some
time before we can really remove the feature. This is just the first
step to be able to remove it sooner :).

Thanks!
-Lukas

> 
> Cheers, Andreas
> 
> 
> >            data_opt = EXT4_MOUNT_JOURNAL_DATA;
> >            goto datacheck;
> >        case Opt_data_ordered:
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
