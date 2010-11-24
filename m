From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add batched discard support for ext3
Date: Wed, 24 Nov 2010 17:35:43 +0100
Message-ID: <20101124163543.GV6113@quack.suse.cz>
References: <1290603991-6151-1-git-send-email-jack@suse.cz>
 <1290603991-6151-2-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1011241555190.3293@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	greg.freemyer@gmail.com, linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011241555190.3293@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 24-11-10 15:56:33, Lukas Czerner wrote:
> On Wed, 24 Nov 2010, Jan Kara wrote:
> > +		if (err < 0) {
> > +			if (err != -EOPNOTSUPP)
> > +				ext3_warning(sb, __func__, "Discard command "
> > +					     "returned error %d\n", err);
> 
> Maybe we can remove this warning completely and let use-space utility
> handle and print out error message ?
  We could but at this point something strange is happening (ENOMEM, EIO,
or something like that) so issuing a warning makes some sense. So I'd be
maybe slightly in favor of keeping the warning.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
